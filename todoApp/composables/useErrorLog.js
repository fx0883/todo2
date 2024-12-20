import { ref } from 'vue'
import { useAuth } from './useAuth'
import { useNotification } from './useNotification'

export function useErrorLog() {
  const { user } = useAuth()
  const { addNotification } = useNotification()
  const errorLogs = ref([])
  const isReporting = ref(false)

  // 错误日志结构
  class ErrorLog {
    constructor(error, context = {}) {
      this.id = Date.now()
      this.timestamp = new Date().toISOString()
      this.error = {
        message: error.message,
        stack: error.stack,
        name: error.name
      }
      this.context = {
        userId: user?.value?.id,
        ...this.getPlatformInfo(),
        ...context
      }
      this.status = 'pending'
    }

    getPlatformInfo() {
      // #ifdef H5
      return {
        url: window.location.href,
        userAgent: navigator.userAgent,
        platform: 'h5'
      }
      // #endif

      // #ifdef MP-WEIXIN
      const accountInfo = uni.getAccountInfoSync()
      return {
        url: '',
        platform: 'mp-weixin',
        version: accountInfo.miniProgram.version || '',
        envVersion: accountInfo.miniProgram.envVersion || ''
      }
      // #endif

      // 其他平台
      return {
        url: '',
        platform: 'unknown'
      }
    }
  }

  // 添加错误日志
  const addErrorLog = (error, context = {}) => {
    const log = new ErrorLog(error, context)
    errorLogs.value.push(log)
    
    // 显示通知
    addNotification({
      title: '发生错误',
      message: error.message,
      type: 'error'
    })

    // 自动上报
    reportError(log)
    
    return log.id
  }

  // 上报错误
  const reportError = async (log) => {
    if (isReporting.value) return

    try {
      isReporting.value = true
      
      // 这里应该替换为实际的错误上报 API
      // await api.reportError(log)
      
      log.status = 'reported'
      console.error('Error reported:', log)
    } catch (e) {
      log.status = 'failed'
      console.error('Failed to report error:', e)
    } finally {
      isReporting.value = false
    }
  }

  // 批量上报错误
  const reportErrors = async () => {
    const pendingLogs = errorLogs.value.filter(log => log.status === 'pending')
    await Promise.all(pendingLogs.map(log => reportError(log)))
  }

  // 清理已上报的错误
  const clearReportedErrors = () => {
    errorLogs.value = errorLogs.value.filter(log => log.status !== 'reported')
  }

  // 获取错误统计
  const getErrorStats = () => {
    return {
      total: errorLogs.value.length,
      pending: errorLogs.value.filter(log => log.status === 'pending').length,
      reported: errorLogs.value.filter(log => log.status === 'reported').length,
      failed: errorLogs.value.filter(log => log.status === 'failed').length
    }
  }

  // 全局错误处理
  const setupGlobalErrorHandler = () => {
    window.onerror = (message, source, lineno, colno, error) => {
      addErrorLog(error || new Error(message), {
        source,
        lineno,
        colno
      })
    }

    window.addEventListener('unhandledrejection', (event) => {
      addErrorLog(event.reason, {
        type: 'unhandledrejection'
      })
    })
  }

  return {
    // 状态
    errorLogs,
    isReporting,

    // 方法
    addErrorLog,
    reportError,
    reportErrors,
    clearReportedErrors,
    getErrorStats,
    setupGlobalErrorHandler
  }
}
