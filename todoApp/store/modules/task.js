import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import { useCache } from '@/composables/useCache'
import { useErrorLog } from '@/composables/useErrorLog'
import { taskApi } from '@/api'
import { useCategoryStore } from './category'
import { useTagStore } from './tag'

export const useTaskStore = defineStore('task', () => {
  // 使用 composables
  const cache = useCache()
  const { addErrorLog } = useErrorLog()

  // 状态
  const rawTasks = ref([])
  const loading = ref(false)
  const currentPage = ref(1)
  const totalCount = ref(0)
  const hasMore = ref(true)
  const pageSize = ref(10)

  // 评论相关状态
  const comments = ref([])
  const commentPage = ref(1)
  const hasMoreComments = ref(true)

  // 添加日历视图专用的状态
  const calendarTasks = ref([])

  // 添加优先级统计的状态管理
  const priorityStats = ref(null)

  // 公共排序方法
  const sortTasks = (taskList) => {
    return taskList.sort((a, b) => {
      if (a.status !== b.status) {
        return a.status === 'completed' ? 1 : -1
      }
      return new Date(b.createdAt) - new Date(a.createdAt)
    })
  }

  // 计算属性
  const tasks = computed(() => sortTasks(rawTasks.value))
  const completedTasks = computed(() => tasks.value.filter(task => task.completed))
  const pendingTasks = computed(() => tasks.value.filter(task => !task.completed))
  const tasksByCategory = computed(() => {
    const grouped = {}
    tasks.value.forEach(task => {
      const categoryId = task.categoryId || 'uncategorized'
      if (!grouped[categoryId]) {
        grouped[categoryId] = []
      }
      grouped[categoryId].push(task)
    })
    return grouped
  })

  // Actions


  // Actions
  const fetchTasks = async (params = {}, append = false) => {
    try {
      const response = await taskApi.fetchTasks({
        page: params.page || currentPage.value,
        pageSize: pageSize.value,
        ...params
      })

      if (append) {
        rawTasks.value = [... rawTasks.value, ...response.results]
      } else {
        rawTasks.value = response.results
      }

      totalCount.value = response.count
      hasMore.value = !!response.next
      currentPage.value = params.page || currentPage.value

      return response
    } catch (error) {
      addErrorLog(error, { action: 'fetchTasks', params })
      throw error
    }
  }

  // 重置分页状态
  const resetPagination = () => {
    currentPage.value = 1
    hasMore.value = true
    rawTasks.value = []
  }

  const getTaskDetail = async (taskId) => {
    loading.value = true
    try {
      const response = await taskApi.getTaskDetail(taskId)
      return response
    } catch (error) {
      addErrorLog(error, { action: 'getTaskDetail', taskId })
      throw error
    } finally {
      loading.value = false
    }
  }

  const createTask = async (taskData) => {
    loading.value = true
    try {
      const response = await taskApi.createTask(taskData)
      rawTasks.value.push(response)
      // 清除相关缓存
      cache.remove('tasks:{}')
      return response
    } catch (error) {
      addErrorLog(error, { action: 'createTask', taskData })
      throw error
    } finally {
      loading.value = false
    }
  }

  const updateTask = async (taskId, taskData) => {
    loading.value = true
    try {
      // 先获取任务详情确保存在
      const task = rawTasks.value.find(t => t.id === taskId)
      if (!task) {
        // 如果本地没有找到,尝试从服务器获取
        await fetchTasks()
      }
      
      const response = await taskApi.updateTask(taskId, taskData)
      
      // 更新本地状态
      const index = rawTasks.value.findIndex(t => t.id === taskId)
      if (index !== -1) {
        rawTasks.value[index] = { ...rawTasks.value[index], ...response }
      } else {
        // 如果任务不在列表中,添加到列表
        rawTasks.value.push(response)
      }
      
      // 清除缓存
      cache.remove('tasks:{}')
      return response
    } catch (error) {
      addErrorLog(error, { action: 'updateTask', taskId, taskData })
      throw error
    } finally {
      loading.value = false
    }
  }

  const deleteTask = async (taskId) => {
    loading.value = true
    try {
      await taskApi.deleteTask(taskId)
      rawTasks.value = rawTasks.value.filter(t => t.id !== taskId)
      // 清除相关缓存
      cache.remove('tasks:{}')
    } catch (error) {
      addErrorLog(error, { action: 'deleteTask', taskId })
      throw error
    } finally {
      loading.value = false
    }
  }

  const batchUpdateTasks = async (taskIds, updateData) => {
    loading.value = true
    try {
      const response = await taskApi.batchUpdateTasks(taskIds, updateData)
      // 更新本地状态
      response.forEach(updatedTask => {
        const index = rawTasks.value.findIndex(t => t.id === updatedTask.id)
        if (index !== -1) {
          rawTasks.value[index] = updatedTask
        }
      })
      // 清除相关缓存
      cache.remove('tasks:{}')
      return response
    } catch (error) {
      addErrorLog(error, { action: 'batchUpdateTasks', taskIds, updateData })
      throw error
    } finally {
      loading.value = false
    }
  }

  // Reset store
  const reset = () => {
    rawTasks.value = []
    loading.value = false
  }

  // 添加评论
  const addComment = async ({ task_pk, content }) => {
    try {
      const response = await taskApi.addComment(task_pk, { content })
      comments.value.unshift(response)
      return response
    } catch (error) {
      throw new Error(error.message || '添加评论失败')
    }
  }

  // 获取评论列表
  const getTaskComments = async (taskId, params = {}, append = false) => {
    try {
      const response = await taskApi.getTaskComments(taskId, {
        page: params.page || commentPage.value,
        ...params
      })
      
      if (append) {
        comments.value = [...comments.value, ...response.results]
      } else {
        comments.value = [...response.results]
      }
      
      hasMoreComments.value = !!response.next
      commentPage.value = params.page || commentPage.value
      
      return response
    } catch (error) {
      throw error
    }
  }

  // 获取日历视图任务
  const fetchCalendarTasks = async (params) => {
    loading.value = true
    try {
      const response = await taskApi.getCalendarTasks(params)
      // 使用专门的状态存储日历任务
      calendarTasks.value = response
      return response
    } catch (error) {
      addErrorLog(error, { action: 'fetchCalendarTasks', params })
      throw error
    } finally {
      loading.value = false
    }
  }

  // 更新任务日期
  const updateTaskDate = async (taskId, date) => {
    loading.value = true
    try {
      const response = await taskApi.updateTaskDate(taskId, date)
      // 更新日历任务状态
      const index = calendarTasks.value.findIndex(t => t.id === taskId)
      if (index !== -1) {
        calendarTasks.value[index] = { ...calendarTasks.value[index], due_date: date }
      }
      return response
    } catch (error) {
      addErrorLog(error, { action: 'updateTaskDate', taskId, date })
      throw error
    } finally {
      loading.value = false
    }
  }

  // 快速创建任务
  const quickCreateTask = async (taskData) => {
    loading.value = true
    try {
      const response = await taskApi.quickCreateTask(taskData)
      // 添加到日历任务列表
      calendarTasks.value.push(response)
      return response
    } catch (error) {
      addErrorLog(error, { action: 'quickCreateTask', taskData })
      throw error
    } finally {
      loading.value = false
    }
  }

  // 添加统计相关的状态
  const monthStats = ref({
    total: 0,
    completed: 0,
    pending: 0,
    overdue: 0
  })
  const categoryStats = ref([])
  const dailyTrend = ref([])

  // 获取月度统计数据
  const fetchMonthStats = async (month) => {
    loading.value = true
    try {
      const response = await taskApi.getMonthStats(month)
      monthStats.value = response
      return response
    } catch (error) {
      addErrorLog(error, { action: 'fetchMonthStats', params: { month } })
      throw error
    } finally {
      loading.value = false
    }
  }

  // 获取分类统计数据
  const fetchCategoryStats = async (month) => {
    loading.value = true
    try {
      const response = await taskApi.getCategoryStats(month)
      categoryStats.value = response
      return response
    } catch (error) {
      addErrorLog(error, { action: 'fetchCategoryStats', params: { month } })
      throw error
    } finally {
      loading.value = false
    }
  }

  // 获取每日完成趋势
  const fetchDailyTrend = async (month) => {
    loading.value = true
    try {
      const response = await taskApi.getDailyTrend(month)
      dailyTrend.value = response
      return response
    } catch (error) {
      addErrorLog(error, { action: 'fetchDailyTrend', params: { month } })
      throw error
    } finally {
      loading.value = false
    }
  }

  // 获取优先级统计数据
  const fetchPriorityStats = async (month) => {
    try {
      const response = await taskApi.getPriorityStats(month)
      priorityStats.value = response
      return response
    } catch (error) {
      console.error('获取优先级统计失败:', error)
      throw error
    }
  }

  return {
    // State
    tasks,
    loading,
    hasMore,
    currentPage,
    priorityStats,
    // Getters
    completedTasks,
    pendingTasks,
    tasksByCategory,
    
    // Actions
    fetchTasks,
    getTaskDetail,
    createTask,
    updateTask,
    deleteTask,
    batchUpdateTasks,
    reset,
    resetPagination,
    addComment,
    comments,
    hasMoreComments,
    commentPage,
    getTaskComments,
    fetchCalendarTasks,
    updateTaskDate,
    quickCreateTask,
    calendarTasks,
    monthStats,
    categoryStats,
    dailyTrend,
    fetchMonthStats,
    fetchCategoryStats,
    fetchDailyTrend,
    fetchPriorityStats
  }
})
