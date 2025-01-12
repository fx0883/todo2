from django.shortcuts import get_object_or_404
from rest_framework import viewsets, status
from rest_framework.views import APIView
from rest_framework.decorators import action
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from django.utils import timezone
from django.db.models import Q
from .models import Category, Task, TaskComment, RepeatTask
from .serializers import CategorySerializer, TaskSerializer, TaskCommentSerializer, RepeatTaskSerializer
from .tasks import create_future_task_instances
from rest_framework.pagination import PageNumberPagination
from rest_framework.filters import SearchFilter, OrderingFilter
from django_filters.rest_framework import DjangoFilterBackend
from drf_spectacular.utils import extend_schema_view, extend_schema, OpenApiExample, OpenApiResponse, OpenApiParameter
from datetime import datetime, timedelta
from collections import defaultdict

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
    filter_backends = [SearchFilter]
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
        description="""
        获取用户的任务列表。支持以下功能：
        
        1. 日期范围过滤
        - start_date: 开始日期（YYYY-MM-DD）
        - end_date: 结束日期（YYYY-MM-DD）
        如果不指定日期范围，默认返回从当前日期开始的一个月内的任务
        
        2. 状态过滤
        - status: 任务状态 (pending/in_progress/completed/cancelled)
        
        3. 优先级过滤
        - priority: 优先级 (1-5)
        
        4. 分类过滤
        - category: 分类ID
        
        5. 重要性过滤
        - is_important: 是否重要 (true/false)
        
        6. 搜索
        - search: 搜索关键词（搜索标题和描述）
        
        7. 排序
        - ordering: 排序字段
          - created_at: 创建时间
          - -created_at: 创建时间倒序
          - due_date: 截止时间
          - -due_date: 截止时间倒序
        
        对于重复任务：
        - 系统会自动在查询的时间范围内创建重复任务的实例
        - 重复任务实例的开始时间和结束时间基于重复任务的配置
        - 已结束的重复任务不会创建新的实例
        """,
        parameters=[
            OpenApiParameter(
                name='start_date',
                description='开始日期（YYYY-MM-DD）',
                required=False,
                type=str,
            ),
            OpenApiParameter(
                name='end_date',
                description='结束日期（YYYY-MM-DD）',
                required=False,
                type=str,
            ),
            OpenApiParameter(
                name='status',
                description='任务状态',
                required=False,
                type=str,
                enum=['pending', 'in_progress', 'completed', 'cancelled']
            ),
            OpenApiParameter(
                name='priority',
                description='优先级',
                required=False,
                type=int,
                enum=[1, 2, 3, 4, 5]
            ),
            OpenApiParameter(
                name='category',
                description='分类ID',
                required=False,
                type=int,
            ),
            OpenApiParameter(
                name='is_important',
                description='是否重要',
                required=False,
                type=bool,
            ),
            OpenApiParameter(
                name='search',
                description='搜索关键词',
                required=False,
                type=str,
            ),
            OpenApiParameter(
                name='ordering',
                description='排序字段',
                required=False,
                type=str,
                enum=['created_at', '-created_at', 'due_date', '-due_date']
            ),
        ]
    ),
    create=extend_schema(
        summary="创建任务",
        tags=['任务管理'],
        description="""
        创建新任务。支持创建普通任务和重复任务。
        
        必填字段：
        - title: 任务标题
        - due_date: 结束时间（对于普通任务）
        
        重复任务配置说明：
        1. repeat_type: 重复类型
           - daily: 每天重复
           - weekly: 每周重复
           - monthly: 每月重复（日期不能大于28）
           - workdays: 工作日重复（周一至周五）
           - weekends: 周末重复（周六和周日）
           - custom: 自定义重复
        
        2. repeat_config: 重复配置
           必填字段：
           - start_date: 开始日期（YYYY-MM-DD）
           - start_time: 每次重复的开始时间（HH:MM）
           - end_time: 每次重复的结束时间（HH:MM）
           
           可选字段：
           - end_date: 结束日期（YYYY-MM-DD）
           - interval: 重复间隔（默认为1）
           - custom_days: 自定义重复日期（custom类型必填）
             - 0-6 表示周一至周日
             - 例如 [0, 2, 4] 表示每周一、三、五重复
        """,
        examples=[
            OpenApiExample(
                name="创建普通任务",
                value={
                    "title": "完成项目报告",
                    "description": "编写第一季度项目总结报告",
                    "category": 1,
                    "priority": 3,
                    "start_time": "2024-01-15T09:00:00Z",
                    "due_date": "2024-01-15T17:00:00Z",
                    "is_important": True
                }
            ),
            OpenApiExample(
                name="创建每周重复任务",
                value={
                    "title": "每周例会",
                    "description": "团队周会",
                    "repeat_type": "weekly",
                    "repeat_config": {
                        "start_date": "2024-01-01",
                        "end_date": "2024-12-31",
                        "start_time": "09:00",
                        "end_time": "10:00",
                        "custom_days": [0],
                        "interval": 1
                    },
                    "category": 1,
                    "priority": 2,
                    "is_important": True,
                    "start_time": "2024-01-01T09:00:00Z",
                    "due_date": "2024-12-31T10:00:00Z"
                }
            ),
            OpenApiExample(
                name="创建每月重复任务",
                value={
                    "title": "月度总结会议",
                    "description": "回顾本月工作，规划下月任务",
                    "repeat_type": "monthly",
                    "repeat_config": {
                        "start_date": "2024-01-25",
                        "end_date": "2024-12-31",
                        "start_time": "14:00",
                        "end_time": "16:00",
                        "interval": 1
                    },
                    "category": 1,
                    "priority": 2,
                    "is_important": True,
                    "start_time": "2024-01-25T14:00:00Z",
                    "due_date": "2024-12-31T16:00:00Z"
                }
            ),
            OpenApiExample(
                name="创建工作日重复任务",
                value={
                    "title": "每日晨会",
                    "description": "团队日常工作同步",
                    "repeat_type": "workdays",
                    "repeat_config": {
                        "start_date": "2024-01-01",
                        "end_date": "2024-12-31",
                        "start_time": "09:30",
                        "end_time": "10:00"
                    },
                    "category": 1,
                    "priority": 2,
                    "is_important": True,
                    "start_time": "2024-01-01T09:30:00Z",
                    "due_date": "2024-12-31T10:00:00Z"
                }
            ),
            OpenApiExample(
                name="创建自定义重复任务",
                value={
                    "title": "健身计划",
                    "description": "每周三次健身",
                    "repeat_type": "custom",
                    "repeat_config": {
                        "start_date": "2024-01-01",
                        "end_date": "2024-12-31",
                        "start_time": "18:00",
                        "end_time": "19:30",
                        "custom_days": [1, 3, 5],  # 每周二、四、六
                        "interval": 1
                    },
                    "category": 1,
                    "priority": 2,
                    "is_important": True,
                    "start_time": "2024-01-01T18:00:00Z",
                    "due_date": "2024-12-31T19:30:00Z"
                }
            ),
            OpenApiExample(
                name="创建隔周重复任务",
                value={
                    "title": "项目进度会议",
                    "description": "隔周项目进度同步",
                    "repeat_type": "custom",
                    "repeat_config": {
                        "start_date": "2024-01-01",
                        "end_date": "2024-12-31",
                        "start_time": "14:00",
                        "end_time": "15:30",
                        "custom_days": [2],  # 每周三
                        "interval": 2  # 每两周重复一次
                    },
                    "category": 1,
                    "priority": 2,
                    "is_important": True,
                    "start_time": "2024-01-01T14:00:00Z",
                    "due_date": "2024-12-31T15:30:00Z"
                }
            )
        ]
    ),
    retrieve=extend_schema(
        summary="获取任务详情",
        tags=['任务管理'],
        description="获取单个任务的详细信息，包括重复任务的配置信息"
    ),
    update=extend_schema(
        summary="更新任务",
        tags=['任务管理'],
        description="""
        更新任务信息。
        
        注意：
        1. 不能通过此接口修改重复任务的配置
        2. 如果需要修改重复任务配置，请使用专门的重复任务接口
        """
    ),
    destroy=extend_schema(
        summary="删除任务",
        tags=['任务管理'],
        description="删除任务。如果是重复任务的实例，只删除该实例；如果是重复任务本身，会删除所有相关的任务实例"
    )
)
class TaskViewSet(viewsets.ModelViewSet):
    permission_classes = [IsAuthenticated]
    filter_backends = [DjangoFilterBackend, SearchFilter, OrderingFilter]
    filterset_fields = ['status', 'priority', 'category', 'repeat_task', 'repeat_task__is_active']
    search_fields = ['title', 'description']
    ordering_fields = ['created_at', 'updated_at', 'due_date', 'priority']
    ordering = ['-created_at']
    pagination_class = TaskPagination

    def get_serializer_class(self):
        """根据请求类型返回对应的序列化器"""
        if self.request.method == 'POST' and self.request.data.get('repeat_type'):
            return RepeatTaskSerializer
        return TaskSerializer

    def get_queryset(self):
        """获取任务列表"""
        user = self.request.user
        queryset = Task.objects.filter(user=user)

        # 获取日期范围
        start_date = self.request.query_params.get('start_date')
        end_date = self.request.query_params.get('end_date')
        
        # 如果没有指定日期范围，使用默认范围（当前日期开始的一个月）
        if not start_date:
            start_date = timezone.now().date().isoformat()
        if not end_date:
            end_date = (timezone.now().date() + timedelta(days=30)).isoformat()
            
        try:
            start_date = datetime.strptime(start_date, '%Y-%m-%d').date()
            end_date = datetime.strptime(end_date, '%Y-%m-%d').date()
        except ValueError:
            # 如果日期格式错误，使用默认范围
            start_date = timezone.now().date()
            end_date = start_date + timedelta(days=30)

        # 处理重复任务的未来实例创建
        repeat_tasks = RepeatTask.objects.filter(
            user=user,
            is_active=True,
            repeat_config__start_date__lte=end_date.isoformat()  # 重复任务的开始日期在查询范围内
        ).exclude(
            # 排除已经在查询范围内有任务实例的重复任务
            tasks__scheduled_date__range=[start_date, end_date]
        ).distinct()

        for repeat_task in repeat_tasks:
            # 检查重复任务的结束日期（如果有）
            end_date_str = repeat_task.repeat_config.get('end_date')
            if end_date_str:
                repeat_end_date = datetime.strptime(end_date_str, '%Y-%m-%d').date()
                if repeat_end_date < start_date:
                    continue  # 跳过已经结束的重复任务
            
            # 获取重复任务的时间设置
            start_time = repeat_task.repeat_config.get('start_time', '09:00')
            end_time = repeat_task.repeat_config.get('end_time', '17:00')
            
            # 创建任务实例
            from .tasks import create_task_instances
            create_task_instances(
                repeat_task.id,
                start_date=start_date,
                end_date=end_date,
                default_start_time=start_time,
                default_end_time=end_time
            )

        # 过滤日期范围内的任务
        queryset = queryset.filter(
            Q(
                # 普通任务：任务时间与查询范围有重叠
                Q(repeat_task__isnull=True) &
                Q(
                    Q(start_time__date__lte=end_date) &
                    Q(due_date__date__gte=start_date)
                )
            ) |
            Q(
                # 重复任务实例：计划日期在查询范围内
                Q(repeat_task__isnull=False) &
                Q(scheduled_date__range=[start_date, end_date])
            )
        )

        # 处理状态筛选
        status = self.request.query_params.get('status')
        if status:
            queryset = queryset.filter(status=status)

        # 处理优先级筛选
        priority = self.request.query_params.get('priority')
        if priority:
            queryset = queryset.filter(priority=priority)

        # 处理分类筛选
        category = self.request.query_params.get('category')
        if category:
            queryset = queryset.filter(category=category)

        # 处理重要性筛选
        is_important = self.request.query_params.get('is_important')
        if is_important is not None:
            is_important = is_important.lower() == 'true'
            queryset = queryset.filter(is_important=is_important)

        # 处理搜索
        search = self.request.query_params.get('search')
        if search:
            queryset = queryset.filter(
                Q(title__icontains=search) |
                Q(description__icontains=search)
            )

        # 处理排序
        ordering = self.request.query_params.get('ordering', '-created_at')
        if ordering:
            # 添加自定义排序逻辑
            if ordering == 'due_date':
                # 将没有截止日期的任务排在最后
                queryset = queryset.annotate(
                    due_date_null=Case(
                        When(due_date__isnull=True, then=1),
                        default=0,
                        output_field=BooleanField(),
                    )
                ).order_by('due_date_null', 'due_date')
            elif ordering == '-due_date':
                queryset = queryset.annotate(
                    due_date_null=Case(
                        When(due_date__isnull=True, then=1),
                        default=0,
                        output_field=BooleanField(),
                    )
                ).order_by('due_date_null', '-due_date')
            else:
                queryset = queryset.order_by(ordering)

        return queryset

    def perform_create(self, serializer):
        """创建任务时的额外处理"""
        serializer.save(user=self.request.user)

    @action(detail=True, methods=['post'])
    @extend_schema(
        summary="激活/停用重复任务",
        tags=['任务管理'],
        request=None,
        responses={
            200: OpenApiResponse(description="成功更新任务状态")
        }
    )
    def toggle_repeat_active(self, request, pk=None):
        """激活/停用重复任务"""
        task = self.get_object()
        if not task.repeat_task:
            return Response(
                {'error': 'This is not a repeat task.'}, 
                status=status.HTTP_400_BAD_REQUEST
            )
            
        repeat_task = task.repeat_task
        repeat_task.is_active = not repeat_task.is_active
        repeat_task.save()
        
        if repeat_task.is_active:
            # 如果激活，重新生成未来任务
            repeat_task.refresh_dates()
        else:
            # 如果停用，删除未来未完成的任务
            Task.objects.filter(
                repeat_task=repeat_task,
                status='pending',
                start_time__gt=timezone.now()
            ).delete()
            
        return Response({
            'status': 'success',
            'is_active': repeat_task.is_active
        })

    @action(detail=True, methods=['get'])
    @extend_schema(
        summary="获取重复任务的所有实例",
        tags=['任务管理'],
        parameters=[
            OpenApiParameter(
                name='status',
                type=str,
                description='任务状态过滤 (pending/completed/archived)',
                required=False
            ),
            OpenApiParameter(
                name='start_date',
                type=str,
                description='开始日期 (YYYY-MM-DD)',
                required=False
            ),
            OpenApiParameter(
                name='end_date',
                type=str,
                description='结束日期 (YYYY-MM-DD)',
                required=False
            )
        ],
        responses={
            200: OpenApiResponse(
                description="成功获取任务实例列表",
                response=TaskSerializer(many=True)
            )
        }
    )
    def repeat_instances(self, request, pk=None):
        """获取重复任务的所有实例"""
        task = self.get_object()
        if not task.repeat_task:
            return Response(
                {'error': 'This is not a repeat task.'}, 
                status=status.HTTP_400_BAD_REQUEST
            )
            
        queryset = Task.objects.filter(repeat_task=task.repeat_task)
        
        # 状态过滤
        status_param = request.query_params.get('status')
        if status_param:
            queryset = queryset.filter(status=status_param)
            
        # 日期范围过滤
        start_date = request.query_params.get('start_date')
        end_date = request.query_params.get('end_date')
        
        if start_date:
            try:
                start_date = datetime.strptime(start_date, '%Y-%m-%d').date()
                queryset = queryset.filter(start_time__date__gte=start_date)
            except ValueError:
                pass
                
        if end_date:
            try:
                end_date = datetime.strptime(end_date, '%Y-%m-%d').date()
                queryset = queryset.filter(due_date__date__lte=end_date)
            except ValueError:
                pass
                
        serializer = self.get_serializer(queryset, many=True)
        return Response(serializer.data)

    @extend_schema(
        description='获取今天的任务列表',
        responses={200: TaskSerializer(many=True)}
    )
    @action(detail=False, methods=['get'])
    def today(self, request):
        """获取今天的任务列表"""
        today = timezone.now().date()
        tomorrow = today + timedelta(days=1)
        
        # 获取今天的普通任务
        tasks = Task.objects.filter(
            user=request.user,
            scheduled_date=today,
            status__in=['pending', 'in_progress']
        )

        # 获取今天的重复任务
        repeat_tasks = RepeatTask.objects.filter(
            user=request.user,
            is_active=True
        )

        # 创建结果列表
        result_tasks = list(tasks)

        # 检查每个重复任务是否应该在今天执行
        for repeat_task in repeat_tasks:
            config = repeat_task.repeat_config
            start_date = datetime.strptime(config['start_date'], '%Y-%m-%d').date()
            end_date = datetime.strptime(config['end_date'], '%Y-%m-%d').date()
            
            # 如果今天在有效期内
            if start_date <= today <= end_date:
                should_create = False
                
                if repeat_task.repeat_type == 'daily':
                    should_create = True
                    
                elif repeat_task.repeat_type == 'weekly':
                    # 检查今天是否是指定的星期几之一
                    weekday = today.weekday()
                    custom_days = config.get('custom_days', [0])  # 默认周一
                    if weekday in custom_days:
                        should_create = True
                        
                elif repeat_task.repeat_type == 'monthly':
                    # 检查今天是否是指定的日期
                    target_day = config.get('day', 1)  # 默认每月1号
                    if today.day == target_day:
                        should_create = True
                        
                elif repeat_task.repeat_type == 'yearly':
                    # 检查今天是否是指定的月份和日期
                    target_month = config.get('month', 1)  # 默认1月
                    target_day = config.get('day', 1)      # 默认1号
                    if today.month == target_month and today.day == target_day:
                        should_create = True
                
                if should_create:
                    # 创建今天的任务实例
                    start_time = datetime.strptime(config['start_time'], '%H:%M').time()
                    end_time = datetime.strptime(config['end_time'], '%H:%M').time()
                    
                    # 组合日期和时间
                    task_start = timezone.make_aware(datetime.combine(today, start_time))
                    task_end = timezone.make_aware(datetime.combine(today, end_time))
                    
                    # 检查是否已经存在今天的任务实例
                    existing_task = Task.objects.filter(
                        repeat_task=repeat_task,
                        scheduled_date=today
                    ).first()
                    
                    if not existing_task:
                        task = Task.objects.create(
                            user=request.user,
                            title=repeat_task.title,
                            description=repeat_task.description,
                            category=repeat_task.category,
                            priority=2,  # 默认优先级
                            start_time=task_start,
                            due_date=task_end,
                            scheduled_date=today,
                            repeat_task=repeat_task,
                            instance_number=1  # 第一个实例
                        )
                        result_tasks.append(task)

        serializer = self.get_serializer(result_tasks, many=True)
        return Response(serializer.data)

    @extend_schema(
        description='获取明天的任务列表',
        responses={200: TaskSerializer(many=True)}
    )
    @action(detail=False, methods=['get'])
    def tomorrow(self, request):
        """获取明天的任务列表"""
        today = timezone.now().date()
        tomorrow = today + timedelta(days=1)
        
        # 获取明天的普通任务
        tasks = Task.objects.filter(
            user=request.user,
            scheduled_date=tomorrow,
            status__in=['pending', 'in_progress']
        )

        # 获取明天的重复任务
        repeat_tasks = RepeatTask.objects.filter(
            user=request.user,
            is_active=True
        )

        # 创建结果列表
        result_tasks = list(tasks)

        # 检查每个重复任务是否应该在明天执行
        for repeat_task in repeat_tasks:
            config = repeat_task.repeat_config
            start_date = datetime.strptime(config['start_date'], '%Y-%m-%d').date()
            end_date = datetime.strptime(config['end_date'], '%Y-%m-%d').date()
            
            # 如果明天在有效期内
            if start_date <= tomorrow <= end_date:
                should_create = False
                
                if repeat_task.repeat_type == 'daily':
                    should_create = True
                    
                elif repeat_task.repeat_type == 'weekly':
                    # 检查明天是否是指定的星期几之一
                    weekday = tomorrow.weekday()
                    custom_days = config.get('custom_days', [0])  # 默认周一
                    if weekday in custom_days:
                        should_create = True
                        
                elif repeat_task.repeat_type == 'monthly':
                    # 检查明天是否是指定的日期
                    target_day = config.get('day', 1)  # 默认每月1号
                    if tomorrow.day == target_day:
                        should_create = True
                        
                elif repeat_task.repeat_type == 'yearly':
                    # 检查明天是否是指定的月份和日期
                    target_month = config.get('month', 1)  # 默认1月
                    target_day = config.get('day', 1)      # 默认1号
                    if tomorrow.month == target_month and tomorrow.day == target_day:
                        should_create = True
                
                if should_create:
                    # 创建明天的任务实例
                    start_time = datetime.strptime(config['start_time'], '%H:%M').time()
                    end_time = datetime.strptime(config['end_time'], '%H:%M').time()
                    
                    # 组合日期和时间
                    task_start = timezone.make_aware(datetime.combine(tomorrow, start_time))
                    task_end = timezone.make_aware(datetime.combine(tomorrow, end_time))
                    
                    # 检查是否已经存在明天的任务实例
                    existing_task = Task.objects.filter(
                        repeat_task=repeat_task,
                        scheduled_date=tomorrow
                    ).first()
                    
                    if not existing_task:
                        task = Task.objects.create(
                            user=request.user,
                            title=repeat_task.title,
                            description=repeat_task.description,
                            category=repeat_task.category,
                            priority=2,  # 默认优先级
                            start_time=task_start,
                            due_date=task_end,
                            scheduled_date=tomorrow,
                            repeat_task=repeat_task,
                            instance_number=1  # 第一个实例
                        )
                        result_tasks.append(task)

        serializer = self.get_serializer(result_tasks, many=True)
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


