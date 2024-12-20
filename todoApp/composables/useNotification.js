import { ref, computed } from 'vue'
import { usePreferences } from './usePreferences'

export function useNotification() {
  const { preferences } = usePreferences()
  const notifications = ref([])
  const loading = ref(false)
  const error = ref(null)

  // 添加通知
  const addNotification = (notification) => {
    if (!preferences.value.notifications) return

    const id = Date.now()
    notifications.value.push({
      id,
      ...notification,
      timestamp: new Date(),
      read: false
    })

    // 根据平台显示不同的通知
    showPlatformNotification(notification)

    // 5秒后自动移除通知
    setTimeout(() => {
      removeNotification(id)
    }, 5000)

    return id
  }

  // 根据平台显示通知
  const showPlatformNotification = (notification) => {
    // #ifdef H5
    if (window.Notification && Notification.permission === 'granted') {
      new Notification(notification.title, {
        body: notification.message,
        icon: notification.icon
      })
    }
    // #endif

    // #ifdef MP-WEIXIN
    uni.showToast({
      title: notification.message,
      icon: notification.type === 'error' ? 'error' : 'none',
      duration: 2000
    })
    // #endif

    // #ifdef APP-PLUS
    plus.nativeUI.toast(notification.message, {
      duration: 'short'
    })
    // #endif
  }

  // 移除通知
  const removeNotification = (id) => {
    notifications.value = notifications.value.filter(n => n.id !== id)
  }

  // 标记通知为已读
  const markAsRead = (id) => {
    const notification = notifications.value.find(n => n.id === id)
    if (notification) {
      notification.read = true
    }
  }

  // 标记所有通知为已读
  const markAllAsRead = () => {
    notifications.value.forEach(n => n.read = true)
  }

  // 清空所有通知
  const clearAll = () => {
    notifications.value = []
  }

  // 获取未读通知数量
  const unreadCount = computed(() => {
    return notifications.value.filter(n => !n.read).length
  })

  // 请求通知权限
  const requestNotificationPermission = async () => {
    if (!window.Notification) {
      return false
    }

    try {
      const permission = await Notification.requestPermission()
      return permission === 'granted'
    } catch (e) {
      console.error('Error requesting notification permission:', e)
      return false
    }
  }

  return {
    // 状态
    notifications,
    loading,
    error,
    unreadCount,

    // 方法
    addNotification,
    removeNotification,
    markAsRead,
    markAllAsRead,
    clearAll,
    requestNotificationPermission
  }
}
