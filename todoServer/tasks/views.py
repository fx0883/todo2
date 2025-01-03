from django.shortcuts import render
from rest_framework import viewsets, status, filters
from rest_framework.generics import get_object_or_404
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from django_filters.rest_framework import DjangoFilterBackend
from drf_spectacular.utils import extend_schema_view, extend_schema, OpenApiExample, OpenApiResponse, OpenApiParameter
from .models import Category, Task, TaskComment, RepeatTask, RepeatTaskDate
from .serializers import CategorySerializer, TaskSerializer, TaskCommentSerializer, RepeatTaskSerializer
from .tasks import create_future_task_instances
from rest_framework.pagination import PageNumberPagination
from rest_framework.decorators import action
from django.utils import timezone
from datetime import datetime, timedelta
from django.db.models import Q, F, Case, When, BooleanField, ExpressionWrapper, FloatField
from rest_framework.views import APIView
from collections import defaultdict
from datetime import time

# 添加分页器类
class TaskPagination(PageNumberPagination):
    """任务列表分页器"""
    page_size = 10  # 每页默认数量
    page_size_query_param = 'page_size'  # 允许客户端通过此参数指定每页数量
    max_page_size = 100  # 每页最大数量
    page_query_param = 'page'  # 页码参数名称

@extend_schema_view(
    list=extend_schema(
        summary="获取分类列表",
        tags=['分类管理'],
        responses={
            200: OpenApiResponse(
                description="成功获取分类列表",
                examples=[
                    OpenApiExample(
                        'Category List Example',
                        value=[{
                            'id': 1,
                            'name': '工作',
                            'color': '#FF5733',
                            'icon': 'work',
                            'order': 1
                        }, {
                            'id': 2,
                            'name': '生活',
                            'color': '#33FF57',
                            'icon': 'life',
                            'order': 2
                        }]
                    )
                ]
            )
        }
    ),
    create=extend_schema(
        summary="创建分类",
        tags=['分类管理'],
        request=CategorySerializer,
        examples=[
            OpenApiExample(
                'Create Category Example',
                value={
                    'name': '学习',
                    'color': '#3357FF',
                    'icon': 'study',
                    'order': 3
                }
            )
        ]
    ),
    retrieve=extend_schema(
        summary="获取分类详情",
        tags=['分类管理']
    ),
    update=extend_schema(
        summary="更新分类",
        tags=['分类管理']
    ),
    partial_update=extend_schema(
        summary="部分更新分类",
        tags=['分类管理']
    ),
    destroy=extend_schema(
        summary="删除分类",
        tags=['分类管理']
    )
)
class CategoryViewSet(viewsets.ModelViewSet):
    serializer_class = CategorySerializer
    permission_classes = [IsAuthenticated]
    filter_backends = [filters.SearchFilter]
    search_fields = ['name']

    def get_queryset(self):
        return Category.objects.filter(user=self.request.user)

    def create(self, request, *args, **kwargs):
        # 检查当前用户是否已有同名分类
        name = request.data.get('name')
        if Category.objects.filter(user=request.user, name=name).exists():
            return Response(
                {"error": "分类名称已存在"},
                status=status.HTTP_400_BAD_REQUEST
            )
            
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        serializer.save(user=request.user)
        
        headers = self.get_success_headers(serializer.data)
        return Response(serializer.data, status=status.HTTP_201_CREATED, headers=headers)

    def destroy(self, request, *args, **kwargs):
        category = self.get_object()
        
        # 将该分类下的所有任务的分类字段设置为空
        Task.objects.filter(category=category).update(category=None)
        
        # 删除分类
        category.delete()
        
        return Response(status=status.HTTP_204_NO_CONTENT)

