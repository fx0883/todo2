<template>
  <view class="calendar-container">
    <!-- 日历组件 -->
    <view class="calendar-wrapper">
      <uni-calendar 
        :selected="selected"
        :showMonth="false"
        @change="handleDateChange"
      />
    </view>
    
    <!-- 当日任务列表 -->
    <view class="tasks-wrapper">
      <view class="date-header">
        <text class="date">{{ formatDate(currentDate, 'MM月DD日') }}</text>
        <text class="count">{{ dayTasks.length }}个任务</text>
      </view>
      
      <view v-if="dayTasks.length" class="task-list">
        <view 
          v-for="task in dayTasks" 
          :key="task.id" 
          class="task-item"
          @click="navigateToDetail(task.id)"
        >
          <view class="task-status">
            <view 
              class="status-dot"
              :class="task.status"
            ></view>
          </view>
          
          <view class="task-content">
            <text class="task-title">{{ task.title }}</text>
            <view class="task-info">
              <text class="time">{{ formatDate(task.due_date, 'HH:mm') }}</text>
              <text 
                class="priority"
                :class="task.priority"
              >
                {{ priorityText[task.priority] }}
              </text>
            </view>
          </view>
        </view>
      </view>
      
      <view v-else class="empty-tip">
        <text>当日暂无任务</text>
      </view>
    </view>
    
    <!-- 添加任务按钮 -->
    <view class="add-task">
      <button 
        class="add-btn"
        @click="handleAddTask"
      >
        添加任务
      </button>
    </view>
  </view>
</template>

<script setup>
import { ref, computed } from 'vue'
import { useTaskStore } from '@/store/task'
import { formatDate } from '@/utils/date'

const taskStore = useTaskStore()
const currentDate = ref(new Date())
const selected = ref([])

// 优先级文本
const priorityText = {
  low: '低优先级',
  medium: '中优先级',
  high: '高优先级'
}

// 获取当日任务
const dayTasks = computed(() => {
  const date = formatDate(currentDate.value, 'YYYY-MM-DD')
  return taskStore.tasks.filter(task => {
    return formatDate(task.due_date, 'YYYY-MM-DD') === date
  }).sort((a, b) => {
    // 按时间排序
    return new Date(a.due_date) - new Date(b.due_date)
  })
})

// 日期变更
const handleDateChange = (e) => {
  currentDate.value = new Date(e.fulldate)
  selected.value = [e.fulldate]
}

// 跳转到任务详情
const navigateToDetail = (taskId) => {
  uni.navigateTo({
    url: `/pages/task/detail?id=${taskId}`
  })
}

// 添加任务
const handleAddTask = () => {
  uni.navigateTo({
    url: `/pages/task/create?date=${formatDate(currentDate.value, 'YYYY-MM-DD')}`
  })
}
</script>

<style lang="scss">
.calendar-container {
  min-height: 100vh;
  background-color: #f5f5f5;
  
  .calendar-wrapper {
    background-color: #fff;
    padding: 20rpx;
    margin-bottom: 20rpx;
  }
  
  .tasks-wrapper {
    background-color: #fff;
    padding: 30rpx;
    min-height: 400rpx;
    
    .date-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 30rpx;
      
      .date {
        font-size: 32rpx;
        font-weight: bold;
        color: #333;
      }
      
      .count {
        font-size: 28rpx;
        color: #666;
      }
    }
    
    .task-list {
      .task-item {
        display: flex;
        align-items: center;
        padding: 20rpx 0;
        border-bottom: 2rpx solid #f5f5f5;
        
        &:last-child {
          border-bottom: none;
        }
        
        .task-status {
          margin-right: 20rpx;
          
          .status-dot {
            width: 24rpx;
            height: 24rpx;
            border-radius: 50%;
            
            &.pending {
              background-color: #1890ff;
            }
            
            &.completed {
              background-color: #52c41a;
            }
            
            &.overdue {
              background-color: #ff4d4f;
            }
          }
        }
        
        .task-content {
          flex: 1;
          
          .task-title {
            font-size: 30rpx;
            color: #333;
            margin-bottom: 10rpx;
          }
          
          .task-info {
            display: flex;
            align-items: center;
            gap: 20rpx;
            
            .time {
              font-size: 26rpx;
              color: #666;
            }
            
            .priority {
              font-size: 24rpx;
              padding: 4rpx 12rpx;
              border-radius: 20rpx;
              
              &.high {
                background-color: #fff1f0;
                color: #ff4d4f;
              }
              
              &.medium {
                background-color: #fff7e6;
                color: #faad14;
              }
              
              &.low {
                background-color: #f6ffed;
                color: #52c41a;
              }
            }
          }
        }
      }
    }
    
    .empty-tip {
      text-align: center;
      padding: 60rpx 0;
      color: #999;
      font-size: 28rpx;
    }
  }
  
  .add-task {
    position: fixed;
    bottom: 120rpx;
    left: 0;
    right: 0;
    padding: 0 30rpx;
    
    .add-btn {
      width: 100%;
      height: 90rpx;
      line-height: 90rpx;
      background-color: #007AFF;
      color: #fff;
      border-radius: 45rpx;
      font-size: 32rpx;
    }
  }
}
</style>
