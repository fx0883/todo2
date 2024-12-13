import { ref } from 'vue'
import { useUserStore } from '@/store/modules/user'
import { useTaskStatsStore } from '@/store/modules/taskStats'

export function useProfile() {
  const userStore = useUserStore()
  const taskStatsStore = useTaskStatsStore()
  const uploading = ref(false)
  const error = ref(null)

  const uploadAvatar = async (file) => {
    uploading.value = true
    error.value = null
    
    try {
      const result = await userStore.updateAvatar(file)
      uni.showToast({
        title: '上传成功',
        icon: 'success'
      })
    } catch (err) {
      error.value = err.message
      uni.showToast({
        title: '上传失败',
        icon: 'error'
      })
      throw err
    } finally {
      uploading.value = false
    }
  }

  const fetchStats = async () => {
    try {
      await taskStatsStore.fetchTaskStats()
    } catch (err) {
      error.value = err.message
      throw err
    }
  }

  return {
    uploading,
    error,
    uploadAvatar,
    fetchStats,
    taskStats: taskStatsStore.stats,
    taskStatsLoading: taskStatsStore.loading
  }
} 