from django.db import models
from django.contrib.auth.models import AbstractUser
from django.utils.translation import gettext_lazy as _
from encrypted_model_fields.fields import EncryptedCharField
from simple_history.models import HistoricalRecords
import uuid

def user_avatar_path(instance, filename):
    """为每个用户生成独特的头像保存路径"""
    # 获取文件扩展名
    ext = filename.split('.')[-1]
    # 生成新的文件名：username_随机字符串.扩展名
    filename = f"{instance.username}_{uuid.uuid4().hex[:8]}.{ext}"
    # 返回完整的上传路径
    return f'images/avatar/{filename}'

class User(AbstractUser):
    """
    自定义用户模型
    """
    phone = models.CharField(_('手机号'), max_length=11, unique=True, null=True, blank=True)
    wechat_id = models.CharField(_('微信ID'), max_length=100, unique=True, null=True, blank=True)
    avatar = models.ImageField(
        _('头像'),
        upload_to=user_avatar_path,  # 使用自定义的路径生成函数
        null=True,
        blank=True
    )
    is_email_verified = models.BooleanField(_('邮箱是否验证'), default=False)
    last_login_ip = models.GenericIPAddressField(_('最后登录IP'), null=True, blank=True)
    created_at = models.DateTimeField(_('创建时间'), auto_now_add=True)
    updated_at = models.DateTimeField(_('更新时间'), auto_now=True)
    history = HistoricalRecords()

    class Meta:
        verbose_name = _('用户')
        verbose_name_plural = _('用户')

    def __str__(self):
        return self.username

class UserProfile(models.Model):
    """
    用户配置文件
    """
    user = models.OneToOneField(User, on_delete=models.CASCADE, related_name='profile')
    theme = models.CharField(_('主题'), max_length=20, default='light')
    notification_preferences = models.JSONField(_('通知偏好'), default=dict)
    timezone = models.CharField(_('时区'), max_length=50, default='Asia/Shanghai')
    language = models.CharField(_('语言'), max_length=10, default='zh-hans')
    created_at = models.DateTimeField(_('创建时间'), auto_now_add=True)
    updated_at = models.DateTimeField(_('更新时间'), auto_now=True)
    history = HistoricalRecords()

    class Meta:
        verbose_name = _('用户配置')
        verbose_name_plural = _('用户配置')

    def __str__(self):
        return f"{self.user.username}'s profile"

class UserDevice(models.Model):
    """
    用户设备信息，用于多端同步
    """
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='devices')
    device_id = models.CharField(_('设备ID'), max_length=100, unique=True)
    device_name = models.CharField(_('设备名称'), max_length=100)
    device_type = models.CharField(_('设备类型'), max_length=50)  # mobile, tablet, desktop
    last_sync_time = models.DateTimeField(_('最后同步时间'), null=True, blank=True)
    is_active = models.BooleanField(_('是否活跃'), default=True)
    created_at = models.DateTimeField(_('创建时间'), auto_now_add=True)
    updated_at = models.DateTimeField(_('更新时间'), auto_now=True)
    history = HistoricalRecords()

    class Meta:
        verbose_name = _('用户设备')
        verbose_name_plural = _('用户设备')

    def __str__(self):
        return f"{self.user.username}'s {self.device_name}"

class VerificationCode(models.Model):
    """
    验证码
    """
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='verification_codes')
    code = EncryptedCharField(_('验证码'), max_length=6)
    purpose = models.CharField(_('用途'), max_length=20)  # email_verification, password_reset
    is_used = models.BooleanField(_('是否已使用'), default=False)
    expires_at = models.DateTimeField(_('过期时间'))
    created_at = models.DateTimeField(_('创建时间'), auto_now_add=True)
    history = HistoricalRecords()

    class Meta:
        verbose_name = _('验证码')
        verbose_name_plural = _('验证码')

    def __str__(self):
        return f"{self.user.username}'s verification code"

class UserFeedback(models.Model):
    """
    用户反馈
    """
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='feedbacks')
    type = models.CharField(_('反馈类型'), max_length=20)  # bug, feature_request, complaint, other
    title = models.CharField(_('标题'), max_length=200)
    content = models.TextField(_('内容'))
    status = models.CharField(_('状态'), max_length=20, default='pending')  # pending, in_progress, resolved, closed
    response = models.TextField(_('回复'), null=True, blank=True)
    created_at = models.DateTimeField(_('创建时间'), auto_now_add=True)
    updated_at = models.DateTimeField(_('更新时间'), auto_now=True)
    history = HistoricalRecords()

    class Meta:
        verbose_name = _('用户反馈')
        verbose_name_plural = _('用户反馈')

    def __str__(self):
        return f"{self.user.username}'s feedback: {self.title}"
