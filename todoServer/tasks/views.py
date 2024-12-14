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

@extend_schema_view(
    list=extend_schema(
        summary="获取标签列表",
        tags=['任务标签'],
        responses={
            200: OpenApiResponse(
                description="成功获取标签列表",
                examples=[
                    OpenApiExample(
                        'Tag List Example',
                        value=[{
                            'id': 1,
                            'name': '重要',
                            'color': '#FF0000'
                        }, {
                            'id': 2,
                            'name': '紧急',
                            'color': '#FF3300'
                        }]
                    )
                ]
            )
        }
    ),
    create=extend_schema(
        summary="创建标签",
        tags=['任务标签'],
        request=TagSerializer,
        examples=[
            OpenApiExample(
                'Create Tag Example',
                value={
                    'name': '个人',
                    'color': '#0033FF'
                }
            )
        ]
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
            OpenApiParameter(name='end_date', type=str, description='结束日期 (YYYY-MM-DD)'),
            OpenApiParameter(name='view_type', type=str, description='视图类型 (month/week/day)')
        ],
        tags=['任务管理']
    )
    @action(detail=False, methods=['get'])
    def calendar(self, request):
        """获取指定时间范围内的任务"""
        start_date = request.query_params.get('start_date')
        end_date = request.query_params.get('end_date')
        view_type = request.query_params.get('view_type', 'month')
        
        try:
            start_date = datetime.strptime(start_date, '%Y-%m-%d')
            end_date = datetime.strptime(end_date, '%Y-%m-%d')
        except (ValueError, TypeError):
            if view_type == 'day':
                start_date = timezone.now().replace(hour=0, minute=0, second=0)
                end_date = start_date + timedelta(days=1)
            elif view_type == 'week':
                start_date = timezone.now().replace(hour=0, minute=0, second=0) - timedelta(days=timezone.now().weekday())
                end_date = start_date + timedelta(days=7)
            else:  # month
                today = timezone.now()
                start_date = today.replace(day=1, hour=0, minute=0, second=0)
                if today.month == 12:
                    end_date = today.replace(year=today.year + 1, month=1, day=1)
                else:
                    end_date = today.replace(month=today.month + 1, day=1)

        tasks = self.get_queryset().filter(
            due_date__gte=start_date,
            due_date__lt=end_date
        ).order_by('due_date')
        
        serializer = self.get_serializer(tasks, many=True)
        return Response(serializer.data)

    @extend_schema(
        summary="更新任务日期",
        tags=['任务管理']
    )
    @action(detail=True, methods=['patch'])
    def update_date(self, request, pk=None):
        """更新任务的日期（用于拖拽调整）"""
        task = self.get_object()
        new_date = request.data.get('due_date')
        
        try:
            new_date = datetime.strptime(new_date, '%Y-%m-%d')
            task.due_date = new_date
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
        tags=['任务管理']
    )
    @action(detail=False, methods=['post'])
    def quick_create(self, request):
        """快速创建任务（带有预设日期）"""
        serializer = self.get_serializer(data=request.data)
        if serializer.is_valid():
            serializer.save(user=request.user)
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def perform_create(self, serializer):
        serializer.save(user=self.request.user)

@extend_schema_view(
    list=extend_schema(
        summary="获取任务评论列表",
        tags=['任务评论'],
        responses={
            200: OpenApiResponse(
                description="成功获取任务评论列表",
                examples=[
                    OpenApiExample(
                        'Task Comment List Example',
                        value=[{
                            'id': 1,
                            'task': 1,
                            'content': '已经完成初稿，请查看',
                            'created_at': '2024-12-09T12:00:00Z'
                        }]
                    )
                ]
            )
        }
    ),
    create=extend_schema(
        summary="创建任务评论",
        tags=['任务评论'],
        request=TaskCommentSerializer,
        examples=[
            OpenApiExample(
                'Create Task Comment Example',
                value={
                    'task': 1,
                    'content': '这部分需要修改一下格式'
                }
            )
        ]
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
