import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import { useCache } from '@/composables/useCache'
import { useErrorLog } from '@/composables/useErrorLog'
import { categoryApi } from '@/api'

export const useCategoryStore = defineStore('category', () => {
  // 使用 composables
  const cache = useCache()
  const { addErrorLog } = useErrorLog()

  // 状态
  const categories = ref([])
  const loading = ref(false)

  // 计算属性
  const sortedCategories = computed(() => {
    return [...categories.value].sort((a, b) => a.order - b.order)
  })

  // Actions
  const fetchCategories = async () => {
    const cacheKey = 'categories'
    const cachedCategories = cache.get(cacheKey)
    
    if (cachedCategories) {
      categories.value = cachedCategories
      return cachedCategories
    }

    loading.value = true
    try {
      const response = await categoryApi.getCategories()
      categories.value = response.results
      cache.set(cacheKey, response, 5 * 60 * 1000) // 缓存5分钟
      return response
    } catch (error) {
      addErrorLog(error, { action: 'fetchCategories' })
      throw error
    } finally {
      loading.value = false
    }
  }

  const createCategory = async (categoryData) => {
    loading.value = true
    try {
      const response = await categoryApi.createCategory(categoryData)
      categories.value.push(response)
      // 清除缓存
      cache.remove('categories')
      return response
    } catch (error) {
      addErrorLog(error, { action: 'createCategory', categoryData })
      throw error
    } finally {
      loading.value = false
    }
  }

  const updateCategory = async (categoryId, categoryData) => {
    loading.value = true
    try {
      const response = await categoryApi.updateCategory(categoryId, categoryData)
      const index = categories.value.findIndex(c => c.id === categoryId)
      if (index !== -1) {
        categories.value[index] = response
      }
      // 清除缓存
      cache.remove('categories')
      return response
    } catch (error) {
      addErrorLog(error, { action: 'updateCategory', categoryId, categoryData })
      throw error
    } finally {
      loading.value = false
    }
  }

  const deleteCategory = async (categoryId) => {
    loading.value = true
    try {
      await categoryApi.deleteCategory(categoryId)
      categories.value = categories.value.filter(c => c.id !== categoryId)
      // 清除缓存
      cache.remove('categories')
    } catch (error) {
      addErrorLog(error, { action: 'deleteCategory', categoryId })
      throw error
    } finally {
      loading.value = false
    }
  }

  // 更新分类顺序
  const updateCategoriesOrder = async (newOrder) => {
    loading.value = true
    try {
      const response = await categoryApi.batchUpdateCategories(newOrder)
      categories.value = response
      // 清除缓存
      cache.remove('categories')
      return response
    } catch (error) {
      addErrorLog(error, { action: 'updateCategoriesOrder', newOrder })
      throw error
    } finally {
      loading.value = false
    }
  }

  // Reset store
  const reset = () => {
    categories.value = []
    loading.value = false
    cache.remove('categories')
  }

  return {
    // State
    categories,
    loading,
    
    // Getters
    sortedCategories,
    
    // Actions
    fetchCategories,
    createCategory,
    updateCategory,
    deleteCategory,
    updateCategoriesOrder,
    reset
  }
})
