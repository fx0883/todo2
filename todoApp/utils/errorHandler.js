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

class ErrorHandler {
  constructor() {
    this.listeners = []
  }

  // 添加错误监听器
  addListener(listener) {
    if (typeof listener === 'function') {
      this.listeners.push(listener)
    }
  }

  // 移除错误监听器
  removeListener(listener) {
    const index = this.listeners.indexOf(listener)
    if (index > -1) {
      this.listeners.splice(index, 1)
    }
  }

  // 处理错误
  handleError(error, type = ErrorType.UNKNOWN, level = ErrorLevel.ERROR) {
    console.error('[Error Handler]:', { error, type, level })
    
    // 通知所有监听器
    this.listeners.forEach(listener => {
      try {
        listener(error, type, level)
      } catch (e) {
        console.error('Error in error listener:', e)
      }
    })

    // 如果是致命错误，可以选择重启应用或跳转到错误页面
    if (level === ErrorLevel.FATAL) {
      // 跳转到错误页面或执行其他操作
      uni.showModal({
        title: '错误',
        content: '应用发生严重错误，请重新启动',
        showCancel: false,
        success: () => {
          // 重启应用或返回首页
          uni.reLaunch({
            url: '/pages/index/index'
          })
        }
      })
    }
  }
}

// 创建单例
export const errorHandler = new ErrorHandler()

// 设置全局错误处理
export function setupGlobalErrorHandling() {
  // 处理 Promise 未捕获的错误
  if (typeof uni !== 'undefined') {
    uni.onError((err) => {
      errorHandler.handleError(err, ErrorType.UNKNOWN, ErrorLevel.ERROR)
    })

    // 处理未捕获的 Promise 错误
    uni.onUnhandledRejection((res) => {
      errorHandler.handleError(res.reason, ErrorType.UNKNOWN, ErrorLevel.ERROR)
    })
  }

  // Vue 应用级错误处理
  const app = getApp()
  if (app && app.$vm) {
    app.$vm.config.errorHandler = (err, vm, info) => {
      errorHandler.handleError(err, ErrorType.UNKNOWN, ErrorLevel.ERROR)
    }
  }
}
