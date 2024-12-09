from django.shortcuts import render
from rest_framework import viewsets, status, filters
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from django_filters.rest_framework import DjangoFilterBackend
from drf_spectacular.utils import extend_schema_view, extend_schema, OpenApiExample, OpenApiResponse
from .models import Category, Tag, Task, TaskComment
from .serializers import CategorySerializer, TagSerializer, TaskSerializer, TaskCommentSerializer

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
        responses={
            200: OpenApiResponse(
                description="成功获取任务列表",
                examples=[
                    OpenApiExample(
                        'Task List Example',
                        value=[{
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

    def get_queryset(self):
        queryset = Task.objects.filter(user=self.request.user)
        
        # Filter by tag
        tag_id = self.request.query_params.get('tag', None)
        if tag_id:
            queryset = queryset.filter(tags__id=tag_id)
        
        # Filter by due date range
        start_date = self.request.query_params.get('start_date', None)
        end_date = self.request.query_params.get('end_date', None)
        if start_date and end_date:
            queryset = queryset.filter(due_date__range=[start_date, end_date])
        elif start_date:
            queryset = queryset.filter(due_date__gte=start_date)
        elif end_date:
            queryset = queryset.filter(due_date__lte=end_date)
        
        return queryset

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