@extend_schema_view(
    list=extend_schema(
        summary="获取重复任务列表",
        tags=['重复任务管理'],
        responses={
            200: OpenApiResponse(
                description="成功获取重复任务列表",
                response=RepeatTaskSerializer
            )
        }
    ),
    create=extend_schema(
        summary="创建重复任务",
        tags=['重复任务管理'],
        request=RepeatTaskSerializer,
        responses={
            201: OpenApiResponse(
                description="成功创建重复任务",
                response=RepeatTaskSerializer
            )
        }
    ),
    retrieve=extend_schema(
        summary="获取重复任务详情",
        tags=['重复任务管理'],
        responses={
            200: OpenApiResponse(
                description="成功获取重复任务详情",
                response=RepeatTaskSerializer
            )
        }
    ),
    update=extend_schema(
        summary="更新重复任务",
        tags=['重复任务管理'],
        request=RepeatTaskSerializer,
        responses={
            200: OpenApiResponse(
                description="成功更新重复任务",
                response=RepeatTaskSerializer
            )
        }
    ),
    destroy=extend_schema(
        summary="删除重复任务",
        tags=['重复任务管理'],
        responses={
            204: OpenApiResponse(description="成功删除重复任务")
        }
    )
)
class RepeatTaskViewSet(viewsets.ModelViewSet):
    serializer_class = RepeatTaskSerializer
    permission_classes = [IsAuthenticated]
    filter_backends = [DjangoFilterBackend, SearchFilter]
    filterset_fields = ['is_active']
    search_fields = ['title', 'description']
    
    def get_queryset(self):
        """获取重复任务列表"""
        return RepeatTask.objects.filter(user=self.request.user)
    
    def perform_create(self, serializer):
        """创建重复任务"""
        serializer.save(user=self.request.user)
        
    def perform_update(self, serializer):
        """更新重复任务"""
        instance = serializer.save()
        # 重新生成未来的任务实例
        instance.refresh_dates()
        
    def perform_destroy(self, instance):
        """删除重复任务"""
        # 删除所有相关的任务实例
        Task.objects.filter(repeat_task=instance).delete()
        instance.delete()
        
    @action(detail=True, methods=['post'])
    @extend_schema(
        summary="激活/停用重复任务",
        tags=['重复任务管理'],
        request=None,
        responses={
            200: OpenApiResponse(description="成功更新任务状态")
        }
    )
    def toggle_active(self, request, pk=None):
        """激活/停用重复任务"""
        repeat_task = self.get_object()
        repeat_task.is_active = not repeat_task.is_active
        repeat_task.save()
        
        if repeat_task.is_active:
            # 如果激活，重新生成未来任务
            repeat_task.refresh_dates()
        else:
            # 如果停用，删除未来未完成的任务
            Task.objects.filter(
                repeat_task=repeat_task,
                status='pending',
                start_time__gt=timezone.now()
            ).delete()
            
        return Response({'status': 'success', 'is_active': repeat_task.is_active})
        
    @action(detail=True, methods=['get'])
    @extend_schema(
        summary="获取重复任务的所有实例",
        tags=['重复任务管理'],
        parameters=[
            OpenApiParameter(
                name='status',
                type=str,
                description='任务状态过滤 (pending/completed/archived)',
                required=False
            ),
            OpenApiParameter(
                name='start_date',
                type=str,
                description='开始日期 (YYYY-MM-DD)',
                required=False
            ),
            OpenApiParameter(
                name='end_date',
                type=str,
                description='结束日期 (YYYY-MM-DD)',
                required=False
            )
        ],
        responses={
            200: OpenApiResponse(
                description="成功获取任务实例列表",
                response=TaskSerializer(many=True)
            )
        }
    )
    def instances(self, request, pk=None):
        """获取重复任务的所有实例"""
        repeat_task = self.get_object()
        queryset = Task.objects.filter(repeat_task=repeat_task)
        
        # 状态过滤
        status = request.query_params.get('status')
        if status:
            queryset = queryset.filter(status=status)
            
        # 日期范围过滤
        start_date = request.query_params.get('start_date')
        end_date = request.query_params.get('end_date')
        
        if start_date:
            try:
                start_date = datetime.strptime(start_date, '%Y-%m-%d').date()
                queryset = queryset.filter(start_time__date__gte=start_date)
            except ValueError:
                pass
                
        if end_date:
            try:
                end_date = datetime.strptime(end_date, '%Y-%m-%d').date()
                queryset = queryset.filter(due_date__date__lte=end_date)
            except ValueError:
                pass
                
        serializer = TaskSerializer(queryset, many=True)
        return Response(serializer.data)
