// 配置接口地址
const BASE_URL = 'http://localhost:8000/api/v1'

// 请求计数器，用于取消重复请求
const pendingRequests = new Map()

// 生成请求的唯一键
const generateRequestKey = (config) => {
  const { url, method, data } = config
  return [url, method, JSON.stringify(data)].join('&')
}

// 取消重复请求
const removePendingRequest = (config) => {
  const requestKey = generateRequestKey(config)
  if (pendingRequests.has(requestKey)) {
    const cancel = pendingRequests.get(requestKey)
    cancel()
    pendingRequests.delete(requestKey)
  }
}

// 添加请求到pending中
const addPendingRequest = (config) => {
  const requestKey = generateRequestKey(config)
  config.cancelToken = new Promise((_, reject) => {
    pendingRequests.set(requestKey, () => {
      pendingRequests.delete(requestKey)
      reject(new Error('Request canceled'))
    })
  })
}

// 刷新token
const refreshToken = async () => {
  try {
    const refreshToken = uni.getStorageSync('refreshToken')
    if (!refreshToken) {
      throw new Error('No refresh token')
    }

    const response = await uni.request({
      url: `${BASE_URL}/refresh/`,
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

// 错误处理
const handleError = (error) => {
  // 网络错误
  if (!error.statusCode) {
    uni.showToast({
      title: '网络连接失败',
      icon: 'none'
    })
    return Promise.reject(new Error('Network Error'))
  }

  // HTTP 错误
  switch (error.statusCode) {
    case 400:
      uni.showToast({
        title: error.data?.message || '请求参数错误',
        icon: 'none'
      })
      break
    case 401:
      // 401 错误已在请求拦截器中处理
      break
    case 403:
      uni.showToast({
        title: '没有权限进行此操作',
        icon: 'none'
      })
      break
    case 404:
      uni.showToast({
        title: '请求的资源不存在',
        icon: 'none'
      })
      break
    case 500:
      uni.showToast({
        title: '服务器内部错误',
        icon: 'none'
      })
      break
    default:
      uni.showToast({
        title: error.data?.message || '请求失败',
        icon: 'none'
      })
  }

  return Promise.reject(error)
}

// 请求重试机制
const retry = async (fn, retries = 3, delay = 1000) => {
  try {
    return await fn()
  } catch (error) {
    if (retries === 0) throw error
    await new Promise(resolve => setTimeout(resolve, delay))
    return retry(fn, retries - 1, delay * 2)
  }
}

// 请求封装
const request = async (options) => {
  // 合并默认配置
  const config = {
    ...options,
    url: BASE_URL + options.url
  }

  // 处理重复请求
  removePendingRequest(config)
  addPendingRequest(config)

  try {
    // 添加token
    const token = uni.getStorageSync('token')
    if (token) {
      config.header = {
        ...config.header,
        'Authorization': `Bearer ${token}`
      }
    }

    // 发送请求
    const response = await uni.request(config)

    // 请求完成后，从pending中移除
    removePendingRequest(config)

    // 处理响应
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return response.data
    }

    // 处理401错误（未授权）
    if (response.statusCode === 401) {
      try {
        // 尝试刷新token
        await refreshToken()
        // 重新发送请求
        return await request(options)
      } catch (refreshError) {
        // 刷新token失败，跳转到登录页
        uni.redirectTo({
          url: '/pages/login/index'
        })
        throw new Error('请重新登录')
      }
    }

    // 其他错误
    throw {
      statusCode: response.statusCode,
      data: response.data
    }
  } catch (error) {
    // 请求完成后，从pending中移除
    removePendingRequest(config)

    // 重试机制
    if (options.retry !== false) {
      const shouldRetry = await handleError(error)
      if (shouldRetry) {
        return await retry(() => request(options))
      }
    }

    throw error
  }
}

export default request
