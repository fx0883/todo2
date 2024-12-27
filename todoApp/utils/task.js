// 获取优先级文本
export const getPriorityText = (priority) => {
  const priorityMap = {
    1: '低',
    2: '中',
    3: '高'
  }
  return priorityMap[priority] || '无'
}

// 格式化任务状态
export const getStatusText = (status) => {
  const statusMap = {
    'pending': '待完成',
    'completed': '已完成',
    'overdue': '已逾期'
  }
  return statusMap[status] || status
}

// 获取优先级颜色
export const getPriorityColor = (priority) => {
  const colorMap = {
    1: '#34C759', // 低优先级 - 绿色
    2: '#FF9500', // 中优先级 - 橙色
    3: '#FF3B30'  // 高优先级 - 红色
  }
  return colorMap[priority] || '#999999'
} 