@extend_schema_view(
    list=extend_schema(
        summary="获取任务列表",
        tags=['任务管理'],
        parameters=[
            {
                'name': 'page',
                'in': 'query',
                'description': '页码',
                'required': False,
                'type': 'integer',
                'default': 1
            },
            {
                'name': 'page_size',
                'in': 'query',
                'description': '每页数量',
                'required': False,
                'type': 'integer',
                'default': 10
            },
            {
                'name': 'status',
                'in': 'query',
                'description': '任务状态: pending, completed, archived',
                'required': False,
                'type': 'string'
            },
            {
                'name': 'category',
                'in': 'query',
                'description': '分类ID',
                'required': False,
                'type': 'integer'
            },
            {
                'name': 'priority',
                'in': 'query',
                'description': '优先级: 1(低), 2(中), 3(高)',
                'required': False,
                'type': 'integer'
            },
            {
                'name': 'is_important',
                'in': 'query',
                'description': '是否重要',
                'required': False,
                'type': 'boolean'
            },
            {
                'name': 'show_expired',
                'in': 'query',
                'description': '是否显示过期任务',
                'required': False,
                'type': 'boolean'
            },
            {
                'name': 'start_date',
                'in': 'query',
                'description': '开始日期（YYYY-MM-DD）',
                'required': False,
                'type': 'string'
            },
            {
                'name': 'end_date',
                'in': 'query',
                'description': '结束日期（YYYY-MM-DD）',
                'required': False,
                'type': 'string'
            },
            {
                'name': 'date',
                'in': 'query',
                'description': '日期（YYYY-MM-DD）',
                'required': False,
                'type': 'string'
            }
        ],
        responses={
            200: OpenApiResponse(
                description="成功获取任务列表",
                examples=[
                    OpenApiExample(
                        'Task List Example',
                        value={
                            'count': 100,  # 总数量
                            'next': 'http://localhost:8000/api/v1/tasks/tasks/?page=2',  # 下一页链接
                            'previous': None,  # 上一页链接
                            'results': [{  # 当前页数据
                                'id': 1,
                                'title': '完成项目报告',
                                'description': '准备第四季度项目总结报告',
                                'start_time': '2024-01-01T09:00:00Z',
                                'due_date': '2024-12-31T23:59:59Z',
                                'priority': 2,
                                'status': 'pending',
                                'category': 1,
                                'is_important': True,
                                'order': 1
                            }]
                        }
                    )
                ]
            )
        }
    ),
    create=extend_schema(
        summary="创建任务",
        tags=['任务管理'],
        description="""
        创建新任务，支持创建普通任务和重复任务。

        时间规则：
        1. due_date（结束时间）为必填字段
        2. start_time（开始时间）若未指定，将使用当前时间
        3. 结束时间必须大于开始时间
        
        重复任务类型(repeat_type)：
        - none: 不重复
        - daily: 每天
        - weekly: 每周
        - monthly: 每月
        - yearly: 每年
        - continuous: 一直重复
        - workdays: 工作日重复
        - weekends: 周末重复
        - holidays: 节假日重复
        - custom: 自定义重复
        
        重复配置(repeat_config)示例：
        ```json
        {
            "start_date": "2024-01-01",     # 开始日期（必填）
            "end_date": "2024-12-31",       # 结束日期（可选）
            "interval": 1,                   # 重复间隔（可选，默认1）
            "custom_days": [0,2,4]          # 自定义重复时必填，0-6表示周一到周日
        }
        ```
        """,
        request=OpenApiExample(
            'Task Create Example',
            value={
                # 普通任务示例
                "title": "项目会议",
                "description": "讨论第四季度项目计划",
                "due_date": "2024-01-01T10:00:00Z",  # 必填
                "start_time": "2024-01-01T09:00:00Z",  # 可选，默认为当前时间
                "priority": 2,
                "category": 1,
                "reminder_time": "2024-01-01T09:30:00Z",
                "is_important": True
            },
            summary="创建普通任务"
        ),
        examples=[
            OpenApiExample(
                'Regular Task Example',
                value={
                    "title": "项目会议",
                    "description": "讨论第四季度项目计划",
                    "due_date": "2024-01-01T10:00:00Z",
                    "start_time": "2024-01-01T09:00:00Z",
                    "priority": 2,
                    "category": 1,
                    "reminder_time": "2024-01-01T09:30:00Z",
                    "is_important": True
                },
                summary="创建普通任务示例"
            ),
            OpenApiExample(
                'Repeat Task Example',
                value={
                    "title": "每周例会",
                    "description": "团队周会",
                    "repeat_type": "weekly",
                    "repeat_config": {
                        "start_date": "2024-01-01",
                        "custom_days": [0],  # 每周一
                        "interval": 1
                    },
                    "due_date": "2024-01-01T10:30:00Z",
                    "start_time": "2024-01-01T09:00:00Z",
                    "priority": 2,
                    "category": 1,
                    "reminder_time": "2024-01-01T09:30:00Z",
                    "is_important": True
                },
                summary="创建重复任务示例"
            ),
            OpenApiExample(
                'Custom Repeat Task Example',
                value={
                    "title": "健身计划",
                    "description": "每周三次健身",
                    "repeat_type": "custom",
                    "repeat_config": {
                        "start_date": "2024-01-01",
                        "custom_days": [0, 2, 4],  # 周一、三、五
                        "interval": 1
                    },
                    "due_date": "2024-01-01T11:00:00Z",
                    "start_time": "2024-01-01T09:00:00Z",
                    "priority": 2,
                    "category": 1
                },
                summary="创建自定义重复任务示例"
            )
        ],
        responses={
            201: OpenApiResponse(
                response=TaskSerializer,
                description="任务创建成功"
            ),
            400: OpenApiResponse(
                description="请求数据验证失败",
                examples=[
                    OpenApiExample(
                        'Validation Error',
                        value={
                            "due_date": ["任务必须设置结束时间。"],
                            "title": ["这个字段是必需的。"]
                        }
                    ),
                    OpenApiExample(
                        'Time Validation Error',
                        value={
                            "due_date": ["结束时间必须大于开始时间。"]
                        }
                    )
                ]
            )
        }
    ),
    update=extend_schema(
        summary="更新任务",
        tags=['任务管理'],
        description="""
        更新任务信息，支持更新普通任务和重复任务。
        
        更新模式(update_mode)：
        - single: 只更新当前任务实例（默认）
        - future: 更新当前和未来的任务实例
        - all: 更新所有任务实例（包括历史记录）
        """
    ),
    retrieve=extend_schema(
        summary="获取任务详情",
        tags=['任务管理']
    ),
    partial_update=extend_schema(
        summary="部分更新任务",
        tags=['任务管理']
    ),
    destroy=extend_schema(
        summary="删除任务",
        tags=['任务管理']
    )
)
class TaskViewSet(viewsets.ModelViewSet):
    serializer_class = TaskSerializer
    permission_classes = [IsAuthenticated]
    filter_backends = [DjangoFilterBackend, filters.SearchFilter, filters.OrderingFilter]
    filterset_fields = ['status', 'priority', 'category']
    search_fields = ['title', 'description']
    ordering_fields = ['created_at', 'updated_at', 'due_date', 'priority']
    ordering = ['-created_at']
    pagination_class = TaskPagination

    def get_queryset(self):
        """获取任务列表"""
        queryset = super().get_queryset()
        
        # 基本过滤
        status = self.request.query_params.get('status')
        category = self.request.query_params.get('category')
        priority = self.request.query_params.get('priority')
        is_important = self.request.query_params.get('is_important')
        
        if status:
            queryset = queryset.filter(status=status)
        if category:
            queryset = queryset.filter(category_id=category)
        if priority:
            queryset = queryset.filter(priority=priority)
        if is_important:
            queryset = queryset.filter(is_important=is_important)
            
        # 处理日期查询
        query_date = self.request.query_params.get('date')
        if query_date:
            try:
                target_date = datetime.strptime(query_date, '%Y-%m-%d').date()
                
                # 查找当天的普通任务和重复任务
                repeat_task_ids = RepeatTaskDate.objects.filter(
                    task_date=target_date,
                    repeat_task__user=self.request.user
                ).values_list('repeat_task_id', flat=True)
                
                # 构建查询条件
                date_condition = Q(
                    # 普通任务条件：在目标日期范围内
                    Q(
                        Q(start_time__date__lte=target_date) &
                        Q(due_date__date__gte=target_date) &
                        Q(repeat_task__isnull=True)  # 非重复任务
                    ) |
                    # 重复任务条件：有对应的日期记录
                    Q(repeat_task_id__in=repeat_task_ids)
                )
                
                queryset = queryset.filter(date_condition)
                
                # 对于重复任务，我们需要动态设置其时间
                tasks = list(queryset)
                for task in tasks:
                    if task.repeat_task_id in repeat_task_ids:
                        task.start_time = datetime.combine(target_date, time.min)
                        task.due_date = datetime.combine(target_date, time.max)
                        task.start_time = timezone.make_aware(task.start_time)
                        task.due_date = timezone.make_aware(task.due_date)
                
                return tasks
                
            except ValueError:
                pass
        
        return queryset

    def perform_create(self, serializer):
        """创建任务"""
        # 获取重复任务配置
        repeat_type = self.request.data.get('repeat_type')
        repeat_config = self.request.data.get('repeat_config')
        
        # 如果是重复任务
        if repeat_type and repeat_config:
            # 验证重复任务配置
            if not repeat_config.get('start_date'):
                raise ValidationError({'repeat_config': {'start_date': 'Start date is required for repeat tasks.'}})
            
            # 创建重复任务记录
            repeat_task = RepeatTask.objects.create(
                user=self.request.user,
                title=serializer.validated_data['title'],
                description=serializer.validated_data.get('description', ''),
                category=serializer.validated_data.get('category'),
                repeat_type=repeat_type,
                repeat_config=repeat_config,
                is_active=True
            )
            
            # 计算第一个任务实例的时间
            base_start_time = serializer.validated_data.get('start_time')
            if not base_start_time:
                base_start_time = timezone.now()
            
            start_time, due_date = repeat_task.calculate_first_instance_time(base_start_time)
            
            if start_time and due_date:
                # 更新序列化器中的时间
                serializer.validated_data['start_time'] = start_time
                serializer.validated_data['due_date'] = due_date
                serializer.validated_data['repeat_task'] = repeat_task
                
                # 生成未来90天的日期记录
                repeat_task.generate_dates()
            else:
                repeat_task.delete()
                raise ValidationError({'repeat_config': 'Invalid repeat configuration'})
        
        # 保存任务
        task = serializer.save(user=self.request.user)
        return task

    def update(self, request, *args, **kwargs):
        """
        更新任务，支持重复任务的批量更新
        
        update_mode:
        - single: 只更新当前任务实例（默认）
        - future: 更新当前和未来的任务实例
        - all: 更新所有任务实例（包括历史记录）
        """
        instance = self.get_object()
        update_mode = request.query_params.get('update_mode', 'single')
        
        # 如果是重复任务，需要处理关联实例
        if instance.repeat_task:
            allowed_fields = {
                'title', 'description', 'category', 'priority',
                'reminder_time', 'is_important', 'tags'
            }
            # 过滤出允许批量更新的字段
            update_data = {
                k: v for k, v in request.data.items()
                if k in allowed_fields
            }
            
            if update_mode in ['future', 'all']:
                # 更新重复任务主记录
                repeat_task = instance.repeat_task
                for field in ['title', 'description', 'category']:
                    if field in update_data:
                        setattr(repeat_task, field, update_data[field])
                repeat_task.save()
                
                # 获取需要更新的实例
                instances = Task.objects.filter(repeat_task=repeat_task)
                if update_mode == 'future':
                    instances = instances.filter(
                        Q(scheduled_date__gt=timezone.now()) |
                        Q(id=instance.id)  # 包含当前实例
                    )
                
                # 批量更新实例
                instances.update(**update_data)
                
                # 返回更新后的当前实例
                serializer = self.get_serializer(instance)
                return Response(serializer.data)
        
        # 非重复任务或仅更新单个实例
        return super().update(request, *args, **kwargs)

    @action(detail=False, methods=['post'])
    def bulk_update(self, request):
        """
        批量更新任务
        
        请求数据格式：
        {
            "task_ids": [1, 2, 3],
            "update_data": {
                "status": "completed",
                "priority": 2,
                ...
            },
            "update_mode": "single"  # 可选，仅适用于重复任务
        }
        """
        task_ids = request.data.get('task_ids', [])
        update_data = request.data.get('update_data', {})
        update_mode = request.data.get('update_mode', 'single')
        
        if not task_ids or not update_data:
            return Response(
                {"error": "必须提供任务ID列表和更新数据"},
                status=status.HTTP_400_BAD_REQUEST
            )
        
        # 获取用户的任务
        tasks = Task.objects.filter(
            id__in=task_ids,
            user=request.user
        )
        
        # 按重复任务分组处理
        repeat_tasks = defaultdict(list)
        non_repeat_tasks = []
        
        for task in tasks:
            if task.repeat_task:
                repeat_tasks[task.repeat_task.id].append(task)
            else:
                non_repeat_tasks.append(task)
        
        # 处理重复任务
        for repeat_task_id, instances in repeat_tasks.items():
            if update_mode in ['future', 'all']:
                repeat_task = RepeatTask.objects.get(id=repeat_task_id)
                # 更新重复任务主记录
                for field in ['title', 'description', 'category']:
                    if field in update_data:
                        setattr(repeat_task, field, update_data[field])
                repeat_task.save()
                
                # 获取需要更新的实例
                if update_mode == 'future':
                    instances = Task.objects.filter(
                        repeat_task=repeat_task,
                        scheduled_date__gte=timezone.now()
                    )
                else:  # all
                    instances = Task.objects.filter(repeat_task=repeat_task)
            
            # 更新实例
            instances.update(**update_data)
        
        # 处理非重复任务
        if non_repeat_tasks:
            Task.objects.filter(id__in=[t.id for t in non_repeat_tasks]).update(**update_data)
        
        return Response(status=status.HTTP_200_OK)

    @action(detail=True, methods=['post'])
    def sync_instances(self, request, pk=None):
        """
        同步重复任务实例的状态
        
        用于手动触发重复任务实例的同步，通常在修改重复规则后调用
        """
        instance = self.get_object()
        if not instance.repeat_task:
            return Response(
                {"error": "只能同步重复任务"},
                status=status.HTTP_400_BAD_REQUEST
            )
        
        # 删除未来的任务实例
        Task.objects.filter(
            repeat_task=instance.repeat_task,
            scheduled_date__gt=timezone.now()
        ).delete()
        
        # 重新创建未来的任务实例
        create_future_task_instances.delay(instance.repeat_task.id)
        
        return Response({"message": "同步任务已启动"})

    @action(detail=False, methods=['get'])
    def expired(self, request):
        """获取已过期的任务列表"""
        queryset = self.get_queryset().filter(
            due_date__lt=timezone.now(),
            status='pending'
        )
        page = self.paginate_queryset(queryset)
        if page is not None:
            serializer = self.get_serializer(page, many=True)
            return self.get_paginated_response(serializer.data)
        serializer = self.get_serializer(queryset, many=True)
        return Response(serializer.data)

