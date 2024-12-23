from django.contrib import admin
from simple_history.admin import SimpleHistoryAdmin
from .models import Category, Tag, Task, TaskComment, TaskSync

@admin.register(Category)
class CategoryAdmin(SimpleHistoryAdmin):
    list_display = ('name', 'user', 'color', 'icon', 'order', 'created_at', 'updated_at')
    list_filter = ('user', 'created_at')
    search_fields = ('name', 'user__username')
    ordering = ('order', 'created_at')
    
    fieldsets = (
        ('基本信息', {
            'fields': ('user', 'name', 'color', 'icon', 'order')
        }),
        ('时间信息', {
            'fields': ('created_at', 'updated_at'),
            'classes': ('collapse',)
        })
    )
    readonly_fields = ('created_at', 'updated_at')

@admin.register(Tag)
class TagAdmin(SimpleHistoryAdmin):
    list_display = ('name', 'user', 'color', 'created_at', 'updated_at')
    list_filter = ('user', 'created_at')
    search_fields = ('name', 'user__username')
    ordering = ('created_at',)
    
    fieldsets = (
        ('基本信息', {
            'fields': ('user', 'name', 'color')
        }),
        ('时间信息', {
            'fields': ('created_at', 'updated_at'),
            'classes': ('collapse',)
        })
    )
    readonly_fields = ('created_at', 'updated_at')

@admin.register(Task)
class TaskAdmin(SimpleHistoryAdmin):
    list_display = ('title', 'user', 'status', 'priority', 'due_date', 'is_important', 'created_at')
    list_filter = ('status', 'priority', 'is_important', 'user', 'created_at')
    search_fields = ('title', 'description', 'user__username')
    ordering = ('-created_at',)
    filter_horizontal = ('tags',)  # 多对多字段使用水平过滤器
    
    fieldsets = (
        ('基本信息', {
            'fields': ('user', 'title', 'description', 'status')
        }),
        ('任务属性', {
            'fields': ('priority', 'category', 'tags', 'is_important', 'order')
        }),
        ('时间信息', {
            'fields': ('due_date', 'reminder_time', 'completed_at', 'created_at', 'updated_at'),
            'classes': ('collapse',)
        }),
        ('重复设置', {
            'fields': ('repeat_type', 'repeat_config'),
            'classes': ('collapse',)
        })
    )
    readonly_fields = ('created_at', 'updated_at')

@admin.register(TaskComment)
class TaskCommentAdmin(SimpleHistoryAdmin):
    list_display = ('task', 'user', 'content', 'created_at')
    list_filter = ('user', 'created_at')
    search_fields = ('content', 'user__username', 'task__title')
    ordering = ('-created_at',)
    
    fieldsets = (
        ('基本信息', {
            'fields': ('task', 'user', 'content')
        }),
        ('时间信息', {
            'fields': ('created_at', 'updated_at'),
            'classes': ('collapse',)
        })
    )
    readonly_fields = ('created_at', 'updated_at')

@admin.register(TaskSync)
class TaskSyncAdmin(SimpleHistoryAdmin):
    list_display = ('task', 'device', 'sync_status', 'last_sync_time', 'created_at')
    list_filter = ('sync_status', 'device', 'created_at')
    search_fields = ('task__title', 'device__device_name', 'sync_error')
    ordering = ('-last_sync_time',)
    
    fieldsets = (
        ('同步信息', {
            'fields': ('task', 'device', 'sync_status', 'last_sync_time')
        }),
        ('错误信息', {
            'fields': ('sync_error',),
            'classes': ('collapse',)
        }),
        ('时间信息', {
            'fields': ('created_at', 'updated_at'),
            'classes': ('collapse',)
        })
    )
    readonly_fields = ('created_at', 'updated_at')
