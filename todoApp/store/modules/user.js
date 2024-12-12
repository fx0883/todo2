import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import { userApi } from '@/api'

export const useUserStore = defineStore('user', () => {
  // 状态
  const userInfo = ref(null)
  const loading = ref(false)
  const error = ref(null)
  
  userInfo.value = uni.getStorageSync('userInfo')

  // Getters
  const isAuthenticated = computed(() => {
    const hasToken = !!uni.getStorageSync('accessToken')
    return hasToken
  })

  // Actions
  const setToken = (accessToken, refreshToken) => {
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
    userInfo.value = null
    error.value = null
    uni.removeStorageSync('accessToken')
    uni.removeStorageSync('refreshToken')
    uni.removeStorageSync('userInfo')
  }

  const initFromStorage = () => {
    const storedToken = uni.getStorageSync('accessToken')
    const storedUserInfo = uni.getStorageSync('userInfo')
    if (storedUserInfo) userInfo.value = storedUserInfo
  }

  return {
    // 状态
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
