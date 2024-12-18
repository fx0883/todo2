from rest_framework import viewsets, status
from rest_framework.permissions import IsAuthenticated
from rest_framework.decorators import action
from rest_framework.response import Response
from drf_spectacular.utils import extend_schema_view, extend_schema, OpenApiExample, OpenApiResponse
from .models import NotificationTemplate, Notification, NotificationDevice
from .serializers import NotificationTemplateSerializer, NotificationSerializer, NotificationDeviceSerializer

# Create your views here.

@extend_schema_view(
    list=extend_schema(
        summary="获取通知模板列表",
        tags=['通知模板'],
        responses={
            200: OpenApiResponse(
                description="成功获取通知模板列表",
                examples=[
                    OpenApiExample(
                        'Notification Template List Example',
                        value=[{
                            'id': 1,
                            'name': '任务到期提醒',
                            'type': 'email',
                            'title_template': '任务 {{ task.title }} 即将到期',
                            'content_template': '您的任务 {{ task.title }} 将在 {{ task.due_date }} 到期，请及时处理。',
                            'created_at': '2024-12-09T12:00:00Z'
                        }]
                    )
                ]
            )
        }
    ),
    create=extend_schema(
        summary="创建通知模板",
        tags=['通知模板'],
        request=NotificationTemplateSerializer,
        examples=[
            OpenApiExample(
                'Create Template Example',
                value={
                    'name': '任务评论提醒',
                    'type': 'push',
                    'title_template': '{{ user.username }} 评论了您的任务',
                    'content_template': '{{ user.username }} 在任务 {{ task.title }} 中发表了评论: {{ comment.content }}'
                }
            )
        ]
    ),
    retrieve=extend_schema(
        summary="获取通知模板详情",
        tags=['通知模板']
    ),
    update=extend_schema(
        summary="更新通知模板",
        tags=['通知模板']
    ),
    partial_update=extend_schema(
        summary="部分更新通知模板",
        tags=['通知模板']
    ),
    destroy=extend_schema(
        summary="删除通知模板",
        tags=['通知模板']
    )
)
class NotificationTemplateViewSet(viewsets.ModelViewSet):
    serializer_class = NotificationTemplateSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        return NotificationTemplate.objects.all()

@extend_schema_view(
    list=extend_schema(
        summary="获取通知列表",
        tags=['通知管理'],
        responses={
            200: OpenApiResponse(
                description="成功获取通知列表",
                examples=[
                    OpenApiExample(
                        'Notification List Example',
                        value=[{
                            'id': 1,
                            'user': 1,
                            'template': 1,
                            'title': '任务 "完成项目报告" 即将到期',
                            'content': '您的任务 "完成项目报告" 将在 2024-12-31 23:59:59 到期，请及时处理。',
                            'status': 'pending',
                            'scheduled_time': '2024-12-31T10:00:00Z',
                            'created_at': '2024-12-09T12:00:00Z'
                        }]
                    )
                ]
            )
        }
    ),
    create=extend_schema(
        summary="创建通知",
        tags=['通知管理'],
        request=NotificationSerializer,
        examples=[
            OpenApiExample(
                'Create Notification Example',
                value={
                    'template': 1,
                    'title': '新任务提醒',
                    'content': '您有一个新的任务需要处理',
                    'scheduled_time': '2024-12-10T09:00:00Z'
                }
            )
        ]
    ),
    retrieve=extend_schema(
        summary="获取通知详情",
        tags=['通知管理']
    ),
    update=extend_schema(
        summary="更新通知",
        tags=['通知管理']
    ),
    partial_update=extend_schema(
        summary="部分更新通知",
        tags=['通知管理']
    ),
    destroy=extend_schema(
        summary="删除通知",
        tags=['通知管理']
    )
)
class NotificationViewSet(viewsets.ModelViewSet):
    serializer_class = NotificationSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        return Notification.objects.filter(user=self.request.user)

    def perform_create(self, serializer):
        serializer.save(user=self.request.user)

    @extend_schema(
        summary="标记所有通知为已读",
        tags=['通知管理']
    )
    @action(detail=False, methods=['post'])
    def mark_all_as_read(self, request):
        self.get_queryset().mark_all_as_read()
        return Response(status=status.HTTP_200_OK)

@extend_schema_view(
    list=extend_schema(
        summary="获取通知设备列表",
        tags=['通知设备'],
        responses={
            200: OpenApiResponse(
                description="成功获取通知设备列表",
                examples=[
                    OpenApiExample(
                        'Notification Device List Example',
                        value=[{
                            'id': 1,
                            'user': 1,
                            'device': 1,
                            'push_token': 'fcm-token-xxx',
                            'is_enabled': True,
                            'last_active': '2024-12-09T12:00:00Z'
                        }]
                    )
                ]
            )
        }
    ),
    create=extend_schema(
        summary="创建通知设备",
        tags=['通知设备'],
        request=NotificationDeviceSerializer,
        examples=[
            OpenApiExample(
                'Create Device Example',
                value={
                    'device': 1,
                    'push_token': 'new-fcm-token-xxx',
                    'is_enabled': True
                }
            )
        ]
    ),
    retrieve=extend_schema(
        summary="获取通知设备详情",
        tags=['通知设备']
    ),
    update=extend_schema(
        summary="更新通知设备",
        tags=['通知设备']
    ),
    partial_update=extend_schema(
        summary="部分更新通知设备",
        tags=['通知设备']
    ),
    destroy=extend_schema(
        summary="删除通知设备",
        tags=['通知设备']
    )
)
class NotificationDeviceViewSet(viewsets.ModelViewSet):
    serializer_class = NotificationDeviceSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        return NotificationDevice.objects.filter(user=self.request.user)

    def perform_create(self, serializer):
        serializer.save(user=self.request.user)
