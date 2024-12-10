import { ref, onMounted, onUnmounted } from 'vue'
import { useErrorLog } from './useErrorLog'

export function usePerformance() {
  const { addErrorLog } = useErrorLog()
  const metrics = ref({
    fps: 0,
    memory: null,
    timing: null,
    resources: []
  })
  
  let frameCount = 0
  let lastTime = performance.now()
  let animationFrameId = null

  // 计算 FPS
  const calculateFPS = () => {
    frameCount++
    const currentTime = performance.now()
    
    if (currentTime - lastTime >= 1000) {
      metrics.value.fps = frameCount
      frameCount = 0
      lastTime = currentTime
    }
    
    animationFrameId = requestAnimationFrame(calculateFPS)
  }

  // 收集内存使用情况
  const collectMemoryMetrics = () => {
    if (performance.memory) {
      metrics.value.memory = {
        jsHeapSizeLimit: performance.memory.jsHeapSizeLimit,
        totalJSHeapSize: performance.memory.totalJSHeapSize,
        usedJSHeapSize: performance.memory.usedJSHeapSize
      }
    }
  }

  // 收集页面加载时间
  const collectTimingMetrics = () => {
    const timing = performance.timing
    metrics.value.timing = {
      domComplete: timing.domComplete - timing.navigationStart,
      domInteractive: timing.domInteractive - timing.navigationStart,
      domContentLoaded: timing.domContentLoadedEventEnd - timing.navigationStart,
      loadComplete: timing.loadEventEnd - timing.navigationStart
    }
  }

  // 收集资源加载时间
  const collectResourceMetrics = () => {
    const resources = performance.getEntriesByType('resource')
    metrics.value.resources = resources.map(resource => ({
      name: resource.name,
      type: resource.initiatorType,
      duration: resource.duration,
      size: resource.transferSize
    }))
  }

  // 监控长任务
  const observeLongTasks = () => {
    const observer = new PerformanceObserver((list) => {
      list.getEntries().forEach((entry) => {
        if (entry.duration > 50) { // 超过 50ms 的任务
          addErrorLog(new Error('Long task detected'), {
            type: 'performance',
            duration: entry.duration,
            startTime: entry.startTime,
            name: entry.name
          })
        }
      })
    })
    
    observer.observe({ entryTypes: ['longtask'] })
  }

  // 开始性能监控
  const startMonitoring = () => {
    // 启动 FPS 监控
    calculateFPS()
    
    // 定期收集内存指标
    setInterval(collectMemoryMetrics, 5000)
    
    // 收集页面加载指标
    window.addEventListener('load', () => {
      collectTimingMetrics()
      collectResourceMetrics()
    })
    
    // 监控长任务
    if (window.PerformanceObserver) {
      observeLongTasks()
    }
  }

  // 停止性能监控
  const stopMonitoring = () => {
    if (animationFrameId) {
      cancelAnimationFrame(animationFrameId)
    }
  }

  // 获取性能报告
  const getPerformanceReport = () => {
    return {
      ...metrics.value,
      timestamp: new Date().toISOString()
    }
  }

  // 检查性能问题
  const checkPerformanceIssues = () => {
    const issues = []
    
    // 检查 FPS
    if (metrics.value.fps < 30) {
      issues.push({
        type: 'fps',
        message: 'FPS 过低',
        value: metrics.value.fps
      })
    }
    
    // 检查内存使用
    if (metrics.value.memory) {
      const memoryUsage = metrics.value.memory.usedJSHeapSize / metrics.value.memory.jsHeapSizeLimit
      if (memoryUsage > 0.8) {
        issues.push({
          type: 'memory',
          message: '内存使用率过高',
          value: memoryUsage
        })
      }
    }
    
    // 检查加载时间
    if (metrics.value.timing && metrics.value.timing.loadComplete > 3000) {
      issues.push({
        type: 'loading',
        message: '页面加载时间过长',
        value: metrics.value.timing.loadComplete
      })
    }
    
    return issues
  }

  onMounted(() => {
    startMonitoring()
  })

  onUnmounted(() => {
    stopMonitoring()
  })

  return {
    // 状态
    metrics,

    // 方法
    startMonitoring,
    stopMonitoring,
    getPerformanceReport,
    checkPerformanceIssues
  }
}
