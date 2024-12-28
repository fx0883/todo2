from rest_framework import serializers
from drf_spectacular.utils import extend_schema_serializer, OpenApiExample
from .models import Category, Tag, Task, TaskComment, TaskSync, RepeatTask

@extend_schema_serializer(
    examples=[
        OpenApiExample(
            'Category Example',
            value={
                'id': 1,
                'user': 1,
                'name': '工作',
                'color': '#FF5733',
                'icon': 'work',
                'order': 1
            }
        )
    ]
)
class CategorySerializer(serializers.ModelSerializer):
    class Meta:
        model = Category
        fields = ('id', 'user', 'name', 'color', 'icon', 'order')
        read_only_fields = ('id', 'user')

    def validate_name(self, value):
        user = self.context['request'].user
        # 检查是否存在同名分类
        if Category.objects.filter(user=user, name=value).exists():
            raise serializers.ValidationError("分类名称已存在")
        return value

    def create(self, validated_data):
        validated_data['user'] = self.context['request'].user
        return super().create(validated_data)

@extend_schema_serializer(
    examples=[
        OpenApiExample(
            'Tag Example',
            value={
                'id': 1,
                'user': 1,
                'name': '重要',
                'color': '#FF0000'
            }
        )
    ]
)
class TagSerializer(serializers.ModelSerializer):
    class Meta:
        model = Tag
        fields = ('id', 'user', 'name', 'color')
        read_only_fields = ('id', 'user')

    def create(self, validated_data):
        validated_data['user'] = self.context['request'].user
        return super().create(validated_data)

@extend_schema_serializer(
    examples=[
        OpenApiExample(
            'TaskComment Example',
            value={
                'id': 1,
                'task': 1,
                'user': 1,
                'content': '已经完成初稿，请查看',
                'created_at': '2024-12-09T12:00:00Z',
                'updated_at': '2024-12-09T12:00:00Z'
            }
        )
    ]
)
class TaskCommentSerializer(serializers.ModelSerializer):
    class Meta:
        model = TaskComment
        fields = ('id', 'task', 'user', 'content', 'created_at', 'updated_at')
        read_only_fields = ('id', 'user', 'created_at', 'updated_at')

    def create(self, validated_data):
        validated_data['user'] = self.context['request'].user
        return super().create(validated_data)

class RepeatTaskSerializer(serializers.ModelSerializer):
    class Meta:
        model = RepeatTask
        fields = (
            'id', 'user', 'title', 'description', 'category',
            'repeat_type', 'repeat_config', 'is_active',
            'created_at', 'updated_at'
        )
        read_only_fields = ('id', 'user', 'created_at', 'updated_at')

    def validate_repeat_config(self, value):
        repeat_type = self.initial_data.get('repeat_type')
        if repeat_type == 'custom':
            if 'custom_days' not in value:
                raise serializers.ValidationError("自定义重复必须指定重复日期")
            if not isinstance(value['custom_days'], list):
                raise serializers.ValidationError("custom_days必须是列表")
            if not value.get('start_date'):
                raise serializers.ValidationError("必须指定开始日期")
        return value

    def create(self, validated_data):
        validated_data['user'] = self.context['request'].user
        return super().create(validated_data)

class TaskSerializer(serializers.ModelSerializer):
    comments = TaskCommentSerializer(many=True, read_only=True)
    repeat_task_detail = RepeatTaskSerializer(source='repeat_task', read_only=True)

    class Meta:
        model = Task
        fields = (
            'id', 'user', 'title', 'description', 'due_date', 'priority', 'status',
            'category', 'reminder_time', 'completed_at', 'is_important', 'order',
            'created_at', 'updated_at', 'comments', 'repeat_task',
            'repeat_task_detail', 'scheduled_date', 'instance_number'
        )
        read_only_fields = ('id', 'user', 'created_at', 'updated_at',
                         'repeat_task_detail', 'instance_number')

    def validate_category(self, value):
        user = self.context['request'].user
        if value and value.user != user:
            raise serializers.ValidationError("分类不存在或不属于当前用户")
        return value

    def create(self, validated_data):
        validated_data['user'] = self.context['request'].user
        return super().create(validated_data)

    def update(self, instance, validated_data):
        return super().update(instance, validated_data)
