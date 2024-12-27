from django.contrib import admin
from django.contrib.auth.admin import UserAdmin
from .models import User, UserProfile, UserDevice, VerificationCode, UserFeedback
from simple_history.admin import SimpleHistoryAdmin

@admin.register(User)
class CustomUserAdmin(UserAdmin, SimpleHistoryAdmin):
    list_display = ('username', 'email', 'nickname', 'phone', 'is_active', 'is_staff', 'date_joined')
    list_filter = ('is_active', 'is_staff', 'is_superuser', 'is_email_verified')
    search_fields = ('username', 'email', 'nickname', 'phone')
    ordering = ('-date_joined',)
    
    fieldsets = UserAdmin.fieldsets + (
        ('额外信息', {'fields': ('phone', 'nickname', 'avatar', 'is_email_verified', 'last_login_ip',
                             'openid', 'unionid', 'session_key')}),
    )

@admin.register(UserProfile)
class UserProfileAdmin(SimpleHistoryAdmin):
    list_display = ('user', 'theme', 'timezone', 'language', 'created_at', 'updated_at')
    list_filter = ('theme', 'language')
    search_fields = ('user__username', 'user__email')
    ordering = ('-created_at',)

@admin.register(UserDevice)
class UserDeviceAdmin(SimpleHistoryAdmin):
    list_display = ('user', 'device_name', 'device_type', 'is_active', 'last_sync_time', 'created_at')
    list_filter = ('device_type', 'is_active')
    search_fields = ('user__username', 'device_name', 'device_id')
    ordering = ('-created_at',)

@admin.register(VerificationCode)
class VerificationCodeAdmin(SimpleHistoryAdmin):
    list_display = ('user', 'purpose', 'is_used', 'expires_at', 'created_at')
    list_filter = ('purpose', 'is_used')
    search_fields = ('user__username', 'user__email')
    ordering = ('-created_at',)

@admin.register(UserFeedback)
class UserFeedbackAdmin(SimpleHistoryAdmin):
    list_display = ('user', 'type', 'title', 'status', 'created_at', 'updated_at')
    list_filter = ('type', 'status')
    search_fields = ('user__username', 'title', 'content')
    ordering = ('-created_at',)
