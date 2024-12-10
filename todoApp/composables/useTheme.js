import { computed } from 'vue'
import { usePreferences } from './usePreferences'

export function useTheme() {
  const { preferences } = usePreferences()

  // 主题配置
  const themes = {
    light: {
      primary: '#4CAF50',
      secondary: '#2196F3',
      background: '#FFFFFF',
      surface: '#F5F5F5',
      error: '#FF5252',
      text: '#000000',
      border: '#E0E0E0'
    },
    dark: {
      primary: '#81C784',
      secondary: '#64B5F6',
      background: '#121212',
      surface: '#1E1E1E',
      error: '#FF5252',
      text: '#FFFFFF',
      border: '#424242'
    }
  }

  // 当前主题
  const currentTheme = computed(() => {
    return themes[preferences.value.theme] || themes.light
  })

  // 是否是深色主题
  const isDarkTheme = computed(() => {
    return preferences.value.theme === 'dark'
  })

  // 应用主题到 DOM
  const applyTheme = () => {
    const theme = currentTheme.value
    Object.entries(theme).forEach(([key, value]) => {
      document.documentElement.style.setProperty(`--theme-${key}`, value)
    })
    // 设置 data-theme 属性用于 CSS 选择器
    document.documentElement.setAttribute('data-theme', preferences.value.theme)
  }

  // 切换主题
  const toggleTheme = () => {
    preferences.value.theme = isDarkTheme.value ? 'light' : 'dark'
    applyTheme()
  }

  // 设置特定主题
  const setTheme = (themeName) => {
    if (themes[themeName]) {
      preferences.value.theme = themeName
      applyTheme()
    }
  }

  // 获取主题变量值
  const getThemeVariable = (variableName) => {
    return currentTheme.value[variableName]
  }

  // 初始化主题
  const initTheme = () => {
    // 检查系统主题偏好
    if (window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches) {
      setTheme('dark')
    } else {
      setTheme('light')
    }

    // 监听系统主题变化
    window.matchMedia('(prefers-color-scheme: dark)').addEventListener('change', (e) => {
      setTheme(e.matches ? 'dark' : 'light')
    })
  }

  return {
    // 状态
    currentTheme,
    isDarkTheme,
    themes,

    // 方法
    applyTheme,
    toggleTheme,
    setTheme,
    getThemeVariable,
    initTheme
  }
}
