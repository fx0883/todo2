import { ref, computed } from 'vue'
import { useTaskStore } from '@/store'
import { usePreferences } from './usePreferences'

export function useCalendar() {
	
  const taskStore = useTaskStore()
  const { preferences } = usePreferences()
  
  const viewType = ref('month')
  const currentDate = ref(new Date())
  
  
  const loading = ref(taskStore.loading)
  const error = ref(taskStore.error)
  const tasks = computed(() => {
    const allTasks = taskStore.calendarTasks
    // 根据用户偏好设置排序
    return [...allTasks].sort((a, b) => {
      switch (preferences.value.taskSort) {
        case 'dueDate':
          return new Date(a.dueDate) - new Date(b.dueDate)
        case 'priority':
          return b.priority - a.priority
        case 'title':
          return a.title.localeCompare(b.title)
        default:
          return new Date(b.createdAt) - new Date(a.createdAt)
      }
    })
  })
  // 计算日历范围
  const dateRange = computed(() => {
    const start = new Date(currentDate.value)
    const end = new Date(currentDate.value)
    
    switch(viewType.value) {
      case 'day':
        // start.setHours(0, 0, 0, 0)
        // end.setHours(23, 59, 59, 999)
        break
      case 'week':
        start.setDate(start.getDate() - start.getDay())
        start.setHours(0, 0, 0, 0)
        end.setDate(start.getDate() + 6)
        end.setHours(23, 59, 59, 999)
        break
      case 'month':
        start.setDate(1)
        start.setHours(0, 0, 0, 0)
        end.setMonth(end.getMonth() + 1, 0)
        end.setHours(23, 59, 59, 999)
        break
    }
    
    return { start, end }
  })

  // 获取日历视图的任务
  const fetchCalendarTasks = async () => {
    const { start, end } = dateRange.value
    try {
      // 使用 store 的 action 获取数据
      await taskStore.fetchCalendarTasks({
        start_date: start.toISOString().split('T')[0],
        end_date: end.toISOString().split('T')[0]
      })
    } catch (err) {
      console.error('获取任务失败:', err)
      throw err
    }
  }

  // 更新任务日期（拖拽）
  const updateTaskDate = async (taskId, newDate) => {
    try {
      await taskStore.updateTaskDate(taskId, newDate)
      // 更新后重新获取日历数据
      await fetchCalendarTasks()
    } catch (err) {
      console.error('更新任务日期失败:', err)
      throw err
    }
  }

  // 快速创建任务
  const quickAddTask = async (title, date) => {
    try {
      await taskStore.quickCreateTask({
        title,
        due_date: date.toISOString().split('T')[0],
        priority: 2 // 默认中等优先级
      })
      // 创建后重新获取日历数据
      await fetchCalendarTasks()
    } catch (err) {
      console.error('创建任务失败:', err)
      throw err
    }
  }

  // 切换视图类型
  const changeViewType = async (type) => {
    viewType.value = type
    await fetchCalendarTasks()
  }

  // 切换日期
  const changeDate = async (date,type = 'day') => {
    viewType.value = type
    currentDate.value = date
    await fetchCalendarTasks()
  }

  // 更新任务状态
  const updateTaskStatus = async (taskId, completed) => {
    try {
      await taskStore.updateTask(taskId, {
        completed,
        completed_at: completed ? new Date().toISOString() : null
      })
      // 更新后重新获取日历数据
      await fetchCalendarTasks()
    } catch (err) {
      console.error('更新任务状态失败:', err)
      throw err
    }
  }
  
  // 清除错误
  const clearError = () => {
    error.value = null
  }
  
 // 修改 toggleTaskStatus 方法
 const toggleTaskStatus = async (taskId) => {
   try {
     loading.value = true
     clearError()
     
     // 先获取当前任务信息
     const currentTask = tasks.value.find(t => t.id === taskId)
     if (!currentTask) {
       throw new Error('任务不存在')
     }
     
     // 准备更新数据，包含必填字段
     const updateData = {
       title: currentTask.title, // 保留原标题
       status: currentTask.status === 'completed' ? 'pending' : 'completed'
     }
     
     const updatedTask = await updateTask(taskId, updateData)
     
     if (updatedTask) {
       uni.showToast({
         title: updatedTask.status === 'completed' ? '已完成' : '已取消完成',
         icon: 'success'
       })
     }
     
     return updatedTask
   } catch (e) {
     error.value = e.message || '更新任务状态失败'
     throw e
   } finally {
     loading.value = false
   }
 }
  
  const updateTask = async (taskId, taskData) => {
    try {
      loading.value = true
      clearError()
      const task = await taskStore.updateTask(taskId, taskData)
      return task
    } catch (e) {
      error.value = e.message || '更新任务失败'
      return null
    } finally {
      loading.value = false
    }
  }
  

  

  return {
	  
    viewType,
    currentDate,
    dateRange,
    loading,
    error,
    tasks,
    fetchCalendarTasks,
    updateTaskDate,
    quickAddTask,
    changeViewType,
    changeDate,
	toggleTaskStatus,
    updateTaskStatus
  }
} 