@extend_schema_view(
    list=extend_schema(
        summary="获取任务评论列表",
        tags=['任务评论']
    ),
    create=extend_schema(
        summary="创建任务评论",
        tags=['任务评论']
    ),
    retrieve=extend_schema(
        summary="获取任务评论详情",
        tags=['任务评论']
    ),
    update=extend_schema(
        summary="更新任务评论",
        tags=['任务评论']
    ),
    partial_update=extend_schema(
        summary="部分更新任务评论",
        tags=['任务评论']
    ),
    destroy=extend_schema(
        summary="删除任务评论",
        tags=['任务评论']
    )
)
class TaskCommentViewSet(viewsets.ModelViewSet):
    serializer_class = TaskCommentSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        return TaskComment.objects.filter(
            task__user=self.request.user,
            task_id=self.kwargs.get('task_pk')
        )

    def perform_create(self, serializer):
        serializer.save(user=self.request.user)


class MonthStatsView(APIView):
    permission_classes = [IsAuthenticated]

    @extend_schema(
        summary="获取指定月份的任务统计数据",
        tags=['统计'],
        parameters=[
            OpenApiParameter(name='month', type=str, description='月份，格式：YYYY-MM，例如：2023-12')
        ]
    )
    def get(self, request, month):
        """获取月度统计数据"""
        try:
            # 解析月份参数 (格式: YYYY-MM)
            year, month = map(int, month.split('-'))
            start_date = datetime(year, month, 1)
            if month == 12:
                end_date = datetime(year + 1, 1, 1)
            else:
                end_date = datetime(year, month + 1, 1)

            # 获取用户在指定月份的所有任务
            tasks = Task.objects.filter(
                user=request.user,
                created_at__gte=start_date,
                created_at__lt=end_date
            )

            # 统计数据
            total = tasks.count()
            completed = tasks.filter(status='completed').count()
            pending = tasks.filter(status='pending').count()
            overdue = tasks.filter(
                status='pending',
                due_date__lt=timezone.now()
            ).count()

            return Response({
                'total': total,
                'completed': completed,
                'pending': pending,
                'overdue': overdue
            })
        except ValueError:
            return Response({'error': 'Invalid month format'}, status=400)
        except Exception as e:
            return Response({'error': str(e)}, status=500)


