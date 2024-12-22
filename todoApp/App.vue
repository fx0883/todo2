<script>
import { useUserStore } from '@/store/modules/user'
import pagesConfig from './pages.json'

// 保存原始方法
const originalNavigateTo = uni.navigateTo
const originalRedirectTo = uni.redirectTo

// 重写 navigateTo
uni.navigateTo = function(options) {
  const userStore = useUserStore()
  const requiresAuth = checkIfRequiresAuth(options.url)
  
  // 添加调试信息
  console.log('Navigation Debug:', {
    url: options.url,
    isAuthenticated: userStore.isAuthenticated,
    requiresAuth: requiresAuth,
    token: uni.getStorageSync('accessToken')  // 检查 token 是否存在
  })

  if (requiresAuth && !userStore.isAuthenticated) {
    uni.showModal({
      title: '请登录',
      content: '您需要登录才能访问此页面。',
      showCancel: false,
      confirmText: '去登录',
      success: function (res) {
        if (res.confirm) {
          originalNavigateTo.call(uni, {
            url: '/pages/login/index'
          })
        }
      }
    })
  } else {
    originalNavigateTo.call(uni, options)
  }
}

// 重写 redirectTo
uni.redirectTo = function(options) {
  const userStore = useUserStore()
  const requiresAuth = checkIfRequiresAuth(options.url)

  if (requiresAuth && !userStore.isAuthenticated) {
    uni.showModal({
      title: '请登录',
      content: '您需要登录才能访问此页面。',
      showCancel: false,
      confirmText: '去登录',
      success: function (res) {
        if (res.confirm) {
          originalRedirectTo.call(uni, {
            url: '/pages/login/index'
          })
        }
      }
    })
  } else {
    originalRedirectTo.call(uni, options)
  }
}

// 自定义函数，检查页面是否需要登录
function checkIfRequiresAuth(url) {
  const userStore = useUserStore()
  // 如果用户已登录，允许访问任何页面
  if (userStore.isAuthenticated) {
    return false
  }
  // 确保首页不需要检查登录状态
  if (url === '/pages/index/index') {
    return false
  }
  const page = pagesConfig.pages.find(page => `/${page.path}` === url)
  return page && page.requiresAuth
}

export default {
  onLaunch: function() {
    console.log('App Launch')
  },
  onShow: function() {
    console.log('App Show')

    // 添加全局点击事件监听
  },
  onHide: function() {
    console.log('App Hide')
  }
}
</script>

<style>
  /*每个页面公共css */
</style>
