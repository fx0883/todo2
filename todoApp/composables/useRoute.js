import { reactive } from 'vue'

export function useRoute() {
  const getCurrentRoute = () => {
    const pages = getCurrentPages()
    const currentPage = pages[pages.length - 1]
    return currentPage
  }

  const route = reactive({
    get params() {
      const currentPage = getCurrentRoute()
      return currentPage?.options || {}
    },
    get path() {
      const currentPage = getCurrentRoute()
      return currentPage?.route || ''
    },
    get fullPath() {
      const currentPage = getCurrentRoute()
      const options = currentPage?.options || {}
      const queryString = Object.keys(options)
        .map(key => `${key}=${options[key]}`)
        .join('&')
      return `/${currentPage?.route}${queryString ? '?' + queryString : ''}`
    }
  })

  return route
} 