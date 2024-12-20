import { ref } from 'vue'
import { useUserStore } from '@/stores/user'
import { wechatLogin } from '@/api/user'

export function useWechatLogin() {
  const loading = ref(false)
  const error = ref('')
  const userStore = useUserStore()

  const handleWechatLogin = async () => {
    loading.value = true
    error.value = ''
    
    try {
      // #ifdef MP-WEIXIN
      const { code } = await uni.login({ provider: 'weixin' })
      const res = await wechatLogin(code)
      
      if (res.data) {
        await userStore.setUserInfo(res.data.user)
        await userStore.setToken(res.data.token)
        uni.switchTab({ url: '/pages/index/index' })
      }
      // #endif
    } catch (e) {
      error.value = e.message || '微信登录失败'
    } finally {
      loading.value = false
    }
  }

  return {
    loading,
    error,
    handleWechatLogin
  }
}
