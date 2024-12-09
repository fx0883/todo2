from django.db import models
from django.utils.translation import gettext_lazy as _
from simple_history.models import HistoricalRecords
from django.conf import settings

class NotificationTemplate(models.Model):
    """
    通知模板
    """
    TYPE_CHOICES = [
        ('email', _('邮件')),
        ('push', _('推送')),
        ('sms', _('短信')),
    ]

    name = models.CharField(_('模板名称'), max_length=100)
    type = models.CharField(_('类型'), max_length=20, choices=TYPE_CHOICES)
    title_template = models.CharField(_('标题模板'), max_length=200)
    content_template = models.TextField(_('内容模板'))
    created_at = models.DateTimeField(_('创建时间'), auto_now_add=True)
    updated_at = models.DateTimeField(_('更新时间'), auto_now=True)
    history = HistoricalRecords()

    class Meta:
        verbose_name = _('通知模板')
        verbose_name_plural = _('通知模板')

    def __str__(self):
        return f"{self.name} ({self.type})"

class Notification(models.Model):
    """
    通知
    """
    STATUS_CHOICES = [
        ('pending', _('待发送')),
        ('sent', _('已发送')),
        ('failed', _('发送失败')),
        ('read', _('已读')),
    ]

    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name='notifications')
    template = models.ForeignKey(NotificationTemplate, on_delete=models.SET_NULL, null=True, related_name='notifications')
    title = models.CharField(_('标题'), max_length=200)
    content = models.TextField(_('内容'))
    status = models.CharField(_('状态'), max_length=20, choices=STATUS_CHOICES, default='pending')
    error_message = models.TextField(_('错误信息'), null=True, blank=True)
    scheduled_time = models.DateTimeField(_('计划发送时间'), null=True, blank=True)
    sent_time = models.DateTimeField(_('发送时间'), null=True, blank=True)
    read_time = models.DateTimeField(_('阅读时间'), null=True, blank=True)
    created_at = models.DateTimeField(_('创建时间'), auto_now_add=True)
    updated_at = models.DateTimeField(_('更新时间'), auto_now=True)
    history = HistoricalRecords()

    class Meta:
        verbose_name = _('通知')
        verbose_name_plural = _('通知')
        ordering = ['-created_at']

    def __str__(self):
        return f"Notification for {self.user.username}: {self.title}"

class NotificationDevice(models.Model):
    """
    通知设备
    """
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name='notification_devices')
    device = models.ForeignKey('accounts.UserDevice', on_delete=models.CASCADE, related_name='notifications')
    push_token = models.CharField(_('推送令牌'), max_length=255, null=True, blank=True)
    is_enabled = models.BooleanField(_('是否启用'), default=True)
    last_active = models.DateTimeField(_('最后活跃时间'), null=True, blank=True)
    created_at = models.DateTimeField(_('创建时间'), auto_now_add=True)
    updated_at = models.DateTimeField(_('更新时间'), auto_now=True)
    history = HistoricalRecords()

    class Meta:
        verbose_name = _('通知设备')
        verbose_name_plural = _('通知设备')
        unique_together = ['user', 'device']

    def __str__(self):
        return f"Notification device for {self.user.username} on {self.device.device_name}"
