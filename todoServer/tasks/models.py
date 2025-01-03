from django.db import models
from django.utils.translation import gettext_lazy as _
from simple_history.models import HistoricalRecords
from django.conf import settings
from datetime import datetime, timedelta
from django.utils import timezone
import time

class Category(models.Model):
    """
    任务分类
    """
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name='categories')
    name = models.CharField(_('分类名称'), max_length=50)
    color = models.CharField(_('颜色'), max_length=7, default='#000000')  # Hex color code
    icon = models.CharField(_('图标'), max_length=50, null=True, blank=True)
    order = models.IntegerField(_('排序'), default=0)
    created_at = models.DateTimeField(_('创建时间'), auto_now_add=True)
    updated_at = models.DateTimeField(_('更新时间'), auto_now=True)
    history = HistoricalRecords()

    class Meta:
        verbose_name = _('分类')
        verbose_name_plural = _('分类')
        ordering = ['order', 'created_at']
        unique_together = ['user', 'name']  # 添加用户和名称的联合唯一约束

    def __str__(self):
        return f"{self.user.username}'s category: {self.name}"

class Task(models.Model):
    """
    任务
    """
    PRIORITY_CHOICES = [
        (1, _('低')),
        (2, _('中')),
        (3, _('高')),
    ]

    STATUS_CHOICES = [
        ('pending', _('待处理')),
        ('completed', _('已完成')),
        ('archived', _('已归档')),
    ]

    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name='tasks')
    title = models.CharField(_('标题'), max_length=200)
    description = models.TextField(_('描述'), null=True, blank=True)
    category = models.ForeignKey(Category, on_delete=models.SET_NULL, null=True, blank=True, related_name='tasks')
    priority = models.IntegerField(_('优先级'), choices=PRIORITY_CHOICES, default=2)
    status = models.CharField(_('状态'), max_length=20, choices=STATUS_CHOICES, default='pending')
    start_time = models.DateTimeField(_('开始时间'), null=True, blank=True)
    due_date = models.DateTimeField(_('截止时间'), null=True, blank=True)
    reminder_time = models.DateTimeField(_('提醒时间'), null=True, blank=True)
    completed_at = models.DateTimeField(_('完成时间'), null=True, blank=True)
    is_important = models.BooleanField(_('重要'), default=False)
    order = models.IntegerField(_('排序'), default=0)
    repeat_task = models.ForeignKey('RepeatTask', on_delete=models.SET_NULL, null=True, blank=True, related_name='instances')
    scheduled_date = models.DateField(_('计划日期'), null=True, blank=True)
    instance_number = models.IntegerField(_('实例序号'), null=True, blank=True)
    created_at = models.DateTimeField(_('创建时间'), auto_now_add=True)
    updated_at = models.DateTimeField(_('更新时间'), auto_now=True)
    history = HistoricalRecords()

    def get_next_occurrence(self, from_date=None):
        """
        计算下一次任务发生的时间
        """
        if not self.repeat_task or not self.repeat_task.is_active:
            return None

        if from_date is None:
            from_date = timezone.now().date()

        config = self.repeat_task.repeat_config
        repeat_type = self.repeat_task.repeat_type
        
        # 检查是否超过结束日期
        if 'end_date' in config:
            end_date = datetime.strptime(config['end_date'], '%Y-%m-%d').date()
            if from_date > end_date:
                return None

        # 获取间隔
        interval = config.get('interval', 1)
        
        if repeat_type == 'daily':
            next_date = from_date + timedelta(days=interval)
        elif repeat_type == 'weekly':
            next_date = from_date + timedelta(weeks=interval)
        elif repeat_type == 'monthly':
            # 处理月份进位
            next_month = from_date.month + interval
            next_year = from_date.year + (next_month - 1) // 12
            next_month = ((next_month - 1) % 12) + 1
            next_date = from_date.replace(year=next_year, month=next_month)
        elif repeat_type == 'yearly':
            next_date = from_date.replace(year=from_date.year + interval)
        elif repeat_type in ['workdays', 'weekends']:
            next_date = from_date + timedelta(days=1)
            while True:
                is_weekend = next_date.weekday() >= 5
                if (repeat_type == 'workdays' and not is_weekend) or \
                   (repeat_type == 'weekends' and is_weekend):
                    break
                next_date += timedelta(days=1)
        elif repeat_type == 'custom':
            custom_days = config.get('custom_days', [])
            if not custom_days:
                return None
                
            # 找到下一个符合条件的日期
            next_date = from_date + timedelta(days=1)
            while True:
                if next_date.weekday() in custom_days:
                    break
                next_date += timedelta(days=1)
        else:
            return None

        # 保持原始时间部分不变
        original_time = self.start_time.time()
        next_datetime = datetime.combine(next_date, original_time)
        return timezone.make_aware(next_datetime)

    def get_occurrences(self, start_date=None, end_date=None, limit=10):
        """
        获取指定日期范围内的所有任务发生时间
        """
        if not self.repeat_task or not self.repeat_task.is_active:
            return []

        if start_date is None:
            start_date = timezone.now().date()
        if end_date is None:
            end_date = start_date + timedelta(days=90)  # 默认往后查看90天

        occurrences = []
        current_date = start_date
        count = 0

        while current_date <= end_date and count < limit:
            next_occurrence = self.get_next_occurrence(current_date)
            if not next_occurrence:
                break
                
            occurrences.append(next_occurrence)
            current_date = next_occurrence.date() + timedelta(days=1)
            count += 1

        return occurrences

    class Meta:
        verbose_name = _('任务')
        verbose_name_plural = _('任务')
        ordering = ['-is_important', 'order', '-created_at']
        indexes = [
            models.Index(fields=['repeat_task', 'scheduled_date']),
            models.Index(fields=['user', 'scheduled_date']),
        ]

    def __str__(self):
        return f"{self.user.username}'s task: {self.title}"

