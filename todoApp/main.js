import App from './App.vue'
import { setupGlobalErrorHandling, errorHandler } from './utils/errorHandler'

// #ifndef VUE3
import Vue from 'vue'
import './uni.promisify.adaptor'
Vue.config.productionTip = false
App.mpType = 'app'
const app = new Vue({
  ...App
})
app.$mount()
// #endif

// #ifdef VUE3
import { createSSRApp } from 'vue'
import { createPinia } from 'pinia'

export function createApp() {
  const app = createSSRApp(App)
  
  // 创建 Pinia 实例
  const pinia = createPinia()
  app.use(pinia)
  
  // 设置全局错误处理
  setupGlobalErrorHandling()
  
  // 添加全局错误监听器
  errorHandler.addListener((error) => {
    console.warn('Global error caught:', error)
  })
  
  return {
    app,
    pinia // 返回 pinia 实例
  }
}
// #endif