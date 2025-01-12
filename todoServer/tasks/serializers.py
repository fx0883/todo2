from rest_framework import serializers
from drf_spectacular.utils import extend_schema_serializer, OpenApiExample
from .models import Category, Task, TaskComment, TaskSync, RepeatTask
from datetime import datetime
from django.utils import timezone
from django.db import transaction

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
    # 添加重复任务相关字段
    repeat_type = serializers.CharField(write_only=True, required=False, allow_null=True)
    repeat_config = serializers.JSONField(write_only=True, required=False, allow_null=True)

    class Meta:
        model = Task
        fields = (
            'id', 'user', 'title', 'description', 'category', 'priority',
            'status', 'start_time', 'due_date', 'reminder_time', 'completed_at',
            'is_important', 'order', 'repeat_task', 'scheduled_date',
            'instance_number', 'created_at', 'updated_at', 'comments',
            'repeat_task_detail', 'repeat_type', 'repeat_config'  # 添加新字段
        )
        read_only_fields = ('id', 'user', 'created_at', 'updated_at', 'completed_at')

    def validate(self, data):
        """验证任务数据"""
        # 验证重复任务配置
        repeat_type = data.get('repeat_type')
        repeat_config = data.get('repeat_config')

        if repeat_type and not repeat_config:
            raise serializers.ValidationError({'repeat_config': 'Repeat configuration is required when repeat_type is provided.'})
        
        if repeat_config and not repeat_type:
            raise serializers.ValidationError({'repeat_type': 'Repeat type is required when repeat_config is provided.'})

        if repeat_type and repeat_config:
            # 验证重复任务配置
            self.validate_repeat_config(repeat_config)
            
            # 验证重复类型
            valid_repeat_types = dict(RepeatTask.REPEAT_CHOICES).keys()
            if repeat_type not in valid_repeat_types:
                raise serializers.ValidationError({'repeat_type': f'Invalid repeat type. Must be one of: {", ".join(valid_repeat_types)}'})
        
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

        return super().validate(data)

    def validate_repeat_config(self, value):
        """验证重复任务配置"""
        if not isinstance(value, dict):
            raise serializers.ValidationError("重复配置必须是一个对象")
        
        # 验证必填字段
        required_fields = ['start_date']
        for field in required_fields:
            if field not in value:
                raise serializers.ValidationError(f"缺少必填字段: {field}")
        
        # 验证日期格式
        try:
            start_date = datetime.strptime(value['start_date'], '%Y-%m-%d').date()
        except ValueError:
            raise serializers.ValidationError("开始日期格式错误，应为 YYYY-MM-DD")
        
        # 验证结束日期（如果有）
        if 'end_date' in value:
            try:
                end_date = datetime.strptime(value['end_date'], '%Y-%m-%d').date()
                if end_date < start_date:
                    raise serializers.ValidationError("结束日期不能早于开始日期")
            except ValueError:
                raise serializers.ValidationError("结束日期格式错误，应为 YYYY-MM-DD")
        
        # 验证时间格式
        time_fields = ['start_time', 'end_time']
        for field in time_fields:
            if field in value:
                try:
                    datetime.strptime(value[field], '%H:%M')
                except ValueError:
                    raise serializers.ValidationError(f"{field} 格式错误，应为 HH:MM")
        
        # 验证时间顺序
        if 'start_time' in value and 'end_time' in value:
            start_time = datetime.strptime(value['start_time'], '%H:%M').time()
            end_time = datetime.strptime(value['end_time'], '%H:%M').time()
            if end_time <= start_time:
                raise serializers.ValidationError("结束时间必须晚于开始时间")
        
        # 验证间隔
        interval = value.get('interval', 1)
        if not isinstance(interval, int) or interval < 1:
            raise serializers.ValidationError("间隔必须是大于0的整数")
        
        # 验证自定义天数
        custom_days = value.get('custom_days', [])
        if not isinstance(custom_days, list):
            raise serializers.ValidationError("custom_days 必须是一个数组")
        
        for day in custom_days:
            if not isinstance(day, int) or day < 0 or day > 6:
                raise serializers.ValidationError("custom_days 必须是0-6之间的整数数组")
        
        return value

    def create(self, validated_data):
        """创建任务"""
        repeat_type = self.context['request'].data.get('repeat_type')
        repeat_config = self.context['request'].data.get('repeat_config')
        
        if repeat_type and repeat_config:
            # 只创建重复任务记录
            repeat_task = RepeatTask.objects.create(
                user=self.context['request'].user,
                title=validated_data.get('title'),
                description=validated_data.get('description'),
                category=validated_data.get('category'),
                repeat_type=repeat_type,
                repeat_config=repeat_config,
                is_active=True
            )
            return repeat_task
        else:
            # 创建普通任务
            return super().create(validated_data)

    def update(self, instance, validated_data):
        """更新任务"""
        # 不允许通过更新接口修改重复任务配置
        validated_data.pop('repeat_type', None)
        validated_data.pop('repeat_config', None)
        return super().update(instance, validated_data)

    def validate_category(self, value):
        user = self.context['request'].user
        if value and value.user != user:
            raise serializers.ValidationError("分类不存在或不属于当前用户")
        return value
