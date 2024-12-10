// 错误类型枚举
export const ErrorType = {
  API: 'API_ERROR',
  NETWORK: 'NETWORK_ERROR',
  VALIDATION: 'VALIDATION_ERROR',
  AUTH: 'AUTH_ERROR',
  UNKNOWN: 'UNKNOWN_ERROR'
}

// 错误级别枚举
export const ErrorLevel = {
  INFO: 'INFO',
  WARNING: 'WARNING',
  ERROR: 'ERROR',
  CRITICAL: 'CRITICAL'
}

class ErrorHandler {
  constructor() {
    this.logs = []
    this.listeners = new Set()
  }

  // 添加错误监听器
  addListener(listener) {
    this.listeners.add(listener)
  }

  // 移除错误监听器
  removeListener(listener) {
    this.listeners.delete(listener)
  }

  // 通知所有监听器
  notifyListeners(error) {
    this.listeners.forEach(listener => listener(error))
  }

  // 处理错误
  handleError(error, type = ErrorType.UNKNOWN, level = ErrorLevel.ERROR) {
    const errorInfo = this.formatError(error, type, level)
    
    // 记录到日志
    this.logs.push(errorInfo)
    
    // 输出到控制台
    this.logToConsole(errorInfo)
    
    // 通知监听器
    this.notifyListeners(errorInfo)
    
    return errorInfo
  }

  // 格式化错误信息
  formatError(error, type, level) {
    const errorInfo = {
      timestamp: new Date().toISOString(),
      type,
      level,
      message: error.message || String(error),
      stack: error.stack,
      metadata: {
        url: window.location.href,
        userAgent: navigator.userAgent
      }
    }

    // 针对不同类型的错误添加额外信息
    switch (type) {
      case ErrorType.API:
        errorInfo.metadata.status = error.status
        errorInfo.metadata.endpoint = error.config?.url
        errorInfo.metadata.method = error.config?.method
        break
      case ErrorType.NETWORK:
        errorInfo.metadata.online = navigator.onLine
        break
      case ErrorType.VALIDATION:
        errorInfo.metadata.field = error.field
        errorInfo.metadata.value = error.value
        break
    }

    return errorInfo
  }

  // 输出到控制台
  logToConsole(errorInfo) {
    const styles = {
      [ErrorLevel.INFO]: 'color: #2196F3',
      [ErrorLevel.WARNING]: 'color: #FFC107',
      [ErrorLevel.ERROR]: 'color: #F44336',
      [ErrorLevel.CRITICAL]: 'color: #B71C1C; font-weight: bold'
    }

    console.group(`%c${errorInfo.type} - ${errorInfo.level}`, styles[errorInfo.level])
    console.log('Timestamp:', errorInfo.timestamp)
    console.log('Message:', errorInfo.message)
    console.log('Metadata:', errorInfo.metadata)
    if (errorInfo.stack) {
      console.log('Stack:', errorInfo.stack)
    }
    console.groupEnd()
  }

  // 获取所有日志
  getLogs() {
    return this.logs
  }

  // 获取特定级别的日志
  getLogsByLevel(level) {
    return this.logs.filter(log => log.level === level)
  }

  // 获取特定类型的日志
  getLogsByType(type) {
    return this.logs.filter(log => log.type === type)
  }

  // 清除日志
  clearLogs() {
    this.logs = []
  }

  // 导出日志
  exportLogs() {
    return JSON.stringify(this.logs, null, 2)
  }
}

// 创建单例
export const errorHandler = new ErrorHandler()

// 全局错误处理
export function setupGlobalErrorHandling() {
  // 处理未捕获的 Promise 错误
  window.addEventListener('unhandledrejection', (event) => {
    errorHandler.handleError(event.reason, ErrorType.UNKNOWN, ErrorLevel.ERROR)
  })

  // 处理未捕获的普通错误
  window.addEventListener('error', (event) => {
    errorHandler.handleError(event.error, ErrorType.UNKNOWN, ErrorLevel.ERROR)
  })

  // 处理 Vue 错误
  if (window.Vue) {
    window.Vue.config.errorHandler = (error, vm, info) => {
      errorHandler.handleError(error, ErrorType.UNKNOWN, ErrorLevel.ERROR)
    }
  }
}

// 导出默认实例
export default errorHandler
