import { ref, computed } from 'vue'
import { useTaskStore } from '@/store'
import { usePreferences } from './usePreferences'

export function useCalendar() {
  const taskStore = useTaskStore()
  const { preferences } = usePreferences()
  
  const viewType = ref('month')
  const currentDate = ref(new Date())
  
  // 计算日历范围
  const dateRange = computed(() => {
    const start = new Date(currentDate.value)
    const end = new Date(currentDate.value)
    
    switch(viewType.value) {
      case 'day':
        start.setHours(0, 0, 0, 0)
        end.setDate(end.getDate() + 1)
        break
      case 'week':
        start.setDate(start.getDate() - start.getDay())
        end.setDate(start.getDate() + 7)
        break
      case 'month':
        start.setDate(1)
        end.setMonth(end.getMonth() + 1, 0)
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
        end_date: end.toISOString().split('T')[0],
        view_type: viewType.value
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
  const changeDate = async (date) => {
    currentDate.value = date
    await fetchCalendarTasks()
  }

  return {
    viewType,
    currentDate,
    dateRange,
    loading: computed(() => taskStore.loading),
    error: computed(() => taskStore.error),
    tasks: computed(() => taskStore.calendarTasks),
    fetchCalendarTasks,
    updateTaskDate,
    quickAddTask,
    changeViewType,
    changeDate
  }
} 