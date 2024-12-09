// 配置接口地址
const BASE_URL = 'http://localhost:8000/api/v1'

// 刷新token
const refreshToken = async () => {
  try {
    const refreshToken = uni.getStorageSync('refreshToken')
    if (!refreshToken) {
      throw new Error('No refresh token')
    }

    const response = await uni.request({
      url: `${BASE_URL}/accounts/users/refresh/`,
      method: 'POST',
      data: {
        refresh: refreshToken
      }
    })

    if (response.statusCode === 200) {
      const { access } = response.data
      uni.setStorageSync('token', access)
      return access
    } else {
      throw new Error('Failed to refresh token')
    }
  } catch (error) {
    throw error
  }
}

// 请求封装
const request = async (options) => {
  try {
    let token = uni.getStorageSync('token')
    const header = {
      'Content-Type': 'application/json'
    }
    
    // 如果有token，添加到header
    if (token) {
      header.Authorization = `Bearer ${token}`
    }

    const response = await uni.request({
      url: BASE_URL + options.url,
      method: options.method || 'GET',
      data: options.data,
      header
    })

    if (response.statusCode === 200 || response.statusCode === 201) {
      return response.data
    } 
    
    // token过期
    if (response.statusCode === 401) {
      try {
        // 尝试刷新token
        token = await refreshToken()
        
        // 使用新token重试请求
        header.Authorization = `Bearer ${token}`
        const retryResponse = await uni.request({
          url: BASE_URL + options.url,
          method: options.method || 'GET',
          data: options.data,
          header
        })

        if (retryResponse.statusCode === 200 || retryResponse.statusCode === 201) {
          return retryResponse.data
        }
        
        throw new Error('Request failed after token refresh')
      } catch (error) {
        // 刷新token失败，清除本地存储并跳转到登录页
        uni.removeStorageSync('token')
        uni.removeStorageSync('refreshToken')
        uni.removeStorageSync('userInfo')
        uni.showToast({
          title: '请重新登录',
          icon: 'none'
        })
        uni.reLaunch({
          url: '/pages/login/index'
        })
        throw error
      }
    }
    
    // 其他错误
    uni.showToast({
      title: response.data.error || '请求失败',
      icon: 'none'
    })
    throw new Error(response.data.error || '请求失败')
  } catch (error) {
    uni.showToast({
      title: error.message || '网络错误',
      icon: 'none'
    })
    throw error
  }
}

export default request
