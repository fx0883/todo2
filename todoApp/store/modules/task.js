import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import { useCache } from '@/composables/useCache'
import { useErrorLog } from '@/composables/useErrorLog'
import { taskApi } from '@/api'

export const useTaskStore = defineStore('task', () => {
  // 使用 composables
  const cache = useCache()
  const { addErrorLog } = useErrorLog()

  // 状态
  const tasks = ref([])
  const loading = ref(false)
  const currentPage = ref(1)
  const totalCount = ref(0)
  const hasMore = ref(true)
  const pageSize = ref(10)

  // Actions
  const fetchTasks = async (params = {}, append = false) => {
    try {
      const response = await taskApi.fetchTasks({
        page: params.page || currentPage.value,
        pageSize: pageSize.value,
        ...params
      })
      
      if (append) {
        tasks.value = [...tasks.value, ...response.results]
      } else {
        tasks.value = response.results
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
    tasks.value = []
  }

  return {
    // State
    tasks,
    loading,
    currentPage,
    totalCount,
    hasMore,
    pageSize,
    
    // Actions
    fetchTasks,
    resetPagination,
  }
})
