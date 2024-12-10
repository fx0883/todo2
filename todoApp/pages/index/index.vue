<template>
  <view class="container">
    <!-- 分类筛选 -->
    <scroll-view 
      class="categories" 
      scroll-x 
      show-scrollbar="false"
      enhanced
    >
      <view class="category-list">
        <view 
          class="category-item" 
          :class="{ active: !selectedCategory }"
          @click="selectedCategory = null"
        >
          全部
        </view>
        <view 
          v-for="category in categories" 
          :key="category.id"
          class="category-item"
          :class="{ active: selectedCategory === category.id }"
          @click="selectedCategory = category.id"
        >
          {{ category.name }}
        </view>
      </view>
    </scroll-view>

    <!-- 任务列表 -->
    <view class="task-list">
      <template v-if="filteredTasks.length > 0">
        <view 
          v-for="task in filteredTasks" 
          :key="task.id" 
          class="task-item"
          :class="{ completed: task.completed }"
          @click="navigateToDetail(task.id)"
        >
          <checkbox 
            :checked="task.completed" 
            @tap.stop="toggleTaskStatus(task)"
            class="checkbox"
          />
          <view class="content">
            <text class="title" :class="{ 'completed-text': task.completed }">{{ task.title }}</text>
            <view class="meta">
              <text class="due-date" v-if="task.due_date">{{ formatDate(task.due_date) }}</text>
              <text class="priority" :class="'p' + task.priority">{{ getPriorityText(task.priority) }}</text>
            </view>
          </view>
        </view>
      </template>
      
      <!-- 加载状态 -->
      <view v-if="loading" class="loading">
        <text>加载中...</text>
      </view>
      
      <!-- 空状态 -->
      <view v-if="!loading && filteredTasks.length === 0" class="empty">
        <text>{{ selectedCategory ? '该分类下暂无任务' : '开始创建你的第一个任务' }}</text>
      </view>
    </view>

    <!-- 添加按钮 -->
    <view class="add-btn" @click="navigateToCreate">
      <text>+</text>
    </view>
  </view>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { taskApi, categoryApi } from '@/api'

const tasks = ref([])
const categories = ref([])
const selectedCategory = ref(null)
const loading = ref(false)
const page = ref(1)
const hasMore = ref(true)

// 统计数据
const completedCount = computed(() => 
  tasks.value.filter(task => task.completed).length
)
const pendingCount = computed(() => 
  tasks.value.filter(task => !task.completed).length
)

// 过滤和排序任务
const filteredTasks = computed(() => {
  let filtered = [...tasks.value]
  
  // 按分类筛选
  if (selectedCategory.value) {
    filtered = filtered.filter(task => task.category === selectedCategory.value)
  }
  
  // 排序规则：未完成 > 优先级 > 截止日期 > 创建时间
  return filtered.sort((a, b) => {
    if (a.completed !== b.completed) {
      return a.completed ? 1 : -1
    }
    if (a.priority !== b.priority) {
      return b.priority - a.priority
    }
    if (a.due_date && b.due_date) {
      return new Date(a.due_date) - new Date(b.due_date)
    }
    if (a.due_date) return -1
    if (b.due_date) return 1
    return new Date(b.created_at) - new Date(a.created_at)
  })
})

// 获取任务列表
const fetchTasks = async (reset = false) => {
  if (loading.value && !reset) return
  loading.value = true
  
  try {
    if (reset) {
      page.value = 1
      hasMore.value = true
    }
    
    if (!hasMore.value) return
    
    const res = await taskApi.getTasks({ page: page.value })
    // 处理任务的完成状态
    const processedTasks = res.results.map(task => ({
      ...task,
      completed: task.status === 'completed'
    }))
    
    if (reset) {
      tasks.value = processedTasks
    } else {
      tasks.value = [...tasks.value, ...processedTasks]
    }
    
    hasMore.value = !!res.next
    page.value++
  } catch (error) {
    uni.showToast({
      title: '获取任务失败',
      icon: 'none'
    })
  } finally {
    loading.value = false
    uni.stopPullDownRefresh()
  }
}

// 获取分类列表
const fetchCategories = async () => {
  try {
    const res = await categoryApi.getCategories()
    categories.value = res.results
  } catch (error) {
    uni.showToast({
      title: '获取分类失败',
      icon: 'none'
    })
  }
}

