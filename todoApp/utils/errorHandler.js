// 错误类型枚举
export const ErrorType = {
  NETWORK: 'NETWORK',
  API: 'API',
  VALIDATION: 'VALIDATION',
  UNKNOWN: 'UNKNOWN'
}

// 错误级别枚举
export const ErrorLevel = {
  INFO: 'INFO',
  WARNING: 'WARNING',
  ERROR: 'ERROR',
  FATAL: 'ERROR'
}

export const errorHandler = {
  handle(error) {
    // 401 错误不需要全局处理
    if (error.statusCode === 401) {
      return
    }

    console.error('[Error Handler]:', {
      error,
      type: error.type || 'UNKNOWN',
      level: 'ERROR'
    })
  }
}

// 设置全局错误处理
export function setupGlobalErrorHandling() {
  // 处理 Promise 未捕获的错误
  if (typeof uni !== 'undefined') {
    uni.onError((err) => {
      errorHandler.handle(err)
    })

    // 处理未捕获的 Promise 错误
    uni.onUnhandledRejection((res) => {
      errorHandler.handle(res.reason)
    })
  }

  // Vue 应用级错误处理
  const app = getApp()
  if (app && app.$vm) {
    app.$vm.config.errorHandler = (err, vm, info) => {
      errorHandler.handle(err)
    }
  }
}