class CategoryStatsView(APIView):
    permission_classes = [IsAuthenticated]

    @extend_schema(
        summary="获取指定月份的任务分类统计数据",
        tags=['统计'],
        parameters=[
            OpenApiParameter(name='month', type=str, description='月份，格式：YYYY-MM，例如：2023-12')
        ]
    )
    def get(self, request, month):
        """获取分类统计数据"""
        try:
            # 解析月份参数 (格式: YYYY-MM)
            year, month = map(int, month.split('-'))
            start_date = datetime(year, month, 1)
            if month == 12:
                end_date = datetime(year + 1, 1, 1)
            else:
                end_date = datetime(year, month + 1, 1)

            # 获取每个分类的任务数量
            categories = Category.objects.filter(user=request.user)
            stats = []
            
            for category in categories:
                task_count = Task.objects.filter(
                    user=request.user,
                    category=category,
                    created_at__gte=start_date,
                    created_at__lt=end_date
                ).count()
                
                if task_count > 0:  # 只返回有任务的分类
                    stats.append({
                        'name': category.name,
                        'value': task_count  # 使用 value 而不是 count，以符合 ECharts 数据格式
                    })

            return Response(stats)
        except ValueError:
            return Response({'error': 'Invalid month format'}, status=400)
        except Exception as e:
            return Response({'error': str(e)}, status=500)


