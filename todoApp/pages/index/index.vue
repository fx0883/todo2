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
          v-for="category in categories || []" 
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
      <!-- 加载状态 -->
      <view v-if="loading" class="loading">
        <text>加载中...</text>
      </view>
      
      <!-- 任务列表内容 -->
      <template v-else-if="filteredTasks && filteredTasks.length > 0">
        <view 
          v-for="task in filteredTasks" 
          :key="task.id" 
          class="task-item"
          :class="{ completed: task.status === 'completed' }"
          @click="navigateToDetail(task.id)"
        >
          <checkbox 
            :checked="task.status === 'completed'" 
            @tap.stop="toggleTaskStatus(task)"
            class="checkbox"
          />
          <view class="content">
            <text class="title" :class="{ 'completed-text': task.status === 'completed' }">{{ task.title }}</text>
            <view class="meta">
              <text class="due-date" v-if="task.due_date">{{ formatDate(task.due_date) }}</text>
              <text class="priority" :class="'p' + task.priority">{{ getPriorityText(task.priority) }}</text>
            </view>
          </view>
        </view>
      </template>
      
      <!-- 空状态 -->
      <view v-else class="empty">
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
import { onPullDownRefresh } from '@dcloudio/uni-app'
import { useTask } from '@/composables/useTask'
import { useCategory } from '@/composables/useCategory'
import { useTaskStore } from '@/store/modules/task'
import { useCategoryStore } from '@/store/modules/category'
import { storeToRefs } from 'pinia'

// 使用 composables
const { 
  fetchTasks, 
  toggleTaskStatus,
  formatDate,
  getPriorityText
} = useTask()

const { fetchCategories } = useCategory()

// 使用 store 中的状态
const taskStore = useTaskStore()
const categoryStore = useCategoryStore()
const { tasks, loading } = storeToRefs(taskStore)
const { categories } = storeToRefs(categoryStore)
const selectedCategory = ref(null)

// 统计数据 - 直接从 tasks 计算，不再调用 API
const completedCount = computed(() => {
  if (!Array.isArray(tasks.value)) return 0
  return tasks.value.filter(task => task.status === 'completed').length || 0
})

const pendingCount = computed(() => {
  if (!Array.isArray(tasks.value)) return 0
  return tasks.value.filter(task => task.status === 'pending').length || 0
})

// 过滤和排序任务
const filteredTasks = computed(() => {
  if (!Array.isArray(tasks.value)) return []
  
  let filtered = [...tasks.value]
  
  // 按分类筛选
  if (selectedCategory.value) {
    filtered = filtered.filter(task => task.category === selectedCategory.value)
  }
  
  // 排序：未完成的任务优先，然后按创建时间倒序
  return filtered.sort((a, b) => {
    if (a.status !== b.status) {
      return a.status === 'completed' ? 1 : -1
    }
    return new Date(b.createdAt) - new Date(a.createdAt)
  })
})

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

// 页面生命周期
onMounted(async () => {
  try {
    await Promise.all([
      fetchTasks(),
      fetchCategories()
    ])
  } catch (error) {
    console.error('Failed to load initial data:', error)
    uni.showToast({
      title: '加载失败',
      icon: 'none'
    })
  }
})

// 下拉刷新
onPullDownRefresh(async () => {
  try {
    await Promise.all([
      fetchTasks(),
      fetchCategories()
    ])
  } catch (error) {
    console.error('Failed to refresh data:', error)
    uni.showToast({
      title: '刷新失败',
      icon: 'none'
    })
  } finally {
    uni.stopPullDownRefresh()
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
