import { ref } from 'vue'

export function useCache() {
  const cache = ref(new Map())
  
  // 缓存配置
  const defaultConfig = {
    ttl: 5 * 60 * 1000, // 默认缓存时间 5 分钟
    maxSize: 100 // 最大缓存项数
  }

  // 缓存项结构
  class CacheItem {
    constructor(value, ttl = defaultConfig.ttl) {
      this.value = value
      this.timestamp = Date.now()
      this.ttl = ttl
    }

    isExpired() {
      return Date.now() - this.timestamp > this.ttl
    }
  }

  // 获取缓存
  const get = (key) => {
    const item = cache.value.get(key)
    if (!item) return null

    if (item.isExpired()) {
      cache.value.delete(key)
      return null
    }

    return item.value
  }

  // 设置缓存
  const set = (key, value, ttl = defaultConfig.ttl) => {
    // 检查缓存大小
    if (cache.value.size >= defaultConfig.maxSize) {
      // 删除最旧的缓存项
      const oldestKey = Array.from(cache.value.keys())[0]
      cache.value.delete(oldestKey)
    }

    cache.value.set(key, new CacheItem(value, ttl))
  }

  // 删除缓存
  const remove = (key) => {
    cache.value.delete(key)
  }

  // 清空缓存
  const clear = () => {
    cache.value.clear()
  }

  // 检查是否存在
  const has = (key) => {
    const item = cache.value.get(key)
    if (!item) return false
    
    if (item.isExpired()) {
      cache.value.delete(key)
      return false
    }
    
    return true
  }

  // 获取缓存大小
  const size = () => {
    return cache.value.size
  }

  // 清理过期缓存
  const cleanup = () => {
    for (const [key, item] of cache.value.entries()) {
      if (item.isExpired()) {
        cache.value.delete(key)
      }
    }
  }

  // 批量操作
  const getMany = (keys) => {
    return keys.map(key => ({ key, value: get(key) }))
  }

  const setMany = (items, ttl = defaultConfig.ttl) => {
    items.forEach(({ key, value }) => set(key, value, ttl))
  }

  // 定期清理过期缓存
  setInterval(cleanup, 60 * 1000) // 每分钟清理一次

  return {
    get,
    set,
    remove,
    clear,
    has,
    size,
    cleanup,
    getMany,
    setMany
  }
}