class DailyTrendView(APIView):
    permission_classes = [IsAuthenticated]

    @extend_schema(
        summary="获取指定月份的每日任务完成趋势",
        tags=['统计'],
        parameters=[
            OpenApiParameter(name='month', type=str, description='月份，格式：YYYY-MM，例如：2023-12')
        ]
    )
    def get(self, request, month):
        """获取每日完成趋势数据"""
        try:
            # 解析月份参数 (格式: YYYY-MM)
            year, month = map(int, month.split('-'))
            start_date = datetime(year, month, 1)
            if month == 12:
                end_date = datetime(year + 1, 1, 1)
            else:
                end_date = datetime(year, month + 1, 1)

            # 获取每天完成的任务数量
            daily_stats = []
            current_date = start_date
            
            while current_date < end_date:
                next_date = current_date + timedelta(days=1)
                completed_count = Task.objects.filter(
                    user=request.user,
                    status='completed',
                    completed_at__gte=current_date,
                    completed_at__lt=next_date
                ).count()
                
                daily_stats.append({
                    'date': current_date.strftime('%Y-%m-%d'),
                    'count': completed_count
                })
                
                current_date = next_date

            return Response(daily_stats)
        except ValueError:
            return Response({'error': 'Invalid month format'}, status=400)
        except Exception as e:
            return Response({'error': str(e)}, status=500)


