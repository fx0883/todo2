import { defineStore } from 'pinia'
import { ref } from 'vue'
import { taskApi } from '@/api'

export const useTaskStore = defineStore('task', () => {
  // 确保初始化为空数组
  const tasks = ref([])
  const categories = ref([])
  const loading = ref(false)
  const error = ref(null)

  // 获取任务列表
  const fetchTasks = async () => {
    loading.value = true
    error.value = null
    try {
      const response = await taskApi.getTasks()
      // 确保返回的是数组
      tasks.value = Array.isArray(response.results) ? response.results : []
    } catch (err) {
      error.value = err.message || '获取任务列表失败'
      tasks.value = [] // 错误时重置为空数组
      throw err
    } finally {
      loading.value = false
    }
  }

  // 获取分类列表
  const fetchCategories = async () => {
    try {
      const response = await taskApi.getCategories()
      // 确保返回的是数组
      categories.value = Array.isArray(response.results) ? response.results : []
    } catch (err) {
      error.value = err.message || '获取分类列表失败'
      categories.value = [] // 错误时重置为空数组
      throw err
    }
  }

  // 添加任务
  const addTask = (task) => {
    if (Array.isArray(tasks.value)) {
      tasks.value.unshift(task)
    } else {
      tasks.value = [task]
    }
  }

  // 更新任务
  const updateTask = (updatedTask) => {
    if (!Array.isArray(tasks.value)) {
      tasks.value = []
      return
    }
    const index = tasks.value.findIndex(task => task.id === updatedTask.id)
    if (index !== -1) {
      tasks.value[index] = { ...tasks.value[index], ...updatedTask }
    }
  }

  // 删除任务
  const deleteTask = (taskId) => {
    if (!Array.isArray(tasks.value)) {
      tasks.value = []
      return
    }
    tasks.value = tasks.value.filter(task => task.id !== taskId)
  }

  // 切换任务状态
  const toggleTaskStatus = async (taskId) => {
    if (!Array.isArray(tasks.value)) {
      tasks.value = []
      return
    }
    const task = tasks.value.find(t => t.id === taskId)
    if (!task) return

    const newStatus = task.status === 'completed' ? 'pending' : 'completed'
    try {
      await taskApi.updateTask(taskId, { status: newStatus })
      updateTask({ ...task, status: newStatus })
    } catch (err) {
      error.value = err.message || '更新任务状态失败'
      throw err
    }
  }

  return {
    tasks,
    categories,
    loading,
    error,
    fetchTasks,
    fetchCategories,
    addTask,
    updateTask,
    deleteTask,
    toggleTaskStatus
  }
})
