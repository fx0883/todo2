import { ref, computed } from 'vue'
import { useAuth } from './useAuth'
import { useTask } from './useTask'

export function useNavigation() {
  const { isAuthenticated, checkTokenExpiration } = useAuth()
  const { loading } = useTask()
  const navigationStack = ref([])
  const currentRoute = ref(null)

  // 检查是否可以离开当前页面
  const canLeave = computed(() => {
    // 如果正在加载，不允许离开
    if (loading.value) return false
    return true
  })

  // 添加导航记录
  const pushRoute = (route) => {
    navigationStack.value.push(currentRoute.value)
    currentRoute.value = route
  }

  // 返回上一页
  const goBack = () => {
    if (navigationStack.value.length > 0) {
      currentRoute.value = navigationStack.value.pop()
      return true
    }
    return false
  }

  // 路由守卫
  const beforeEach = async (to, from, next) => {
    // 检查是否需要认证
    if (to.meta.requiresAuth) {
      // 检查认证状态和 token 是否过期
      if (!isAuthenticated.value || checkTokenExpiration()) {
        // 保存目标路由，登录后跳转
        uni.setStorageSync('redirectRoute', to.fullPath)
        next('/login')
        return
      }
    }

    // 检查是否可以离开当前页面
    if (!canLeave.value) {
      // 显示确认对话框
      uni.showModal({
        title: '提示',
        content: '当前操作尚未完成，确定要离开吗？',
        success: (res) => {
          if (res.confirm) {
            pushRoute(to)
            next()
          } else {
            next(false)
          }
        }
      })
      return
    }

    pushRoute(to)
    next()
  }

  // 获取重定向路由
  const getRedirectRoute = () => {
    const redirectRoute = uni.getStorageSync('redirectRoute')
    uni.removeStorageSync('redirectRoute')
    return redirectRoute || '/'
  }

  // 清除导航历史
  const clearNavigationStack = () => {
    navigationStack.value = []
    currentRoute.value = null
  }

  return {
    // 状态
    currentRoute,
    navigationStack,
    canLeave,

    // 方法
    pushRoute,
    goBack,
    beforeEach,
    getRedirectRoute,
    clearNavigationStack
  }
}
