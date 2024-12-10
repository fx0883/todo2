import { ref, computed, onMounted, onUnmounted } from 'vue'

export function useVirtualScroll(options = {}) {
  const {
    itemHeight = 50,
    bufferSize = 5,
    containerHeight = 400
  } = options

  const items = ref([])
  const scrollTop = ref(0)
  const containerRef = ref(null)

  // 计算可见区域的起始和结束索引
  const visibleRange = computed(() => {
    const start = Math.floor(scrollTop.value / itemHeight)
    const visibleCount = Math.ceil(containerHeight / itemHeight)
    const bufferStart = Math.max(0, start - bufferSize)
    const bufferEnd = Math.min(items.value.length, start + visibleCount + bufferSize)

    return {
      start: bufferStart,
      end: bufferEnd
    }
  })

  // 计算可见项目
  const visibleItems = computed(() => {
    const { start, end } = visibleRange.value
    return items.value.slice(start, end).map((item, index) => ({
      ...item,
      style: {
        position: 'absolute',
        top: `${(start + index) * itemHeight}px`,
        height: `${itemHeight}px`
      }
    }))
  })

  // 计算总高度
  const totalHeight = computed(() => {
    return items.value.length * itemHeight
  })

  // 处理滚动事件
  const handleScroll = (e) => {
    scrollTop.value = e.target.scrollTop
  }

  // 滚动到指定索引
  const scrollToIndex = (index) => {
    if (containerRef.value) {
      containerRef.value.scrollTop = index * itemHeight
    }
  }

  // 添加项目
  const addItems = (newItems) => {
    items.value = [...items.value, ...newItems]
  }

  // 设置项目
  const setItems = (newItems) => {
    items.value = newItems
  }

  // 清空项目
  const clearItems = () => {
    items.value = []
  }

  // 获取真实DOM索引
  const getRealIndex = (virtualIndex) => {
    return virtualIndex + visibleRange.value.start
  }

  // 监听滚动事件
  onMounted(() => {
    if (containerRef.value) {
      containerRef.value.addEventListener('scroll', handleScroll)
    }
  })

  onUnmounted(() => {
    if (containerRef.value) {
      containerRef.value.removeEventListener('scroll', handleScroll)
    }
  })

  return {
    // refs
    containerRef,
    scrollTop,

    // computed
    visibleItems,
    totalHeight,
    visibleRange,

    // methods
    scrollToIndex,
    addItems,
    setItems,
    clearItems,
    getRealIndex
  }
}
