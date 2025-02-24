from django.shortcuts import render
from rest_framework import viewsets, status, filters
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from django_filters.rest_framework import DjangoFilterBackend
from drf_spectacular.utils import extend_schema_view, extend_schema, OpenApiExample, OpenApiResponse, OpenApiParameter
from .models import Category, Tag, Task, TaskComment
from .serializers import CategorySerializer, TagSerializer, TaskSerializer, TaskCommentSerializer
from rest_framework.pagination import PageNumberPagination
from rest_framework.decorators import action
from django.utils import timezone
from datetime import datetime, timedelta
from django.db.models import Q
from rest_framework.views import APIView

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
        tags=['任务分类'],
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
        tags=['任务分类'],
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
        tags=['任务分类']
    ),
    update=extend_schema(
        summary="更新分类",
        tags=['任务分类']
    ),
    partial_update=extend_schema(
        summary="部分更新分类",
        tags=['任务分类']
    ),
    destroy=extend_schema(
        summary="删除分类",
        tags=['任务分类']
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
        return Response(
            serializer.data, 
            status=status.HTTP_201_CREATED, 
            headers=headers
        )

    def destroy(self, request, *args, **kwargs):
        category = self.get_object()
        
        # 将该分类下的所有任务的分类字段设置为空
        Task.objects.filter(category=category).update(category=None)
        
        # 删除分类
        category.delete()
        
        return Response(status=status.HTTP_204_NO_CONTENT)

@extend_schema_view(
    list=extend_schema(
        summary="获取标签列表",
        tags=['任务标签']
    ),
    create=extend_schema(
        summary="创建标签",
        tags=['任务标签']
    ),
    retrieve=extend_schema(
        summary="获取标签详情",
        tags=['任务标签']
    ),
    update=extend_schema(
        summary="更新标签",
        tags=['任务标签']
    ),
    partial_update=extend_schema(
        summary="部分更新标签",
        tags=['任务标签']
    ),
    destroy=extend_schema(
        summary="删除标签",
        tags=['任务标签']
    )
)
class TagViewSet(viewsets.ModelViewSet):
    serializer_class = TagSerializer
    permission_classes = [IsAuthenticated]
    filter_backends = [filters.SearchFilter]
    search_fields = ['name']

    def get_queryset(self):
        return Tag.objects.filter(user=self.request.user)

    def create(self, request, *args, **kwargs):
        # 检查当前用户是否已有同名标签
        name = request.data.get('name')
        if Tag.objects.filter(user=request.user, name=name).exists():
            return Response(
                {"error": "标签名称已存在"},
                status=status.HTTP_400_BAD_REQUEST
            )
            
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        serializer.save(user=self.request.user)
        
        headers = self.get_success_headers(serializer.data)
        return Response(
            serializer.data, 
            status=status.HTTP_201_CREATED, 
            headers=headers
        )

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
                                'due_date': '2024-12-31T23:59:59Z',
                                'priority': 2,
                                'status': 'pending',
                                'category': 1,
                                'tags': [1, 2],
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
        request=TaskSerializer,
        examples=[
            OpenApiExample(
                'Create Task Example',
                value={
                    'title': '准备会议材料',
                    'description': '准备下周一的项目进度会议材料',
                    'due_date': '2024-12-15T14:00:00Z',
                    'priority': 1,
                    'category': 1,
                    'tag_ids': [1],
                    'is_important': True
                }
            )
        ]
    ),
    retrieve=extend_schema(
        summary="获取任务详情",
        tags=['任务管理']
    ),
    update=extend_schema(
        summary="更新任务",
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
    pagination_class = TaskPagination  # 添加分页器

    def get_queryset(self):
        return Task.objects.filter(user=self.request.user)
    
    @extend_schema(
        summary="获取日历视图任务",
        parameters=[
            OpenApiParameter(name='start_date', type=str, description='开始日期 (YYYY-MM-DD)'),
            OpenApiParameter(name='end_date', type=str, description='结束日期 (YYYY-MM-DD)')
        ],
        tags=['任务管理']
    )
    @action(detail=False, methods=['get'])
    def calendar(self, request):
        """获取指定时间范围内的任务，包括没有截止日期的任务"""
        start_date = request.query_params.get('start_date')
        end_date = request.query_params.get('end_date')
        
        try:
            if not start_date or not end_date:
                # 如果没有提供日期，默认使用今天的日期
                today = datetime.now().date()
                start_date = end_date = today.strftime('%Y-%m-%d')

            # 转换日期字符串为datetime对象，设置时间为当天开始和结束
            start_datetime = datetime.strptime(f"{start_date} 00:00:00", '%Y-%m-%d %H:%M:%S')
            end_datetime = datetime.strptime(f"{end_date} 23:59:59", '%Y-%m-%d %H:%M:%S')

        except (ValueError, TypeError):
            return Response(
                {'error': '无效的日期格式，请使用 YYYY-MM-DD'},
                status=status.HTTP_400_BAD_REQUEST
            )

        # 构建查询条件
        # 1. 有截止日期的任务：两条线段相交
        date_query = Q(
            created_at__lte=end_datetime,    # created_at <= end_date 23:59:59
            due_date__gte=start_datetime     # due_date >= start_date 00:00:00
        )

        # 2. 没有截止日期的任务：created_at开始的射线与查询线段相交
        no_date_query = Q(
            due_date__isnull=True,
            created_at__lte=end_datetime
        )
        
        # 获取任务并排序
        tasks = self.get_queryset().filter(
            date_query | no_date_query
        ).order_by(
            '-is_important',
            '-priority',
            'due_date',
            '-created_at'
        )
        
        serializer = self.get_serializer(tasks, many=True)
        return Response(serializer.data)

    @extend_schema(
        summary="更新任务日期",
        tags=['任务管理'],
        request={
            'application/json': {
                'type': 'object',
                'properties': {
                    'due_date': {'type': 'string', 'format': 'date'},
                    'keep_time': {'type': 'boolean', 'default': True}
                }
            }
        }
    )
    @action(detail=True, methods=['patch'])
    def update_date(self, request, pk=None):
        """更新任务的日期（用于拖拽调整）"""
        task = self.get_object()
        new_date = request.data.get('due_date')
        keep_time = request.data.get('keep_time', True)
        
        try:
            # 解析新日期
            new_date = datetime.strptime(new_date, '%Y-%m-%d')
            
            # 如果需要保留原有时间
            if keep_time and task.due_date:
                new_date = new_date.replace(
                    hour=task.due_date.hour,
                    minute=task.due_date.minute,
                    second=task.due_date.second
                )
            
            # 确保日期是时区感知的
            new_date = timezone.make_aware(new_date)
            
            # 更新任务
            task.due_date = new_date
            task.updated_at = timezone.now()
            task.save()
            
            serializer = self.get_serializer(task)
            return Response(serializer.data)
        except (ValueError, TypeError):
            return Response(
                {'error': '无效的日期格式，请使用 YYYY-MM-DD'},
                status=status.HTTP_400_BAD_REQUEST
            )

    @extend_schema(
        summary="快速创建任务",
        tags=['任务管理'],
        request=TaskSerializer
    )
    @action(detail=False, methods=['post'])
    def quick_create(self, request):
        """快速创建任务（带有预设日期）"""
        # 确保日期是时区感知的
        due_date = request.data.get('due_date')
        if due_date:
            try:
                date = datetime.strptime(due_date, '%Y-%m-%d')
                request.data['due_date'] = timezone.make_aware(date).isoformat()
            except (ValueError, TypeError):
                return Response(
                    {'error': '无效的日期格式，请使用 YYYY-MM-DD'},
                    status=status.HTTP_400_BAD_REQUEST
                )
        
        serializer = self.get_serializer(data=request.data)
        if serializer.is_valid():
            serializer.save(
                user=request.user,
                created_at=timezone.now(),
                updated_at=timezone.now()
            )
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def perform_create(self, serializer):
        serializer.save(user=self.request.user)

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
        parameters=[
            OpenApiParameter(name='month', type=str, description='月份，格式：YYYY-MM，例如：2023-12')
        ],
        tags=['任务管理']
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
        parameters=[
            OpenApiParameter(name='month', type=str, description='月份，格式：YYYY-MM，例如：2023-12')
        ],
        tags=['任务管理']
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
        parameters=[
            OpenApiParameter(name='month', type=str, description='月份，格式：YYYY-MM，例如：2023-12')
        ],
        tags=['任务管理']
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
        parameters=[
            OpenApiParameter(name='month', type=str, description='月份，格式：YYYY-MM，例如：2023-12')
        ],
        tags=['任务管理']
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
