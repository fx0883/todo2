import { createPinia } from 'pinia'

// 导入所有 store
import { useUserStore } from './user'
import { useTaskStore } from './modules/task'
import { useCategoryStore } from './modules/category'
import { useTagStore } from './modules/tag'

// 创建 pinia 实例
const pinia = createPinia()

// 导出 store 实例
export {
  useUserStore,
  useTaskStore,
  useCategoryStore,
  useTagStore
}

// 导出 pinia 实例
export default pinia