// 切换任务状态
const toggleTaskStatus = async (task) => {
  try {
    const newStatus = !task.completed
    // 乐观更新UI
    task.completed = newStatus

    // 发送请求到后端，包含所有必要字段
    await taskApi.updateTask(task.id, {
      title: task.title,
      description: task.description,
      category_id: task.category_id,
      priority: task.priority,
      due_date: task.due_date,
      status: newStatus ? 'completed' : 'pending'
    })
  } catch (error) {
    // 如果失败，回滚UI状态
    task.completed = !task.completed
    uni.showToast({
      title: '更新失败',
      icon: 'none'
    })
  }
}

// 页面跳转
const navigateToCreate = () => {
  uni.navigateTo({
    url: '/pages/task/create'
  })
}

const navigateToDetail = (taskId) => {
  uni.navigateTo({
    url: `/pages/task/detail?id=${taskId}`
  })
}

// 格式化日期
const formatDate = (date) => {
  if (!date) return ''
  const today = new Date().toLocaleDateString()
  const tomorrow = new Date(Date.now() + 86400000).toLocaleDateString()
  const taskDate = new Date(date).toLocaleDateString()
  
  if (taskDate === today) {
    return '今天'
  }
  if (taskDate === tomorrow) {
    return '明天'
  }
  return taskDate
}

// 获取优先级文本
const getPriorityText = (priority) => {
  const map = {
    1: '低',
    2: '中',
    3: '高'
  }
  return map[priority] || ''
}

// 页面生命周期
onMounted(() => {
  fetchTasks()
  fetchCategories()
})

// 页面下拉刷新
defineExpose({
  onPullDownRefresh() {
    Promise.all([
      fetchTasks(true),
      fetchCategories()
    ]).catch(() => {
      uni.stopPullDownRefresh()
    })
  }
})
</script>

<style lang="scss">
.container {
  min-height: 100vh;
  background-color: #ffffff;
  
  .categories {
    position: sticky;
    top: 0;
    z-index: 100;
    padding: 20rpx 0;
    background-color: #ffffff;
    border-bottom: 1rpx solid #f0f0f0;
    
    .category-list {
      display: flex;
      padding: 0 20rpx;
      
      .category-item {
        padding: 12rpx 32rpx;
        margin-right: 16rpx;
        font-size: 28rpx;
        color: #595959;
        background-color: #fafafa;
        border-radius: 32rpx;
        white-space: nowrap;
        transition: all 0.2s;
        
        &.active {
          color: #ffffff;
          background-color: #262626;
        }
        
        &:last-child {
          margin-right: 0;
        }
      }
    }
  }
  
  .task-list {
    padding: 20rpx;
    
    .task-item {
      display: flex;
      align-items: center;
      padding: 30rpx;
      margin-bottom: 20rpx;
      background-color: #ffffff;
      border-radius: 16rpx;
      box-shadow: 0 2rpx 8rpx rgba(0, 0, 0, 0.05);
      transition: all 0.2s;
      
      &:last-child {
        margin-bottom: 0;
      }
      
      &.completed {
        opacity: 0.7;
      }
      
      &:active {
        transform: scale(0.99);
        box-shadow: 0 1rpx 4rpx rgba(0, 0, 0, 0.03);
      }
      
      .checkbox {
        margin-right: 24rpx;
        transform: scale(0.9);
      }
      
      .content {
        flex: 1;
        
        .title {
          font-size: 32rpx;
          color: #262626;
          margin-bottom: 12rpx;
          transition: all 0.3s ease;
          line-height: 1.4;
          
          &.completed-text {
            text-decoration: line-through;
            color: #8c8c8c;
          }
        }
        
        .meta {
          display: flex;
          align-items: center;
          font-size: 24rpx;
          
          .due-date {
            color: #8c8c8c;
            margin-right: 16rpx;
          }
          
          .priority {
            padding: 4rpx 16rpx;
            border-radius: 4rpx;
            
            &.p1 {
              color: #52c41a;
              background-color: #f6ffed;
            }
            
            &.p2 {
              color: #faad14;
              background-color: #fff7e6;
            }
            
            &.p3 {
              color: #f5222d;
              background-color: #fff1f0;
            }
          }
        }
      }
    }
    
    .loading, .empty {
      padding: 40rpx;
      text-align: center;
      color: #8c8c8c;
      font-size: 28rpx;
    }
  }
  
  .add-btn {
    position: fixed;
    right: 40rpx;
    bottom: calc(140rpx + env(safe-area-inset-bottom));
    width: 96rpx;
    height: 96rpx;
    background-color: #262626;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    box-shadow: 0 8rpx 24rpx rgba(0, 0, 0, 0.15);
    transition: transform 0.2s;
    z-index: 100;
    
    &:active {
      transform: scale(0.95);
    }
    
    text {
      color: #ffffff;
      font-size: 48rpx;
      font-weight: 300;
    }
  }
}
</style>
