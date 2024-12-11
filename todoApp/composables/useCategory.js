import { ref, computed } from 'vue'
import { useCategoryStore } from '@/store'

export function useCategory() {
  const loading = ref(false)
  const error = ref(null)
  const categoryStore = useCategoryStore()

  // 计算属性
  const categories = computed(() => categoryStore.sortedCategories)

  // 初始化分类数据
  const initCategoryData = async () => {
    loading.value = true
    error.value = null

    try {
      await categoryStore.fetchCategories()
    } catch (err) {
      error.value = err.message
      throw err
    } finally {
      loading.value = false
    }
  }

  // 创建分类
  const createCategory = async (categoryData) => {
    loading.value = true
    error.value = null

    try {
      const response = await categoryStore.createCategory(categoryData)
      uni.showToast({
        title: '创建成功',
        icon: 'success'
      })
      return response
    } catch (err) {
      error.value = err.message
      throw err
    } finally {
      loading.value = false
    }
  }

  // 更新分类
  const updateCategory = async (categoryId, categoryData) => {
    loading.value = true
    error.value = null

    try {
      const response = await categoryStore.updateCategory(categoryId, categoryData)
      uni.showToast({
        title: '更新成功',
        icon: 'success'
      })
      return response
    } catch (err) {
      error.value = err.message
      throw err
    } finally {
      loading.value = false
    }
  }

  // 获取分类列表
  const fetchCategories = async () => {
    try {
      loading.value = true
      error.value = null
      await categoryStore.fetchCategories()
    } catch (e) {
      error.value = e.message || '获取分类列表失败'
    } finally {
      loading.value = false
    }
  }

  // 删除分类
  const deleteCategory = async (categoryId) => {
    loading.value = true
    error.value = null

    try {
      await categoryStore.deleteCategory(categoryId)
      uni.showToast({
        title: '删除成功',
        icon: 'success'
      })
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
      await categoryStore.updateCategoriesOrder(newOrder)
      uni.showToast({
        title: '排序更新成功',
        icon: 'success'
      })
    } catch (err) {
      error.value = err.message
      throw err
    } finally {
      loading.value = false
    }
  }

  return {
    loading,
    error,
    categories,
    initCategoryData,
    createCategory,
    updateCategory,
    deleteCategory,
    updateCategoriesOrder,
    fetchCategories
  }
}
