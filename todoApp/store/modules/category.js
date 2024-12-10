import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import { categoryApi } from '@/api'

export const useCategoryStore = defineStore('category', () => {
  // 状态
  const categories = ref([])
  const loading = ref(false)
  const error = ref(null)
  const cache = ref({
    lastUpdate: null,
    expiresIn: 30 * 60 * 1000 // 30分钟缓存，分类变动较少
  })

  // Getters
  const sortedCategories = computed(() => {
    return [...categories.value].sort((a, b) => a.order - b.order)
  })

  const getCategoryById = computed(() => {
    return (id) => categories.value.find(c => c.id === id)
  })

  const needsRefresh = computed(() => {
    if (!cache.value.lastUpdate) return true
    return Date.now() - cache.value.lastUpdate > cache.value.expiresIn
  })

  // Actions
  const fetchCategories = async (force = false) => {
    // 如果有缓存且未过期，直接返回
    if (!force && !needsRefresh.value && categories.value.length > 0) {
      return categories.value
    }

    loading.value = true
    error.value = null
    
    try {
      const response = await categoryApi.getCategories()
      categories.value = response
      cache.value.lastUpdate = Date.now()
      saveToStorage() // 保存到本地存储
      return response
    } catch (err) {
      error.value = err.message
      throw err
    } finally {
      loading.value = false
    }
  }

  const createCategory = async (categoryData) => {
    loading.value = true
    error.value = null
    
    try {
      const response = await categoryApi.createCategory(categoryData)
      categories.value.push(response)
      saveToStorage()
      return response
    } catch (err) {
      error.value = err.message
      throw err
    } finally {
      loading.value = false
    }
  }

  const updateCategory = async (categoryId, categoryData) => {
    loading.value = true
    error.value = null
    
    try {
      const response = await categoryApi.updateCategory(categoryId, categoryData)
      const index = categories.value.findIndex(c => c.id === categoryId)
      if (index !== -1) {
        categories.value[index] = response
      }
      saveToStorage()
      return response
    } catch (err) {
      error.value = err.message
      throw err
    } finally {
      loading.value = false
    }
  }

  const deleteCategory = async (categoryId) => {
    loading.value = true
    error.value = null
    
    try {
      await categoryApi.deleteCategory(categoryId)
      categories.value = categories.value.filter(c => c.id !== categoryId)
      saveToStorage()
    } catch (err) {
      error.value = err.message
      throw err
    } finally {
      loading.value = false
    }
  }

  // 更新分类顺序
  const updateCategoriesOrder = async (newOrder) => {
    loading.value = true
    error.value = null
    
    try {
      const updatePromises = newOrder.map((categoryId, index) => {
        return updateCategory(categoryId, { order: index })
      })
      await Promise.all(updatePromises)
      await fetchCategories(true) // 重新获取最新数据
    } catch (err) {
      error.value = err.message
      throw err
    } finally {
      loading.value = false
    }
  }

  // 数据持久化
  const saveToStorage = () => {
    uni.setStorageSync('categories', {
      data: categories.value,
      timestamp: Date.now()
    })
  }

  const loadFromStorage = () => {
    const stored = uni.getStorageSync('categories')
    if (stored && stored.timestamp) {
      const age = Date.now() - stored.timestamp
      if (age < cache.value.expiresIn) {
        categories.value = stored.data
        cache.value.lastUpdate = stored.timestamp
      }
    }
  }

  // 初始化
  const init = () => {
    loadFromStorage()
    fetchCategories()
  }

  return {
    // 状态
    categories,
    loading,
    error,
    // Getters
    sortedCategories,
    getCategoryById,
    // Actions
    fetchCategories,
    createCategory,
    updateCategory,
    deleteCategory,
    updateCategoriesOrder,
    // 初始化
    init
  }
})