class TaskComment(models.Model):
    """
    任务评论
    """
    task = models.ForeignKey(Task, on_delete=models.CASCADE, related_name='comments')
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name='task_comments')
    content = models.TextField(_('内容'))
    created_at = models.DateTimeField(_('创建时间'), auto_now_add=True)
    updated_at = models.DateTimeField(_('更新时间'), auto_now=True)
    history = HistoricalRecords()

    class Meta:
        verbose_name = _('任务评论')
        verbose_name_plural = _('任务评论')
        ordering = ['-created_at']

    def __str__(self):
        return f"Comment on {self.task.title} by {self.user.username}"

class TaskSync(models.Model):
    """
    任务同步状态
    """
    task = models.ForeignKey(Task, on_delete=models.CASCADE, related_name='sync_status')
    device = models.ForeignKey('accounts.UserDevice', on_delete=models.CASCADE, related_name='synced_tasks')
    last_sync_time = models.DateTimeField(_('最后同步时间'))
    sync_status = models.CharField(_('同步状态'), max_length=20)  # success, failed, pending
    sync_error = models.TextField(_('同步错误'), null=True, blank=True)
    created_at = models.DateTimeField(_('创建时间'), auto_now_add=True)
    updated_at = models.DateTimeField(_('更新时间'), auto_now=True)
    history = HistoricalRecords()

    class Meta:
        verbose_name = _('任务同步')
        verbose_name_plural = _('任务同步')
        unique_together = ['task', 'device']

    def __str__(self):
        return f"Sync status for {self.task.title} on {self.device.device_name}"

