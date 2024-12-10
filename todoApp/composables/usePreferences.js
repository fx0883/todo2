import { ref, watch } from 'vue'

export function usePreferences() {
  // 用户偏好设置
  const preferences = ref({
    theme: uni.getStorageSync('theme') || 'light',
    taskSort: uni.getStorageSync('taskSort') || 'dueDate',
    taskView: uni.getStorageSync('taskView') || 'list',
    categoriesCollapsed: uni.getStorageSync('categoriesCollapsed') || false,
    sidebarWidth: uni.getStorageSync('sidebarWidth') || 250,
    notifications: uni.getStorageSync('notifications') || true
  })

  // 监听偏好设置变化并保存到本地存储
  watch(
    preferences,
    (newPreferences) => {
      Object.entries(newPreferences).forEach(([key, value]) => {
        uni.setStorageSync(key, value)
      })
    },
    { deep: true }
  )

  // 更新主题
  const updateTheme = (theme) => {
    preferences.value.theme = theme
    // 应用主题样式
    document.documentElement.setAttribute('data-theme', theme)
  }

  // 更新任务排序方式
  const updateTaskSort = (sortBy) => {
    preferences.value.taskSort = sortBy
  }

  // 更新任务视图模式
  const updateTaskView = (view) => {
    preferences.value.taskView = view
  }

  // 切换分类折叠状态
  const toggleCategoriesCollapsed = () => {
    preferences.value.categoriesCollapsed = !preferences.value.categoriesCollapsed
  }

  // 更新侧边栏宽度
  const updateSidebarWidth = (width) => {
    preferences.value.sidebarWidth = width
  }

  // 更新通知设置
  const updateNotifications = (enabled) => {
    preferences.value.notifications = enabled
  }

  // 重置所有偏好设置
  const resetPreferences = () => {
    preferences.value = {
      theme: 'light',
      taskSort: 'dueDate',
      taskView: 'list',
      categoriesCollapsed: false,
      sidebarWidth: 250,
      notifications: true
    }
  }

  return {
    // 状态
    preferences,

    // 方法
    updateTheme,
    updateTaskSort,
    updateTaskView,
    toggleCategoriesCollapsed,
    updateSidebarWidth,
    updateNotifications,
    resetPreferences
  }
}
