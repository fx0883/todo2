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

    <!-- 任务列表区域 -->
    <scroll-view 
      class="task-list-container"
      scroll-y 
      refresher-enabled
      :refresher-triggered="refreshing"
      @refresherrefresh="onRefresh"
      @scrolltolower="onLoadMore"
    >
      <!-- 加载状态 -->
      <view v-if="loading" class="loading">
        <text>加载中...</text>
      </view>
      
      <!-- 任务列表内容 -->
      <template v-else-if="filteredTasks && filteredTasks.length > 0">
        <view class="task-list">
          <view 
            v-for="task in filteredTasks" 
            :key="task.id" 
            class="task-item"
            :class="[
              { completed: task.status === 'completed' },
              `p${task.priority}`
            ]"
            @click="navigateToDetail(task.id)"
          >
            <checkbox 
              :checked="task.status === 'completed'" 
              @tap.stop="toggleTaskStatus(task.id)"
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
        </view>
      </template>
      
      <!-- 加载更多状态 -->
      <view class="loading-more" v-if="loading">
        <uni-load-more status="loading" />
      </view>
      
      <!-- 无更多数据 -->
      <view v-if="!hasMore && filteredTasks.length > 0" class="no-more">
        <uni-load-more status="noMore" />
      </view>

      <!-- 空状态 -->
<!--      <view v-else-if="!filteredTasks.length" class="empty">
        <text>{{ selectedCategory ? '该分类下暂无任务' : '开始创建你的第一个任务' }}</text>
      </view> -->
    </scroll-view>

    <!-- 添加按钮 -->
    <view class="add-btn" @click="navigateToCreate">
      <text>+</text>
    </view>
  </view>
</template>

<script setup>
import { ref, computed, onMounted, onActivated } from 'vue'
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
  getPriorityText,
  hasMore,
  loadMore,
  refreshList
} = useTask()

const { fetchCategories } = useCategory()

// 使用 store 中的状态
const taskStore = useTaskStore()
const categoryStore = useCategoryStore()
const { tasks, loading } = storeToRefs(taskStore)
const { categories } = storeToRefs(categoryStore)
const selectedCategory = ref(null)

// 添加 refreshing ref
const refreshing = ref(false)

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
	await freshAllData()
})


onActivated(async () => {
	await freshAllData()
})

const freshAllData = async () => {
	try {
	  // 分开调用，单独处理每个请求的错误
	  try {
	    await refreshList()
	  } catch (err) {
	    // 401 错误不需要显示错误提示
	    if (err.statusCode !== 401) {
	      console.error('Failed to load tasks:', err)
	    }
	  }
	
	  try {
	    await fetchCategories()
	  } catch (err) {
	    if (err.statusCode !== 401) {
	      console.error('Failed to load categories:', err)
	    }
	  }
	} catch (err) {
	  console.error('Failed to load initial data:', err)
	}
}

// 下拉刷新
const onRefresh = async () => {
  refreshing.value = true
  try {
	await freshAllData()
  } finally {
    refreshing.value = false
  }
}

// 上拉加载更多
const onLoadMore = async () => {
  await loadMore()
}


</script>

<style lang="scss">
.container {
  min-height: 100vh;
  background-color: #ffffff;
  
  .categories {
    position: fixed;
    z-index:999;
    background-color: #ffffff;
    padding: 24rpx 0;
    border-bottom: 1rpx solid #f0f0f0;
    
    .category-list {
      display: flex;
	  z-index: 999;
	  height: 72rpx;
      padding: 0 20rpx;
	  top: calc(var(--window-top));
      
      .category-item {
        padding: 16rpx 32rpx;
        margin-right: 16rpx;
        font-size: 28rpx;
        color: #8c8c8c;
        background-color: #f5f5f5;
        border-radius: 32rpx;
        white-space: nowrap;
        transition: all 0.3s ease;
        border: 2rpx solid transparent;
        
        &.active {
          color: #ffffff;
          background-color: #007AFF;
          box-shadow: 0 4rpx 12rpx rgba(0, 122, 255, 0.2);
        }
        
        &:not(.active):hover {
          color: #007AFF;
          border-color: #007AFF;
          background-color: rgba(0, 122, 255, 0.05);
        }
        
        &:last-child {
          margin-right: 0;
        }
      }
    }
  }
  
  .task-list-container {
	  position: fixed;
	     margin-top: 105rpx;
    flex: 1;
    height: calc(100vh - 100rpx);
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
      box-shadow: 0 2rpx 12rpx rgba(0, 0, 0, 0.08);
      border-left: 8rpx solid transparent;
      transition: all 0.2s;
      
      &:last-child {
        margin-bottom: 0;
      }
      
      &.completed {
        opacity: 0.6;
        background-color: #f8f8f8;
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
              color: #34C759;
              background-color: rgba(52, 199, 89, 0.1);
            }
            
            &.p2 {
              color: #FF9500;
              background-color: rgba(255, 149, 0, 0.1);
            }
            
            &.p3 {
              color: #FF3B30;
              background-color: rgba(255, 59, 48, 0.1);
            }
          }
        }
      }
      
      // 优先级边框颜色
      &.p1 {
        border-left-color: #34C759;  // 低优先级
      }
      &.p2 {
        border-left-color: #FF9500;  // 中优先级
      }
      &.p3 {
        border-left-color: #FF3B30;  // 高优先级
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
    /* #ifdef H5 */
    bottom: 40rpx;
    /* #endif */
    /* #ifdef MP */
    bottom: 140rpx;
    /* #endif */
    width: 96rpx;
    height: 96rpx;
    background-color: #007AFF;
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
  
  .loading-more,
  .no-more {
    padding: 20rpx 0;
    text-align: center;
  }
}
</style>
