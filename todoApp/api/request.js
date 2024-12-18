// 配置接口地址
// const BASE_URL = 'http://127.0.0.1:8000/api/v1'
const BASE_URL = 'http://192.168.31.143:8000/api/v1'
// 请求队列，用于存储等待 token 刷新的请求
let refreshing = false
const waitingQueue = []

// 请求计数器，用于取消重复请求
const pendingRequests = new Map()

// 生成请求的唯一键
const generateRequestKey = (config) => {
  const { url, method, data } = config
  return [url, method, JSON.stringify(data)].join('&')
}

// 移除请求
const removePendingRequest = (config) => {
  const requestKey = generateRequestKey(config)
  pendingRequests.delete(requestKey)
}

// 添加请求
const addPendingRequest = (config) => {
  const requestKey = generateRequestKey(config)
  pendingRequests.set(requestKey, config)
}

// 刷新 token
const refreshToken = async () => {
  try {
    const refreshToken = uni.getStorageSync('refreshToken')
    if (!refreshToken) {
      throw new Error('No refresh token')
    }

    const response = await uni.request({
      url: `${BASE_URL}/token/refresh/`,
      method: 'POST',
      data: {
        refresh: refreshToken
      }
    })

    if (response.statusCode === 200) {
      const { access,refresh } = response.data
      uni.setStorageSync('accessToken', access)
	  uni.setStorageSync('refreshToken', refresh)
      return access
    } else {
      throw new Error('Failed to refresh token')
    }
  } catch (error) {
    // 刷新失败，清除所有 token
    uni.removeStorageSync('accessToken')
    uni.removeStorageSync('refreshToken')
    throw error
  }
}

// 处理请求队列
const processQueue = (error = null) => {
  waitingQueue.forEach((promise) => {
    if (error) {
      promise.reject(error)
    } else {
      promise.resolve()
    }
  })
  waitingQueue.length = 0
}

// 添加请求到队列
const addToQueue = (options) => {
  return new Promise((resolve, reject) => {
    waitingQueue.push({ resolve, reject, options })
  })
}

// 错误处理
const handleError = (error) => {
  // 网络错误
  if (!error.statusCode) {
    const message = '网络连接失败'
    uni.showToast({
      title: message,
      icon: 'none'
    })
    return Promise.reject(new Error(message))
  }

  // HTTP 错误
  let message = ''
  if (error.statusCode === 400) {
    // 如果后端返回了 error_message，直接使用
    if (error.data?.error_message) {
      message = error.data.error_message
    }
    // 否则尝试获取其他错误信息
    else if (error.data) {
      const details = error.data
      // 如果是对象，获取第一个错误消息
      if (typeof details === 'object' && !Array.isArray(details)) {
        const firstError = Object.values(details)[0]
        if (Array.isArray(firstError)) {
          message = firstError[0]
        } else {
          message = firstError
        }
      } else {
        message = error.data?.detail || error.data?.message || '请求参数错误'
      }
    }
  } else {
    switch (error.statusCode) {
      case 401:
        // 401 错误已在请求拦截器中处理
        break
      case 403:
        message = '没有权限进行此操作'
        break
      case 404:
        message = '请求的资源不存在'
        break
      case 500:
        message = '服务器内部错误'
        break
      default:
        message = error.data?.detail || error.data?.message || '请求失败'
    }
  }

  if (message) {
    uni.showToast({
      title: message,
      icon: 'none'
    })
  }

  error.message = message
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
    url: BASE_URL + options.url,
    header: {
      'Content-Type': 'application/json',
      ...options.header
    }
  }

  

  try {
    // 添加 token
    const token = uni.getStorageSync('accessToken')
    if (token) {
      config.header = {
        ...config.header,
        'Authorization': `Bearer ${token}`
      }
    }
	console.log(config.url);
	console.dir(config, {depth: null});
    // 发送请求
    return new Promise((resolve, reject) => {
      uni.request({
        ...config,
        success: (res) => {
          if (res.statusCode >= 200 && res.statusCode < 300) {
            resolve(res.data)
          } else if (res.statusCode === 401 && !refreshing) {
            refreshing = true
            refreshToken()
              .then(() => {
                refreshing = false
                processQueue()
                // 重新发送请求
                return request(options)
              })
              .then(resolve)
              .catch(err => {
                refreshing = false
                processQueue(err)
                // 刷新token失败，清除用户状态并跳转到登录页
                uni.removeStorageSync('accessToken')
                uni.removeStorageSync('refreshToken')
                uni.removeStorageSync('userInfo')

                reject(err)
              })
          } else {
            reject({
              statusCode: res.statusCode,
              data: res.data
            })
          }
        },
        fail: (err) => {
			console.log(err)
          reject({
            statusCode: 0,
            data: { message: '网络请求失败' },
            error: err
          })
        }
      })
    })
  } catch (error) {
    return Promise.reject(error)
  }
}

// 添加文件上传方法
const uploadFile = (options) => {
  const token = uni.getStorageSync('accessToken')
  
  return new Promise((resolve, reject) => {
    uni.uploadFile({
      url: BASE_URL + options.url,
      filePath: options.filePath,
      name: options.name,
      header: {
        'Authorization': token ? `Bearer ${token}` : ''
      },
      success: (res) => {
        if (res.statusCode === 401) {
          // Token 过期处理逻辑
          handleTokenExpired(() => uploadFile(options))
            .then(resolve)
            .catch(reject)
          return
        }
        resolve(res)
      },
      fail: (err) => {
        reject({
          statusCode: 0,
          data: { message: '上传失败' },
          error: err
        })
      }
    })
  })
}

export {
  request,
  uploadFile  // 导出上传方法
}
