import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import { useCache } from '@/composables/useCache'
import { useErrorLog } from '@/composables/useErrorLog'
import { categoryApi, taskApi } from '@/api'

export const useTaskStore = defineStore('task', () => {
  // 使用 composables
  const cache = useCache()
  const { addErrorLog } = useErrorLog()

  // 状态
  const tasks = ref([])
  const categories = ref([])
  const tags = ref([])
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

  // Categories
  const getCategories = async () => {
    const cachedCategories = cache.get('categories')
    if (cachedCategories) {
      categories.value = cachedCategories
      return cachedCategories
    }

    loading.value = true
    try {
      const response = await categoryApi.getCategories()
      categories.value = response.results
      cache.set('categories', response, 30 * 60 * 1000) // 缓存30分钟
      return response
    } catch (error) {
      addErrorLog(error, { action: 'getCategories' })
      throw error
    } finally {
      loading.value = false
    }
  }

  const createCategory = async (categoryData) => {
    loading.value = true
    try {
      const response = await taskApi.createCategory(categoryData)
      categories.value.push(response)
      return response
    } catch (error) {
      addErrorLog(error, { action: 'createCategory', categoryData })
      throw error
    } finally {
      loading.value = false
    }
  }

  const updateCategory = async (categoryId, categoryData) => {
    loading.value = true
    try {
      const response = await taskApi.updateCategory(categoryId, categoryData)
      const index = categories.value.findIndex(category => category.id === categoryId)
      if (index !== -1) {
        categories.value[index] = response
      }
      return response
    } catch (error) {
      addErrorLog(error, { action: 'updateCategory', categoryId, categoryData })
      throw error
    } finally {
      loading.value = false
    }
  }

  const deleteCategory = async (categoryId) => {
    loading.value = true
    try {
      await taskApi.deleteCategory(categoryId)
      categories.value = categories.value.filter(category => category.id !== categoryId)
    } catch (error) {
      addErrorLog(error, { action: 'deleteCategory', categoryId })
      throw error
    } finally {
      loading.value = false
    }
  }

  // Tags
  const getTags = async () => {
    const cachedTags = cache.get('tags')
    if (cachedTags) {
      tags.value = cachedTags
      return cachedTags
    }

    loading.value = true
    try {
      const response = await taskApi.getTags()
      tags.value = response
      cache.set('tags', response, 30 * 60 * 1000) // 缓存30分钟
      return response
    } catch (error) {
      addErrorLog(error, { action: 'getTags' })
      throw error
    } finally {
      loading.value = false
    }
  }

  const createTag = async (tagData) => {
    loading.value = true
    try {
      const response = await taskApi.createTag(tagData)
      tags.value.push(response)
      return response
    } catch (error) {
      addErrorLog(error, { action: 'createTag', tagData })
      throw error
    } finally {
      loading.value = false
    }
  }

  const updateTag = async (tagId, tagData) => {
    loading.value = true
    try {
      const response = await taskApi.updateTag(tagId, tagData)
      const index = tags.value.findIndex(tag => tag.id === tagId)
      if (index !== -1) {
        tags.value[index] = response
      }
      return response
    } catch (error) {
      addErrorLog(error, { action: 'updateTag', tagId, tagData })
      throw error
    } finally {
      loading.value = false
    }
  }

  const deleteTag = async (tagId) => {
    loading.value = true
    try {
      await taskApi.deleteTag(tagId)
      tags.value = tags.value.filter(tag => tag.id !== tagId)
    } catch (error) {
      addErrorLog(error, { action: 'deleteTag', tagId })
      throw error
    } finally {
      loading.value = false
    }
  }

  // Reset store
  const reset = () => {
    tasks.value = []
    categories.value = []
    tags.value = []
    cache.clear()
  }

  return {
    // State
    tasks,
    categories,
    tags,
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
    getCategories,
    createCategory,
    updateCategory,
    deleteCategory,
    getTags,
    createTag,
    updateTag,
    deleteTag,
    reset
  }
})
