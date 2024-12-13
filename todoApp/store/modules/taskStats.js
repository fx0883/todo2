import { defineStore } from 'pinia'
import { ref } from 'vue'
import { userApi } from '@/api'

export const useTaskStatsStore = defineStore('taskStats', () => {
  // 状态
  const stats = ref({
    total: 0,
    completed: 0,
    pending: 0,
    completion_rate: 0
  })
  const loading = ref(false)
  const error = ref(null)

  // Actions
  const fetchTaskStats = async () => {
    loading.value = true
    error.value = null
    try {
      const response = await userApi.getTaskStats()
      stats.value = response
	  
	  console.dir(stats.value)
    } catch (err) {
      error.value = err.message
      throw err
    } finally {
      loading.value = false
    }
  }

  return {
    // 状态
    stats,
    loading,
    error,

    // Actions
    fetchTaskStats
  }
}) 