import { defineStore } from 'pinia'
import { ref } from 'vue'

export const useAuthStore = defineStore('auth', () => {
  const user = ref(null)
  const token = ref(null)
  const loading = ref(false)
  const error = ref(null)

  // 微信登录
  const wechatLogin = async (code) => {
    loading.value = true
    error.value = null

    try {
      // TODO: 调用后端接口进行微信登录验证
      // const response = await api.post('/auth/wechat-login', { code })
      
      // 模拟登录成功
      user.value = {
        id: 'wx_' + Date.now(),
        nickname: '微信用户',
        avatar: ''
      }
      token.value = 'mock_token_' + Date.now()

      // 保存登录状态
      uni.setStorageSync('user', user.value)
      uni.setStorageSync('token', token.value)

      return true
    } catch (err) {
      console.error('微信登录失败:', err)
      error.value = '登录失败，请重试'
      return false
    } finally {
      loading.value = false
    }
  }

  // 检查登录状态
  const checkAuth = () => {
    const savedUser = uni.getStorageSync('user')
    const savedToken = uni.getStorageSync('token')

    if (savedUser && savedToken) {
      user.value = savedUser
      token.value = savedToken
      return true
    }
    return false
  }

  // 退出登录
  const logout = () => {
    user.value = null
    token.value = null
    uni.removeStorageSync('user')
    uni.removeStorageSync('token')
  }

  return {
    user,
    token,
    loading,
    error,
    wechatLogin,
    checkAuth,
    logout
  }
})
