import { ref, computed } from 'vue'
import { useTagStore } from '@/store'

export function useTag() {
  const loading = ref(false)
  const error = ref(null)
  const tagStore = useTagStore()

  // 计算属性
  const tags = computed(() => tagStore.sortedTags)

  // 初始化标签数据
  const initTagData = async () => {
    loading.value = true
    error.value = null

    try {
      await tagStore.fetchTags()
    } catch (err) {
      error.value = err.message
      throw err
    } finally {
      loading.value = false
    }
  }

  // 创建标签
  const createTag = async (tagData) => {
    loading.value = true
    error.value = null

    try {
      const response = await tagStore.createTag(tagData)
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

  // 批量创建标签
  const createTagsIfNotExist = async (tagNames) => {
    loading.value = true
    error.value = null

    try {
      const response = await tagStore.createTagsIfNotExist(tagNames)
      return response
    } catch (err) {
      error.value = err.message
      throw err
    } finally {
      loading.value = false
    }
  }

  // 更新标签
  const updateTag = async (tagId, tagData) => {
    loading.value = true
    error.value = null

    try {
      const response = await tagStore.updateTag(tagId, tagData)
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

  // 删除标签
  const deleteTag = async (tagId) => {
    loading.value = true
    error.value = null

    try {
      await tagStore.deleteTag(tagId)
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

  // 根据ID获取标签
  const getTagById = (id) => {
    return tagStore.getTagById(id)
  }

  // 根据ID列表获取多个标签
  const getTagsByIds = (ids) => {
    return tagStore.getTagsByIds(ids)
  }

  return {
    loading,
    error,
    tags,
    initTagData,
    createTag,
    createTagsIfNotExist,
    updateTag,
    deleteTag,
    getTagById,
    getTagsByIds
  }
}
