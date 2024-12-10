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

  const categories = computed(() => taskStore.categories)
  const tags = computed(() => taskStore.tags)

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
  const fetchTasks = async (filters = {}) => {
    try {
      loading.value = true
      clearError()
      await taskStore.fetchTasks(filters)
    } catch (e) {
      error.value = e.message || '获取任务列表失败'
    } finally {
      loading.value = false
    }
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

  // 获取分类列表
  const fetchCategories = async () => {
    try {
      loading.value = true
      clearError()
      await taskStore.fetchCategories()
    } catch (e) {
      error.value = e.message || '获取分类列表失败'
    } finally {
      loading.value = false
    }
  }

  // 创建分类
  const createCategory = async (categoryData) => {
    try {
      loading.value = true
      clearError()
      const category = await taskStore.createCategory(categoryData)
      return category
    } catch (e) {
      error.value = e.message || '创建分类失败'
      return null
    } finally {
      loading.value = false
    }
  }

  // 更新分类
  const updateCategory = async (categoryId, categoryData) => {
    try {
      loading.value = true
      clearError()
      const category = await taskStore.updateCategory(categoryId, categoryData)
      return category
    } catch (e) {
      error.value = e.message || '更新分类失败'
      return null
    } finally {
      loading.value = false
    }
  }

  // 删除分类
  const deleteCategory = async (categoryId) => {
    try {
      loading.value = true
      clearError()
      await taskStore.deleteCategory(categoryId)
      return true
    } catch (e) {
      error.value = e.message || '删除分类失败'
      return false
    } finally {
      loading.value = false
    }
  }

  // 获取标签列表
  const fetchTags = async () => {
    try {
      loading.value = true
      clearError()
      await taskStore.fetchTags()
    } catch (e) {
      error.value = e.message || '获取标签列表失败'
    } finally {
      loading.value = false
    }
  }

  // 创建标签
  const createTag = async (tagData) => {
    try {
      loading.value = true
      clearError()
      const tag = await taskStore.createTag(tagData)
      return tag
    } catch (e) {
      error.value = e.message || '创建标签失败'
      return null
    } finally {
      loading.value = false
    }
  }

  // 更新标签
  const updateTag = async (tagId, tagData) => {
    try {
      loading.value = true
      clearError()
      const tag = await taskStore.updateTag(tagId, tagData)
      return tag
    } catch (e) {
      error.value = e.message || '更新标签失败'
      return null
    } finally {
      loading.value = false
    }
  }

  // 删除标签
  const deleteTag = async (tagId) => {
    try {
      loading.value = true
      clearError()
      await taskStore.deleteTag(tagId)
      return true
    } catch (e) {
      error.value = e.message || '删除标签失败'
      return false
    } finally {
      loading.value = false
    }
  }

  return {
    // 状态
    loading,
    error,
    tasks,
    categories,
    tags,

    // 任务相关方法
    fetchTasks,
    createTask,
    updateTask,
    deleteTask,
    batchUpdateTasks,

    // 分类相关方法
    fetchCategories,
    createCategory,
    updateCategory,
    deleteCategory,

    // 标签相关方法
    fetchTags,
    createTag,
    updateTag,
    deleteTag,

    // 工具方法
    clearError,
    formatDate,
    getPriorityText
  }
}
