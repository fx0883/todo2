import { ref, computed } from 'vue'
import { useTaskStore } from '@/store/modules/task'
import { usePreferences } from './usePreferences'

export function useTask() {
  const taskStore = useTaskStore()
  const { preferences } = usePreferences()
  const loading = ref(false)
  const error = ref(null)

  // 计算属性
  const tasks = computed(() => {
    const allTasks = taskStore.tasks
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

  // 日期格式化
  const formatDate = (date) => {
    if (!date) return ''
    const taskDate = new Date(date)
    const today = new Date()
    const tomorrow = new Date(today)
    tomorrow.setDate(tomorrow.getDate() + 1)

    // 重置时间部分以便比较日期
    today.setHours(0, 0, 0, 0)
    tomorrow.setHours(0, 0, 0, 0)
    taskDate.setHours(0, 0, 0, 0)

    if (taskDate.getTime() === today.getTime()) {
      return '今天'
    }
    if (taskDate.getTime() === tomorrow.getTime()) {
      return '明天'
    }

    return taskDate.toLocaleDateString('zh-CN', {
      year: 'numeric',
      month: '2-digit',
      day: '2-digit'
    })
  }

  // 获取优先级文本
  const getPriorityText = (priority) => {
    const priorityMap = {
      1: '低',
      2: '中',
      3: '高'
    }
    return priorityMap[priority] || '无'
  }

  // 清除错误
  const clearError = () => {
    error.value = null
  }

  // 获取任务列表
  const fetchTasks = async (params = {}, append = false) => {
    try {
      loading.value = true
      error.value = null
      return await taskStore.fetchTasks(params, append)
    } catch (err) {
      if (err.statusCode !== 401) {
        error.value = err
      }
      throw err
    } finally {
      loading.value = false
    }
  }

  // 加载更多
  const loadMore = async () => {
    if (!taskStore.hasMore || loading.value) return
    
    await fetchTasks({
      page: taskStore.currentPage + 1
    }, true)
  }

  // 刷新列表
  const refreshList = async () => {
    taskStore.resetPagination()
    await fetchTasks()
  }

  // 创建任务
  const createTask = async (taskData) => {
    try {
      loading.value = true
      clearError()
      const task = await taskStore.createTask(taskData)
      return task
    } catch (e) {
      error.value = e.message || '创建任务失败'
      return null
    } finally {
      loading.value = false
    }
  }

  // 更新任务
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

  // 删除任务
  const deleteTask = async (taskId) => {
    try {
      loading.value = true
      clearError()
      await taskStore.deleteTask(taskId)
      return true
    } catch (e) {
      error.value = e.message || '删除任务失败'
      return false
    } finally {
      loading.value = false
    }
  }

  // 批量操作任务
  const batchUpdateTasks = async (taskIds, updateData) => {
    try {
      loading.value = true
      clearError()
      await taskStore.batchUpdateTasks(taskIds, updateData)
      return true
    } catch (e) {
      error.value = e.message || '批量更新任务失败'
      return false
    } finally {
      loading.value = false
    }
  }

  // 获取任务统计信息
  const fetchTaskStats = async () => {
    try {
      loading.value = true
      clearError()
      const stats = await taskStore.getTaskStats()
      return stats
    } catch (e) {
      error.value = e.message || '获取任务统计信息失败'
      return null
    } finally {
      loading.value = false
    }
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

  // 获取任务详情
  const getTaskDetail = async (taskId) => {
    try {
      loading.value = true
      clearError()
      const task = await taskStore.getTaskDetail(taskId)
      return task
    } catch (e) {
      error.value = e.message || '获取任务详情失败'
      throw e
    } finally {
      loading.value = false
    }
  }

  // 获取任务评论
  const getTaskComments = async (taskId) => {
    try {
      loading.value = true
      clearError()
      const comments = await taskStore.getTaskComments(taskId)
      return comments
    } catch (e) {
      error.value = e.message || '获取任务评论失败'
      throw e
    } finally {
      loading.value = false
    }
  }

  // 添加评论
  const addComment = async (commentData) => {
    try {
      loading.value = true
      clearError()
      const comment = await taskStore.addComment(commentData)
      uni.showToast({
        title: '评论成功',
        icon: 'success'
      })
      return comment
    } catch (e) {
      error.value = e.message || '添加评论失败'
      throw e
    } finally {
      loading.value = false
    }
  }

  // 加载更多评论
  const loadMoreComments = async (taskId) => {
    if (!taskStore.hasMoreComments || loading.value) return
    
    try {
      await taskStore.getTaskComments(taskId, {
        page: taskStore.commentPage + 1
      }, true)
    } catch (e) {
      error.value = e.message || '加载更多评论失败'
      throw e
    }
  }

  return {
    // 状态
    loading,
    error,
    
    // 计算属性
    tasks,
    
    // 工具函数
    formatDate,
    getPriorityText,
    
    // 任务相关方法
    fetchTasks,
    createTask,
    updateTask,
    deleteTask,
    batchUpdateTasks,
    fetchTaskStats,
    getTaskDetail,
    getTaskComments,
    addComment,
    
    // 添加到返回对象中
    toggleTaskStatus,
    loadMore,
    refreshList,
    hasMore: computed(() => taskStore.hasMore),
    currentPage: computed(() => taskStore.currentPage),
    loadMoreComments,
    comments: computed(() => taskStore.comments),
    hasMoreComments: computed(() => taskStore.hasMoreComments),
  }
}
