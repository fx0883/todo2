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

  // 使用其他 store
  const categoryStore = useCategoryStore()
  const tagStore = useTagStore()

  // 状态
  const tasks = ref([])
  const loading = ref(false)

  // 计算属性
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
  const fetchTasks = async (filters = {}) => {
    const cacheKey = `tasks:${JSON.stringify(filters)}`
    const cachedTasks = cache.get(cacheKey)
    
    if (cachedTasks) {
      tasks.value = cachedTasks
      return cachedTasks
    }

    loading.value = true
    try {
      const response = await taskApi.getTasks(filters)
      tasks.value = response.results
      cache.set(cacheKey, response, 5 * 60 * 1000) // 缓存5分钟
      return response
    } catch (error) {
      addErrorLog(error, { action: 'fetchTasks', filters })
      throw error
    } finally {
      loading.value = false
    }
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
      tasks.value.push(response)
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
      const response = await taskApi.updateTask(taskId, taskData)
      const index = tasks.value.findIndex(t => t.id === taskId)
      if (index !== -1) {
        tasks.value[index] = response
      }
      // 清除相关缓存
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
      tasks.value = tasks.value.filter(t => t.id !== taskId)
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
        const index = tasks.value.findIndex(t => t.id === updatedTask.id)
        if (index !== -1) {
          tasks.value[index] = updatedTask
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
    tasks.value = []
    loading.value = false
  }

  return {
    // State
    tasks,
    loading,
    
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
    reset
  }
})
