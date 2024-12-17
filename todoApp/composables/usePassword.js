import { ref } from 'vue'
import { usePasswordStore } from '@/store/modules/password'
import { useUserStore } from '@/store/modules/user'

export function usePassword() {
  const passwordStore = usePasswordStore()
  const userStore = useUserStore()
  const isRequesting = ref(false)
  const isConfirming = ref(false)

  const validateEmail = (email) => {
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/
    return emailRegex.test(email)
  }

  const requestPasswordReset = async (email) => {
    // 如果没有传入邮箱，使用用户当前邮箱（用于修改密码场景）
    const targetEmail = email || userStore.userInfo?.email

    if (!targetEmail) {
      uni.showToast({
        title: '请输入邮箱地址',
        icon: 'none',
        duration: 2000
      })
      return false
    }

    if (!validateEmail(targetEmail)) {
      uni.showToast({
        title: '请输入正确的邮箱格式',
        icon: 'none',
        duration: 2000
      })
      return false
    }

    isRequesting.value = true
    try {
      await passwordStore.requestPasswordReset(targetEmail)
      uni.showToast({
        title: '重置邮件已发送',
        icon: 'success'
      })
      return true
    } catch (error) {
      uni.showToast({
        title: error.message || '发送重置邮件失败',
        icon: 'error'
      })
      return false
    } finally {
      isRequesting.value = false
    }
  }

  const confirmPasswordReset = async (data) => {
    isConfirming.value = true
    try {
      await passwordStore.confirmPasswordReset(data)
      uni.showToast({
        title: '密码已重置',
        icon: 'success',
        duration: 1500,
        success: () => {
          // 延迟关闭页面，等待 Toast 显示完成
          setTimeout(() => {
            uni.navigateBack()
          }, 1500)
        }
      })
      return true
    } catch (error) {
      uni.showToast({
        title: error.message || '重置密码失败',
        icon: 'error'
      })
      return false
    } finally {
      isConfirming.value = false
    }
  }

  return {
    requestPasswordReset,
    confirmPasswordReset,
    isRequesting,
    isConfirming,
    error: passwordStore.error
  }
}
