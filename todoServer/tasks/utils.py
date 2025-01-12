from datetime import datetime, timedelta
from django.utils import timezone
from typing import List, Optional

def generate_repeat_dates(
    repeat_type: str,
    repeat_config: dict,
    start_date: datetime,
    end_date: Optional[datetime] = None,
    limit: Optional[int] = None
) -> List[datetime]:
    """
    根据重复类型和配置生成重复日期列表
    
    Args:
        repeat_type: 重复类型
        repeat_config: 重复配置
        start_date: 开始日期
        end_date: 结束日期（可选）
        limit: 生成的日期数量限制（可选）
    
    Returns:
        重复日期列表
    """
    dates = []
    current_date = start_date
    interval = repeat_config.get('interval', 1)
    
    while True:
        # 检查是否达到限制
        if limit and len(dates) >= limit:
            break
            
        # 检查是否超过结束日期
        if end_date and current_date > end_date:
            break
            
        # 根据重复类型生成日期
        if repeat_type == 'daily':
            dates.append(current_date)
            current_date += timedelta(days=interval)
            
        elif repeat_type == 'weekly':
            custom_days = repeat_config.get('custom_days', [0])  # 默认周一
            if current_date.weekday() in custom_days:
                dates.append(current_date)
            current_date += timedelta(days=1)
            
        elif repeat_type == 'monthly':
            target_day = repeat_config.get('day', current_date.day)
            if current_date.day == target_day:
                dates.append(current_date)
                # 处理月份进位
                year = current_date.year + ((current_date.month + interval - 1) // 12)
                month = ((current_date.month + interval - 1) % 12) + 1
                try:
                    current_date = current_date.replace(year=year, month=month)
                except ValueError:
                    # 处理无效日期（如2月30日）
                    if current_date.day > 28:
                        current_date = current_date.replace(year=year, month=month, day=1)
                        current_date += timedelta(days=-1)
            else:
                current_date += timedelta(days=1)
                
        elif repeat_type == 'yearly':
            target_month = repeat_config.get('month', current_date.month)
            target_day = repeat_config.get('day', current_date.day)
            if current_date.month == target_month and current_date.day == target_day:
                dates.append(current_date)
                current_date = current_date.replace(year=current_date.year + interval)
            else:
                current_date += timedelta(days=1)
                
        elif repeat_type == 'workdays':
            if current_date.weekday() < 5:  # 0-4 表示周一到周五
                dates.append(current_date)
            current_date += timedelta(days=1)
            
        elif repeat_type == 'weekends':
            if current_date.weekday() >= 5:  # 5-6 表示周六和周日
                dates.append(current_date)
            current_date += timedelta(days=1)
            
        elif repeat_type == 'continuous':
            dates.append(current_date)
            current_date += timedelta(days=1)
            
        else:  # repeat_type == 'none' or unknown type
            break
    
    return dates

def should_create_task_instance(date: datetime) -> bool:
    """
    检查是否应该为指定日期创建任务实例
    """
    # 可以在这里添加节假日检查等逻辑
    return True
