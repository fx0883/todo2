from django.db import models
from django.utils.translation import gettext_lazy as _
from simple_history.models import HistoricalRecords
from django.conf import settings
from datetime import datetime, timedelta, time
from django.utils import timezone

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

    def __str__(self):
        return f"{self.user.username}'s repeat task: {self.title}"

    def save(self, *args, **kwargs):
        super().save(*args, **kwargs)

    class Meta:
        verbose_name = _('重复任务')
        verbose_name_plural = _('重复任务')
        ordering = ['-created_at']
