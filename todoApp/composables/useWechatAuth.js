import { ref } from 'vue'
import { useAuthStore } from '../store/modules/auth'

export function useWechatAuth() {
  const loading = ref(false)
  const error = ref('')
  const authStore = useAuthStore()

  const wechatLogin = async () => {
    loading.value = true
    error.value = ''

    try {
      // 调用微信登录
      const [loginError, loginRes] = await uni.login({
        provider: 'weixin'
      })

      if (loginError) {
        throw loginError
      }

      // 调用 store 的微信登录方法
      const success = await authStore.wechatLogin(loginRes.code)
      
      if (!success) {
        throw new Error('登录失败')
      }

      return true
    } catch (err) {
      console.error('微信登录失败:', err)
      error.value = '微信登录失败，请重试'
      return false
    } finally {
      loading.value = false
    }
  }

  return {
    loading,
    error,
    wechatLogin
  }
}
