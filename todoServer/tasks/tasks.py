from celery import shared_task
from django.utils import timezone
from datetime import datetime, timedelta
from .models import RepeatTask, Task
from .utils import generate_repeat_dates, should_create_task_instance

def create_task_instances(repeat_task_id: int, days_ahead: int = 365):
    """
    为重复任务创建未来的任务实例（同步版本）
    
    Args:
        repeat_task_id: 重复任务ID
        days_ahead: 提前创建多少天的任务实例，默认一年
    """
    try:
        repeat_task = RepeatTask.objects.get(id=repeat_task_id)
        if not repeat_task.is_active:
            return
        
        # 获取最后一个任务实例
        last_instance = Task.objects.filter(
            repeat_task=repeat_task
        ).order_by('-scheduled_date').first()
        
        # 确定开始日期
        start_date = timezone.now()
        if last_instance and last_instance.scheduled_date > start_date:
            start_date = last_instance.scheduled_date + timedelta(days=1)
        
        # 生成日期列表，最多一年
        end_date = min(
            start_date + timedelta(days=days_ahead),
            start_date + timedelta(days=365)  # 最多一年
        )
        dates = generate_repeat_dates(
            repeat_type=repeat_task.repeat_type,
            repeat_config=repeat_task.repeat_config,
            start_date=start_date,
            end_date=end_date
        )
        
        # 获取最后的实例编号
        last_number = Task.objects.filter(
            repeat_task=repeat_task
        ).order_by('-instance_number').values_list(
            'instance_number', flat=True
        ).first() or 0
        
        # 创建新的任务实例
        new_instances = []
        for i, date in enumerate(dates, start=1):
            if should_create_task_instance(date):
                # 设置开始时间为当天9点
                start_time = date.replace(hour=9, minute=0, second=0)
                # 设置截止时间为当天结束
                due_date = date.replace(hour=23, minute=59, second=59)
                new_instances.append(Task(
                    user=repeat_task.user,
                    title=repeat_task.title,
                    description=repeat_task.description,
                    category=repeat_task.category,
                    repeat_task=repeat_task,
                    scheduled_date=date,
                    start_time=start_time,  # 添加开始时间
                    due_date=due_date,
                    instance_number=last_number + i
                ))
        
        if new_instances:
            Task.objects.bulk_create(new_instances)
            
        return len(new_instances)
        
    except RepeatTask.DoesNotExist:
        return None
    except Exception as e:
        print(f"Error creating task instances for repeat task {repeat_task_id}: {str(e)}")
        return None

@shared_task
def create_future_task_instances(repeat_task_id: int, days_ahead: int = 365):
    """
    为重复任务创建未来的任务实例（异步版本）
    如果 Celery 不可用，会回退到同步版本
    """
    try:
        return create_task_instances(repeat_task_id, days_ahead)
    except Exception as e:
        print(f"Async task creation failed, falling back to sync: {str(e)}")
        return create_task_instances(repeat_task_id, days_ahead)

@shared_task
def cleanup_old_task_instances():
    """
    清理过期的任务实例
    默认清理30天前的已完成或已归档的任务
    """
    cleanup_date = timezone.now() - timedelta(days=30)
    Task.objects.filter(
        repeat_task__isnull=False,
        scheduled_date__lt=cleanup_date,
        status__in=['completed', 'archived']
    ).delete()