class PriorityStatsView(APIView):
    permission_classes = [IsAuthenticated]

    @extend_schema(
        summary="获取指定月份的任务优先级分布统计",
        tags=['统计'],
        parameters=[
            OpenApiParameter(name='month', type=str, description='月份，格式：YYYY-MM，例如：2023-12')
        ]
    )
    def get(self, request, month):
        """获取优先级分布统计数据"""
        try:
            # 解析月份参数 (格式: YYYY-MM)
            year, month = map(int, month.split('-'))
            start_date = datetime(year, month, 1)
            if month == 12:
                end_date = datetime(year + 1, 1, 1)
            else:
                end_date = datetime(year, month + 1, 1)

            # 获取每个优先级的任务数量
            stats = {
                'high': Task.objects.filter(
                    user=request.user,
                    priority=3,  # 高优先级
                    created_at__gte=start_date,
                    created_at__lt=end_date
                ).count(),
                'medium': Task.objects.filter(
                    user=request.user,
                    priority=2,  # 中优先级
                    created_at__gte=start_date,
                    created_at__lt=end_date
                ).count(),
                'low': Task.objects.filter(
                    user=request.user,
                    priority=1,  # 低优先级
                    created_at__gte=start_date,
                    created_at__lt=end_date
                ).count()
            }

            return Response(stats)
        except ValueError:
            return Response({'error': 'Invalid month format'}, status=400)
        except Exception as e:
            return Response({'error': str(e)}, status=500)
