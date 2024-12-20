import { ref } from 'vue'
import { useAuthStore } from '@/store/modules/auth'

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

      // TODO: 调用后端 API 进行登录验证
      // const response = await authStore.wechatLogin(loginRes.code)
      console.log('微信登录成功，code:', loginRes.code)
      
      // 模拟登录成功
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