class RepeatTask(models.Model):
    """
    重复任务主表，存储重复任务的基本信息和重复规则
    """
    REPEAT_CHOICES = [
        ('none', _('不重复')),
        ('daily', _('每天')),
        ('weekly', _('每周')),
        ('monthly', _('每月')),
        ('yearly', _('每年')),
        ('continuous', _('一直重复')),
        ('workdays', _('工作日')),
        ('weekends', _('周末')),
        ('holidays', _('节假日')),
        ('custom', _('自定义')),
    ]

    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name='repeat_tasks')
    title = models.CharField(_('标题'), max_length=200)
    description = models.TextField(_('描述'), null=True, blank=True)
    category = models.ForeignKey(Category, on_delete=models.SET_NULL, null=True, blank=True, related_name='repeat_tasks')
    repeat_type = models.CharField(_('重复类型'), max_length=20, choices=REPEAT_CHOICES)
    repeat_config = models.JSONField(_('重复配置'))
    is_active = models.BooleanField(_('是否激活'), default=True)
    created_at = models.DateTimeField(_('创建时间'), auto_now_add=True)
    updated_at = models.DateTimeField(_('更新时间'), auto_now=True)
    history = HistoricalRecords()

    def calculate_first_instance_time(self, base_start_time):
        """
        计算第一个任务实例的开始时间和结束时间
        
        Args:
            base_start_time: 基准开始时间（用户输入的时间，实际上会被忽略，因为我们使用整天）
        
        Returns:
            tuple: (start_time, due_date) 任务的开始时间和结束时间
        """
        if not self.is_active:
            return None, None

        config = self.repeat_config
        start_date = datetime.strptime(config['start_date'], '%Y-%m-%d').date()
        
        # 如果基准时间早于配置的开始日期，使用配置的开始日期
        if base_start_time.date() < start_date:
            base_date = start_date
        else:
            base_date = base_start_time.date()

        # 根据重复类型计算第一个实例的日期
        if self.repeat_type == 'daily':
            # 如果是每天重复，使用基准日期
            target_date = base_date
        
        elif self.repeat_type == 'weekly':
            # 获取目标星期几（0-6表示周一到周日）
            target_weekday = config.get('weekday', 0)  # 默认周一
            current_weekday = base_date.weekday()
            
            # 计算到目标星期几需要添加的天数
            days_ahead = target_weekday - current_weekday
            if days_ahead <= 0:  # 如果目标日期在本周已过或就是今天，则取下周
                days_ahead += 7
                
            target_date = base_date + timedelta(days=days_ahead)
        
        elif self.repeat_type == 'monthly':
            # 获取目标日期（1-31）
            target_day = config.get('day', 1)  # 默认每月1号
            
            # 计算本月的目标日期
            try:
                target_date = base_date.replace(day=target_day)
                # 如果目标日期已过，取下个月
                if target_date < base_date:
                    if base_date.month == 12:
                        target_date = target_date.replace(year=base_date.year + 1, month=1)
                    else:
                        target_date = target_date.replace(month=base_date.month + 1)
            except ValueError:
                # 处理无效日期（如2月30日）
                if base_date.month == 12:
                    next_date = base_date.replace(year=base_date.year + 1, month=1, day=1)
                else:
                    next_date = base_date.replace(month=base_date.month + 1, day=1)
                target_date = next_date - timedelta(days=1)
        
        elif self.repeat_type == 'yearly':
            # 获取目标月份和日期
            target_month = config.get('month', 1)  # 默认1月
            target_day = config.get('day', 1)      # 默认1号
            
            try:
                target_date = base_date.replace(month=target_month, day=target_day)
                # 如果目标日期已过，取明年
                if target_date < base_date:
                    target_date = target_date.replace(year=base_date.year + 1)
            except ValueError:
                # 处理无效日期（如2月29日）
                target_date = base_date.replace(year=base_date.year + 1, month=target_month, day=1)
                target_date = target_date - timedelta(days=1)
        
        elif self.repeat_type == 'workdays':
            target_date = base_date
            # 如果是周末，移到下周一
            while target_date.weekday() >= 5:
                target_date += timedelta(days=1)
        
        elif self.repeat_type == 'weekends':
            target_date = base_date
            # 如果不是周末，移到最近的周六
            if target_date.weekday() < 5:
                days_ahead = 5 - target_date.weekday()
                target_date += timedelta(days=days_ahead)
        
        elif self.repeat_type == 'custom':
            custom_days = config.get('custom_days', [])
            if not custom_days:
                return None, None
            
            target_date = base_date
            # 找到下一个符合条件的日期
            while target_date.weekday() not in custom_days:
                target_date += timedelta(days=1)
        
        else:
            return None, None

        # 设置为目标日期的开始时间（00:00:00）和结束时间（23:59:59）
        start_time = datetime.combine(target_date, time.min)  # 00:00:00
        due_date = datetime.combine(target_date, time.max)    # 23:59:59
        
        # 转换为带时区的时间
        start_time = timezone.make_aware(start_time)
        due_date = timezone.make_aware(due_date)
            
        return start_time, due_date

    def generate_dates(self, start_date=None, end_date=None, save=True):
        """
        生成指定日期范围内的重复任务日期记录
        
        Args:
            start_date: 开始日期，如果为None则使用今天
            end_date: 结束日期，如果为None则生成未来90天的记录
            save: 是否保存到数据库
        
        Returns:
            list: 生成的日期列表
        """
        if not self.is_active:
            return []

        if start_date is None:
            start_date = timezone.now().date()
        if end_date is None:
            end_date = start_date + timedelta(days=90)

        dates = []
        current_date = start_date
        
        while current_date <= end_date:
            next_date = self.calculate_first_instance_time(
                timezone.make_aware(datetime.combine(current_date, time.min))
            )[0]
            
            if next_date is None:
                break
                
            next_date = next_date.date()
            if next_date > end_date:
                break
                
            dates.append(next_date)
            current_date = next_date + timedelta(days=1)

        if save:
            # 批量创建日期记录，使用ignore_conflicts避免重复记录报错
            RepeatTaskDate.objects.bulk_create([
                RepeatTaskDate(repeat_task=self, task_date=date)
                for date in dates
            ], ignore_conflicts=True)

        return dates

    def clean_old_dates(self, before_date=None):
        """
        清理指定日期之前的日期记录
        
        Args:
            before_date: 清理此日期之前的记录，如果为None则使用今天
        """
        if before_date is None:
            before_date = timezone.now().date()
            
        self.dates.filter(task_date__lt=before_date).delete()

    def refresh_dates(self, days_ahead=90):
        """
        刷新未来日期记录
        
        Args:
            days_ahead: 要生成未来多少天的记录
        """
        today = timezone.now().date()
        end_date = today + timedelta(days=days_ahead)
        
        # 清理旧记录
        self.clean_old_dates()
        
        # 生成新记录
        return self.generate_dates(today, end_date)

    class Meta:
        verbose_name = _('重复任务')
        verbose_name_plural = _('重复任务')
        ordering = ['-created_at']

    def __str__(self):
        return f"{self.user.username}'s repeat task: {self.title}"

class RepeatTaskDate(models.Model):
    """
    重复任务日期表，用于快速查询某天是否有重复任务
    """
    repeat_task = models.ForeignKey(RepeatTask, on_delete=models.CASCADE, related_name='dates')
    task_date = models.DateField(_('任务日期'))
    created_at = models.DateTimeField(_('创建时间'), auto_now_add=True)

    class Meta:
        verbose_name = _('重复任务日期')
        verbose_name_plural = _('重复任务日期')
        # 添加联合唯一索引，确保同一个重复任务在同一天只有一条记录
        unique_together = ['repeat_task', 'task_date']
        # 添加索引以优化查询
        indexes = [
            models.Index(fields=['task_date']),
            models.Index(fields=['repeat_task', 'task_date']),
        ]

    def __str__(self):
        return f"{self.repeat_task.title} - {self.task_date}"
