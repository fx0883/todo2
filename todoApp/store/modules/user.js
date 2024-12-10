import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import { userApi } from '@/api'

export const useUserStore = defineStore('user', () => {
  // 状态
  const token = ref('')
  const userInfo = ref(null)
  const loading = ref(false)
  const error = ref(null)

  // Getters
  const isAuthenticated = computed(() => !!token.value)

  // Actions
  const setToken = (accessToken, refreshToken) => {
    token.value = accessToken
    uni.setStorageSync('accessToken', accessToken)
    if (refreshToken) {
      uni.setStorageSync('refreshToken', refreshToken)
    }
  }

  const setUserInfo = (info) => {
    userInfo.value = info
    uni.setStorageSync('userInfo', info)
  }

  const setError = (message) => {
    error.value = message
  }

  const clearError = () => {
    error.value = null
  }

  const login = async (credentials) => {
    try {
      const response = await userApi.login(credentials)
      return response
    } catch (err) {
      throw new Error(err.data?.message || '登录失败')
    }
  }

  const register = async (userData) => {
    try {
      const response = await userApi.register(userData)
      return response
    } catch (err) {
      throw new Error(err.data?.message || '注册失败')
    }
  }

  const requestPasswordReset = async (data) => {
    try {
      await userApi.requestPasswordReset(data)
    } catch (err) {
      throw new Error(err.data?.message || '请求密码重置失败')
    }
  }

  const confirmPasswordReset = async (data) => {
    try {
      await userApi.confirmPasswordReset(data)
    } catch (err) {
      throw new Error(err.data?.message || '密码重置失败')
    }
  }

  const refreshToken = async () => {
    try {
      const refreshToken = uni.getStorageSync('refreshToken')
      if (!refreshToken) {
        throw new Error('No refresh token available')
      }
      const response = await userApi.refreshToken(refreshToken)
      setToken(response.access, response.refresh)
      return response.access
    } catch (err) {
      throw new Error(err.data?.message || 'Token 刷新失败')
    }
  }

  const fetchUserInfo = async () => {
    try {
      const response = await userApi.getUserInfo()
      setUserInfo(response)
      return response
    } catch (err) {
      throw new Error(err.data?.message || '获取用户信息失败')
    }
  }

  const logout = () => {
    token.value = ''
    userInfo.value = null
    error.value = null
    uni.removeStorageSync('accessToken')
    uni.removeStorageSync('refreshToken')
    uni.removeStorageSync('userInfo')
  }

  const initFromStorage = () => {
    const storedToken = uni.getStorageSync('accessToken')
    const storedUserInfo = uni.getStorageSync('userInfo')
    if (storedToken) token.value = storedToken
    if (storedUserInfo) userInfo.value = storedUserInfo
  }

  return {
    // 状态
    token,
    userInfo,
    loading,
    error,
    isAuthenticated,

    // Actions
    login,
    register,
    logout,
    setToken,
    setUserInfo,
    initFromStorage,
    fetchUserInfo,
    refreshToken,
    requestPasswordReset,
    confirmPasswordReset
  }
})
