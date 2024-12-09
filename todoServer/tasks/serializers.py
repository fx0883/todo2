from rest_framework import serializers
from drf_spectacular.utils import extend_schema_serializer, OpenApiExample
from .models import Category, Tag, Task, TaskComment, TaskSync

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

@extend_schema_serializer(
    examples=[
        OpenApiExample(
            'Task Example',
            value={
                'id': 1,
                'user': 1,
                'title': '完成项目报告',
                'description': '准备第四季度项目总结报告',
                'due_date': '2024-12-31T23:59:59Z',
                'priority': 2,
                'status': 'pending',
                'category': 1,
                'tags': [1, 2],
                'tag_ids': [1, 2],
                'repeat_type': 'none',
                'repeat_config': None,
                'reminder_time': '2024-12-31T10:00:00Z',
                'completed_at': None,
                'is_important': True,
                'order': 1,
                'created_at': '2024-12-09T12:00:00Z',
                'updated_at': '2024-12-09T12:00:00Z',
                'comments': []
            }
        )
    ]
)
class TaskSerializer(serializers.ModelSerializer):
    comments = TaskCommentSerializer(many=True, read_only=True)
    tags = TagSerializer(many=True, read_only=True)
    tag_ids = serializers.PrimaryKeyRelatedField(
        many=True, write_only=True, queryset=Tag.objects.all(), required=False
    )

    class Meta:
        model = Task
        fields = (
            'id', 'user', 'title', 'description', 'due_date', 'priority', 'status',
            'category', 'tags', 'tag_ids', 'repeat_type', 'repeat_config',
            'reminder_time', 'completed_at', 'is_important', 'order',
            'created_at', 'updated_at', 'comments'
        )
        read_only_fields = ('id', 'user', 'created_at', 'updated_at')

    def create(self, validated_data):
        validated_data['user'] = self.context['request'].user
        tag_ids = validated_data.pop('tag_ids', [])
        task = super().create(validated_data)
        task.tags.set(tag_ids)
        return task

    def update(self, instance, validated_data):
        tag_ids = validated_data.pop('tag_ids', None)
        task = super().update(instance, validated_data)
        if tag_ids is not None:
            task.tags.set(tag_ids)
        return task
