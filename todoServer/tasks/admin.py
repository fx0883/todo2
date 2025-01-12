from django.contrib import admin
from simple_history.admin import SimpleHistoryAdmin
from .models import Category, Task, TaskComment, RepeatTask

@admin.register(Category)
class CategoryAdmin(SimpleHistoryAdmin):
    list_display = ('name', 'user', 'created_at', 'updated_at')
    list_filter = ('user',)
    search_fields = ('name',)

@admin.register(Task)
class TaskAdmin(SimpleHistoryAdmin):
    list_display = ('title', 'user', 'status', 'priority', 'category', 'created_at', 'updated_at')
    list_filter = ('user', 'status', 'priority', 'category')
    search_fields = ('title', 'description')

@admin.register(TaskComment)
class TaskCommentAdmin(SimpleHistoryAdmin):
    list_display = ('task', 'user', 'created_at')
    list_filter = ('user', 'task')
    search_fields = ('content',)

@admin.register(RepeatTask)
class RepeatTaskAdmin(SimpleHistoryAdmin):
    list_display = ('title', 'user', 'repeat_type', 'is_active', 'created_at', 'updated_at')
    list_filter = ('user', 'repeat_type', 'is_active')
    search_fields = ('title', 'description')
