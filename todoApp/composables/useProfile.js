import { ref } from 'vue'
import { useUserStore } from '@/store/modules/user'

export function useProfile() {
  const userStore = useUserStore()
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
      return result
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

  return {
    uploading,
    error,
    uploadAvatar
  }
} 