import { defineStore } from 'pinia'
import { ref } from 'vue'

export const useTaskStore = defineStore('task', () => {
  const tasks = ref([])
  const categories = ref([])
  const tags = ref([])

  const setTasks = (newTasks) => {
    tasks.value = newTasks
  }

  const setCategories = (newCategories) => {
    categories.value = newCategories
  }

  const setTags = (newTags) => {
    tags.value = newTags
  }

  const addTask = (task) => {
    tasks.value.push(task)
  }

  const updateTask = (taskId, updatedTask) => {
    const index = tasks.value.findIndex(t => t.id === taskId)
    if (index !== -1) {
      tasks.value[index] = { ...tasks.value[index], ...updatedTask }
    }
  }

  const deleteTask = (taskId) => {
    tasks.value = tasks.value.filter(t => t.id !== taskId)
  }

  return {
    tasks,
    categories,
    tags,
    setTasks,
    setCategories,
    setTags,
    addTask,
    updateTask,
    deleteTask
  }
})
