from rest_framework import serializers
from drf_spectacular.utils import extend_schema_serializer, OpenApiExample
from .models import Category, Task, TaskComment, TaskSync, RepeatTask
from datetime import datetime
from django.utils import timezone

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
        """
        验证重复任务配置的完整性
        
        验证规则：
        1. 必须包含 start_date
        2. 如果有 end_date，必须大于 start_date
        3. interval 必须大于 0
        4. custom_days 必须在 0-6 范围内
        5. 不同重复类型的特殊验证
        """
        repeat_type = self.initial_data.get('repeat_type')
        
        # 如果不是重复任务，无需验证
        if not repeat_type or repeat_type == 'none':
            return value
            
        # 验证开始日期
        if 'start_date' not in value:
            raise serializers.ValidationError("必须指定开始日期")
        
        # 验证结束日期
        if 'end_date' in value:
            start_date = datetime.strptime(value['start_date'], '%Y-%m-%d').date()
            end_date = datetime.strptime(value['end_date'], '%Y-%m-%d').date()
            if end_date <= start_date:
                raise serializers.ValidationError("结束日期必须大于开始日期")
        
        # 验证重复间隔
        interval = value.get('interval', 1)
        if not isinstance(interval, int) or interval < 1:
            raise serializers.ValidationError("重复间隔必须是大于0的整数")
        
        # 验证自定义重复日期
        if repeat_type == 'custom':
            if 'custom_days' not in value:
                raise serializers.ValidationError("自定义重复必须指定重复日期")
                
            custom_days = value['custom_days']
            if not isinstance(custom_days, list):
                raise serializers.ValidationError("custom_days必须是列表")
                
            if not custom_days:
                raise serializers.ValidationError("自定义重复日期不能为空")
                
            if not all(isinstance(day, int) and 0 <= day <= 6 for day in custom_days):
                raise serializers.ValidationError("自定义重复日期必须是0-6的整数，0代表周一，6代表周日")
                
            if len(custom_days) != len(set(custom_days)):
                raise serializers.ValidationError("自定义重复日期不能重复")
        
        # 验证工作日重复
        elif repeat_type == 'workdays':
            if 'custom_days' in value:
                raise serializers.ValidationError("工作日重复不需要指定custom_days")
        
        # 验证周末重复
        elif repeat_type == 'weekends':
            if 'custom_days' in value:
                raise serializers.ValidationError("周末重复不需要指定custom_days")
        
        # 验证每月重复
        elif repeat_type == 'monthly':
            start_date = datetime.strptime(value['start_date'], '%Y-%m-%d').date()
            if start_date.day > 28:
                raise serializers.ValidationError("每月重复的日期不能大于28日，以避免在月末出现无效日期")
        
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
            'id', 'user', 'title', 'description', 'category', 'priority',
            'status', 'start_time', 'due_date', 'reminder_time', 'completed_at',
            'is_important', 'order', 'repeat_task', 'scheduled_date',
            'instance_number', 'created_at', 'updated_at', 'comments',
            'repeat_task_detail'
        )
        read_only_fields = ('id', 'user', 'created_at', 'updated_at', 'completed_at')

    def validate(self, data):
        """验证任务数据"""
        # 如果没有开始时间，使用当前时间
        if 'start_time' not in data:
            data['start_time'] = timezone.now()

        # 必须有结束时间
        if 'due_date' not in data:
            raise serializers.ValidationError({
                'due_date': ['任务必须设置结束时间。']
            })

        # 验证结束时间必须大于开始时间
        if data['due_date'] <= data['start_time']:
            raise serializers.ValidationError({
                'due_date': ['结束时间必须大于开始时间。']
            })

        # 如果是重复任务，验证配置
        repeat_type = self.initial_data.get('repeat_type')
        if repeat_type and repeat_type != 'none':
            repeat_config = self.initial_data.get('repeat_config', {})
            self.validate_repeat_config(repeat_config)
        return data

    def validate_repeat_config(self, value):
        """
        验证重复任务配置的完整性
        
        验证规则：
        1. 必须包含 start_date
        2. 如果有 end_date，必须大于 start_date
        3. interval 必须大于 0
        4. custom_days 必须在 0-6 范围内
        5. 不同重复类型的特殊验证
        """
        repeat_type = self.initial_data.get('repeat_type')
        
        # 如果不是重复任务，无需验证
        if not repeat_type or repeat_type == 'none':
            return value
            
        # 验证开始日期
        if 'start_date' not in value:
            raise serializers.ValidationError("必须指定开始日期")
        
        # 验证结束日期
        if 'end_date' in value:
            start_date = datetime.strptime(value['start_date'], '%Y-%m-%d').date()
            end_date = datetime.strptime(value['end_date'], '%Y-%m-%d').date()
            if end_date <= start_date:
                raise serializers.ValidationError("结束日期必须大于开始日期")
        
        # 验证重复间隔
        interval = value.get('interval', 1)
        if not isinstance(interval, int) or interval < 1:
            raise serializers.ValidationError("重复间隔必须是大于0的整数")
        
        # 验证自定义重复日期
        if repeat_type == 'custom':
            if 'custom_days' not in value:
                raise serializers.ValidationError("自定义重复必须指定重复日期")
                
            custom_days = value['custom_days']
            if not isinstance(custom_days, list):
                raise serializers.ValidationError("custom_days必须是列表")
                
            if not custom_days:
                raise serializers.ValidationError("自定义重复日期不能为空")
                
            if not all(isinstance(day, int) and 0 <= day <= 6 for day in custom_days):
                raise serializers.ValidationError("自定义重复日期必须是0-6的整数，0代表周一，6代表周日")
                
            if len(custom_days) != len(set(custom_days)):
                raise serializers.ValidationError("自定义重复日期不能重复")
        
        # 验证工作日重复
        elif repeat_type == 'workdays':
            if 'custom_days' in value:
                raise serializers.ValidationError("工作日重复不需要指定custom_days")
        
        # 验证周末重复
        elif repeat_type == 'weekends':
            if 'custom_days' in value:
                raise serializers.ValidationError("周末重复不需要指定custom_days")
        
        # 验证每月重复
        elif repeat_type == 'monthly':
            start_date = datetime.strptime(value['start_date'], '%Y-%m-%d').date()
            if start_date.day > 28:
                raise serializers.ValidationError("每月重复的日期不能大于28日，以避免在月末出现无效日期")
        
        return value

    def create(self, validated_data):
        validated_data['user'] = self.context['request'].user
        return super().create(validated_data)

    def update(self, instance, validated_data):
        return super().update(instance, validated_data)

    def validate_category(self, value):
        user = self.context['request'].user
        if value and value.user != user:
            raise serializers.ValidationError("分类不存在或不属于当前用户")
        return value
