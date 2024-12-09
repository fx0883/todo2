from rest_framework import serializers
from drf_spectacular.utils import extend_schema_serializer, OpenApiExample
from .models import NotificationTemplate, Notification, NotificationDevice

@extend_schema_serializer(
    examples=[
        OpenApiExample(
            'NotificationTemplate Example',
            value={
                'id': 1,
                'name': '任务到期提醒',
                'type': 'email',
                'title_template': '任务 {{ task.title }} 即将到期',
                'content_template': '您的任务 {{ task.title }} 将在 {{ task.due_date }} 到期，请及时处理。',
                'created_at': '2024-12-09T12:00:00Z',
                'updated_at': '2024-12-09T12:00:00Z'
            }
        )
    ]
)
class NotificationTemplateSerializer(serializers.ModelSerializer):
    class Meta:
        model = NotificationTemplate
        fields = ('id', 'name', 'type', 'title_template', 'content_template', 'created_at', 'updated_at')
        read_only_fields = ('id', 'created_at', 'updated_at')

    def create(self, validated_data):
        validated_data['created_by'] = self.context['request'].user
        return super().create(validated_data)

@extend_schema_serializer(
    examples=[
        OpenApiExample(
            'Notification Example',
            value={
                'id': 1,
                'user': 1,
                'template': 1,
                'title': '任务 "完成项目报告" 即将到期',
                'content': '您的任务 "完成项目报告" 将在 2024-12-31 23:59:59 到期，请及时处理。',
                'status': 'pending',
                'error_message': None,
                'scheduled_time': '2024-12-31T10:00:00Z',
                'sent_time': None,
                'read_time': None,
                'created_at': '2024-12-09T12:00:00Z'
            }
        )
    ]
)
class NotificationSerializer(serializers.ModelSerializer):
    class Meta:
        model = Notification
        fields = (
            'id', 'user', 'template', 'title', 'content', 'status',
            'error_message', 'scheduled_time', 'sent_time', 'read_time',
            'created_at'
        )
        read_only_fields = ('id', 'sent_time', 'read_time', 'created_at')

@extend_schema_serializer(
    examples=[
        OpenApiExample(
            'NotificationDevice Example',
            value={
                'id': 1,
                'user': 1,
                'device': 1,
                'push_token': 'fcm-token-xxx',
                'is_enabled': True,
                'last_active': '2024-12-09T12:00:00Z',
                'created_at': '2024-12-09T10:00:00Z',
                'updated_at': '2024-12-09T12:00:00Z'
            }
        )
    ]
)
class NotificationDeviceSerializer(serializers.ModelSerializer):
    class Meta:
        model = NotificationDevice
        fields = ('id', 'user', 'device', 'push_token', 'is_enabled', 'last_active', 'created_at', 'updated_at')
        read_only_fields = ('id', 'created_at', 'updated_at')
