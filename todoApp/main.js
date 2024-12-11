import App from './App.vue'
import pinia from './store'
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
import * as Pinia from 'pinia'

export function createApp() {
  const app = createSSRApp(App)
  
  // 设置 Pinia
  app.use(Pinia.createPinia())
  
  // 设置全局错误处理
  setupGlobalErrorHandling()
  
  // 添加全局错误监听器
  errorHandler.addListener((error) => {
    // 可以在这里添加额外的错误处理逻辑
    // 比如发送到错误追踪服务
    console.warn('Global error caught:', error)
  })
  
  
  
  
  return {
    app,
    Pinia
  }
}
// #endif