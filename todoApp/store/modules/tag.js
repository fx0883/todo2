import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import { tagApi } from '@/api'

export const useTagStore = defineStore('tag', () => {
  // 状态
  const tags = ref([])
  const loading = ref(false)
  const error = ref(null)
  const cache = ref({
    lastUpdate: null,
    expiresIn: 30 * 60 * 1000 // 30分钟缓存，标签变动较少
  })

  // Getters
  const sortedTags = computed(() => {
    return [...tags.value].sort((a, b) => a.name.localeCompare(b.name))
  })

  const getTagById = computed(() => {
    return (id) => tags.value.find(t => t.id === id)
  })

  const getTagsByIds = computed(() => {
    return (ids) => tags.value.filter(t => ids.includes(t.id))
  })

  const needsRefresh = computed(() => {
    if (!cache.value.lastUpdate) return true
    return Date.now() - cache.value.lastUpdate > cache.value.expiresIn
  })

  // Actions
  const fetchTags = async (force = false) => {
    // 如果有缓存且未过期，直接返回
    if (!force && !needsRefresh.value && tags.value.length > 0) {
      return tags.value
    }

    loading.value = true
    error.value = null
    
    try {
      const response = await tagApi.getTags()
      tags.value = response
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

  const createTag = async (tagData) => {
    loading.value = true
    error.value = null
    
    try {
      const response = await tagApi.createTag(tagData)
      tags.value.push(response)
      saveToStorage()
      return response
    } catch (err) {
      error.value = err.message
      throw err
    } finally {
      loading.value = false
    }
  }

  const updateTag = async (tagId, tagData) => {
    loading.value = true
    error.value = null
    
    try {
      const response = await tagApi.updateTag(tagId, tagData)
      const index = tags.value.findIndex(t => t.id === tagId)
      if (index !== -1) {
        tags.value[index] = response
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

  const deleteTag = async (tagId) => {
    loading.value = true
    error.value = null
    
    try {
      await tagApi.deleteTag(tagId)
      tags.value = tags.value.filter(t => t.id !== tagId)
      saveToStorage()
    } catch (err) {
      error.value = err.message
      throw err
    } finally {
      loading.value = false
    }
  }

  // 批量创建标签
  const createTagsIfNotExist = async (tagNames) => {
    const existingTags = tags.value
    const newTagNames = tagNames.filter(name => 
      !existingTags.some(tag => tag.name === name)
    )

    if (newTagNames.length === 0) {
      return existingTags
    }

    loading.value = true
    error.value = null
    
    try {
      const createPromises = newTagNames.map(name => 
        createTag({ name, color: '#' + Math.floor(Math.random()*16777215).toString(16) })
      )
      await Promise.all(createPromises)
      return tags.value
    } catch (err) {
      error.value = err.message
      throw err
    } finally {
      loading.value = false
    }
  }

  // 数据持久化
  const saveToStorage = () => {
    uni.setStorageSync('tags', {
      data: tags.value,
      timestamp: Date.now()
    })
  }

  const loadFromStorage = () => {
    const stored = uni.getStorageSync('tags')
    if (stored && stored.timestamp) {
      const age = Date.now() - stored.timestamp
      if (age < cache.value.expiresIn) {
        tags.value = stored.data
        cache.value.lastUpdate = stored.timestamp
      }
    }
  }

  // 初始化
  const init = () => {
    loadFromStorage()
    fetchTags()
  }

  return {
    // 状态
    tags,
    loading,
    error,
    // Getters
    sortedTags,
    getTagById,
    getTagsByIds,
    // Actions
    fetchTags,
    createTag,
    updateTag,
    deleteTag,
    createTagsIfNotExist,
    // 初始化
    init
  }
})
