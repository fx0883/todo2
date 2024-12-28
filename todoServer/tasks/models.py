from django.db import models
from django.utils.translation import gettext_lazy as _
from simple_history.models import HistoricalRecords
from django.conf import settings

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

class Tag(models.Model):
    """
    任务标签
    """
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name='tags')
    name = models.CharField(_('标签名称'), max_length=50)
    color = models.CharField(_('颜色'), max_length=7, default='#000000')
    created_at = models.DateTimeField(_('创建时间'), auto_now_add=True)
    updated_at = models.DateTimeField(_('更新时间'), auto_now=True)
    history = HistoricalRecords()

    class Meta:
        verbose_name = _('标签')
        verbose_name_plural = _('标签')
        unique_together = ['user', 'name']

    def __str__(self):
        return f"{self.user.username}'s tag: {self.name}"

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
    tags = models.ManyToManyField(Tag, blank=True, related_name='tasks')
    priority = models.IntegerField(_('优先级'), choices=PRIORITY_CHOICES, default=2)
    status = models.CharField(_('状态'), max_length=20, choices=STATUS_CHOICES, default='pending')
    due_date = models.DateTimeField(_('截止时间'), null=True, blank=True)
    reminder_time = models.DateTimeField(_('提醒时间'), null=True, blank=True)
    completed_at = models.DateTimeField(_('完成时间'), null=True, blank=True)
    is_important = models.BooleanField(_('是否重要'), default=False)
    order = models.IntegerField(_('排序'), default=0)
    
    # 新增字段
    repeat_task = models.ForeignKey('RepeatTask', on_delete=models.SET_NULL, null=True, blank=True, related_name='instances')
    scheduled_date = models.DateTimeField(_('计划日期'), null=True, blank=True)
    instance_number = models.IntegerField(_('重复序号'), null=True, blank=True)
    
    created_at = models.DateTimeField(_('创建时间'), auto_now_add=True)
    updated_at = models.DateTimeField(_('更新时间'), auto_now=True)
    history = HistoricalRecords()

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

    class Meta:
        verbose_name = _('重复任务')
        verbose_name_plural = _('重复任务')
        ordering = ['-created_at']

    def __str__(self):
        return f"{self.user.username}'s repeat task: {self.title}"
