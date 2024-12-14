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


  // 状态
  const loading = ref(false)
  const currentPage = ref(1)
  const totalCount = ref(0)
  const hasMore = ref(true)
  const pageSize = ref(10)

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

  return {
    // State
    tasks,
    loading,
    hasMore,
	currentPage,
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
  }
})
