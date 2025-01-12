# 开发日志：重构重复任务创建逻辑

日期：2025-01-12

## 变更概述

重构了重复任务的创建逻辑，简化了数据库结构和任务创建流程。主要目标是优化重复任务的存储方式，提高系统性能和可维护性。

## 主要变更

### 1. 数据模型变更
- 移除了 `RepeatTaskDate` 模型，不再预先生成重复任务的日期记录
- 简化了 `RepeatTask` 模型，移除了日期生成相关的方法

### 2. API 变更
- 修改了重复任务的创建逻辑，现在只在 `tasks_repeattask` 表中创建一条记录
- 移除了创建重复任务时自动生成任务实例的逻辑
- 优化了 API 响应速度，因为不再需要在创建时生成大量任务实例

### 3. 代码重构
#### TaskSerializer
- 简化了 `create` 方法，对于重复任务只创建 `RepeatTask` 记录
- 移除了不必要的时间计算和实例生成逻辑

#### TaskViewSet
- 添加了 `get_serializer_class` 方法，根据请求类型动态选择序列化器
- 简化了 `perform_create` 方法
- 重写了 `today` 和 `tomorrow` 方法，实现按需创建任务实例的逻辑

## 技术细节

### 重复任务创建
```json
POST /api/v1/tasks/tasks/
{
  "title": "每周例会",
  "description": "团队周会",
  "repeat_type": "weekly",
  "repeat_config": {
    "start_date": "2024-01-01",
    "end_date": "2024-12-31",
    "start_time": "09:00",
    "end_time": "10:00",
    "custom_days": [0],
    "interval": 1
  },
  "category": 1,
  "priority": 2,
  "is_important": true
}
```

### 动态任务实例生成
- 用户访问 today/tomorrow API 时，系统会根据重复任务的配置动态创建任务实例
- 检查日期范围、重复类型和具体配置来决定是否创建实例
- 避免重复创建已存在的任务实例

## 性能优化
1. 减少数据库存储空间：不再存储预生成的任务日期
2. 提高创建速度：创建重复任务时只插入一条记录
3. 按需生成：只在需要时才创建具体的任务实例

## 后续计划
1. 监控动态任务生成的性能表现
2. 考虑添加任务实例的缓存机制
3. 优化重复任务的编辑和删除功能

## 相关文件
- `tasks/models.py`
- `tasks/serializers.py`
- `tasks/views.py`

## 测试要点
1. 重复任务创建
2. today/tomorrow API 的任务实例生成
3. 不同重复类型的任务处理
4. 边界条件处理（日期范围、重复规则等）
