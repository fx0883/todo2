<template>
  <view class="calendar-page">


    <!-- 日历组件 -->
    <wu-calendar 
      type="week" 
      :insert="true"
      slideSwitchMode="horizontal" 
      @confirm="onConfirmCalendar" 
      @change="onChangeCalendar"
      :selected="[currentDate]"
    />

    <!-- 任务列表区域 -->
    <view class="tasks-section">
      <!-- 未完成任务 -->
      <view class="task-group" v-if="unfinishedTasks.length">
        <view class="group-header">
          <text class="title">待完成</text>
          <text class="count">{{ unfinishedTasks.length }}</text>
        </view>
        <view class="task-list">
          <view 
            v-for="task in unfinishedTasks" 
            :key="task.id"
            class="task-item"
            :class="{ 'is-important': task.is_important }"
            @tap="navigateToDetail(task.id)"
          >
            <view class="task-checkbox" @tap.stop="toggleTaskStatus(task)">
              <text class="checkbox" :class="{ 'checked': task.completed }"/>
            </view>
            <view class="task-content">
              <view class="task-main">
                <text class="task-title">{{ task.title }}</text>
                <view class="task-meta" v-if="task.due_date || task.category">
                  <text class="due-time" v-if="task.due_date">{{ formatTime(task.due_date) }}</text>
                  <text class="category" v-if="task.category">{{ task.category.name }}</text>
                </view>
              </view>
              <view class="task-priority" v-if="task.priority > 1">
                <text class="priority-tag" :class="'p' + task.priority">P{{ task.priority }}</text>
              </view>
            </view>
          </view>
        </view>
      </view>

      <!-- 已完成任务 -->
      <view class="task-group completed" v-if="finishedTasks.length">
        <view class="group-header">
          <text class="title">已完成</text>
          <text class="count">{{ finishedTasks.length }}</text>
        </view>
        <view class="task-list">
          <view 
            v-for="task in finishedTasks" 
            :key="task.id"
            class="task-item"
            @tap="navigateToDetail(task.id)"
          >
            <view class="task-checkbox" @tap.stop="toggleTaskStatus(task)">
              <text class="checkbox checked"/>
            </view>
            <view class="task-content">
              <text class="task-title">{{ task.title }}</text>
              <text class="complete-time" v-if="task.completed_at">{{ formatTime(task.completed_at) }}完成</text>
            </view>
          </view>
        </view>
      </view>

      <!-- 空状态优化 -->
      <view v-if="!unfinishedTasks.length && !finishedTasks.length" class="empty-state">

        <text class="empty-text">{{ isToday.value ? '今天暂无计划' : '该日期暂无计划' }}</text>
        <!-- <text class="sub-text">点击下方按钮添加任务</text> -->
      </view>
    </view>

    <!-- 添加任务按钮 -->
    <view class="add-btn" @tap="showQuickAddModal">
      <text class="icon">+</text>
    </view>
  </view>
</template>

<script setup>
import { ref, computed, onMounted, onActivated } from 'vue'
import { useCalendar } from '@/composables/useCalendar'
import { formatDateTime, isSameDay } from '@/utils/dateTime'

const {
  currentDate,
  tasks,
  loading,
  fetchCalendarTasks,
  updateTaskDate,
  quickAddTask,
  changeDate,
  updateTaskStatus
} = useCalendar()

// 获取今天日期
const today = new Date()

// 计算未完成任务
const unfinishedTasks = computed(() => {
  return tasks.value.filter(task => !task.completed)
})

// 计算已完成任务
const finishedTasks = computed(() => {
  return tasks.value.filter(task => task.completed)
})

// 格式化时间
const formatTime = (dateStr) => {
  if (!dateStr) return ''
  return formatDateTime(new Date(dateStr), 'HH:mm')
}

// 判断是否是今天
const isToday = computed(() => {
  return isSameDay(currentDate.value, today)
})

// 切换任务状态
const toggleTaskStatus = async (task) => {
  try {
    await updateTaskStatus(task.id, !task.completed)
    // 状态更新后会自动刷新任务列表
  } catch (error) {
    uni.showToast({
      title: '更新任务状态失败',
      icon: 'none'
    })
  }
}

// 日历确认事件
const onConfirmCalendar = (e) => {
  const selectedDate = new Date(e.fulldate)
  // currentDate.value = selectedDate;
  changeDate(selectedDate)
}

// 日历变化事件
const onChangeCalendar = (e) => {
  const selectedDate = new Date(e.fulldate)
  // currentDate.value = selectedDate;
  changeDate(selectedDate)
}

// 跳转到任务详情
const navigateToDetail = (taskId) => {
  uni.navigateTo({
    url: `/pages/task/detail?id=${taskId}`
  })
}

// 显示快速添加任务弹窗
const showQuickAddModal = () => {
  uni.navigateTo({
    url: '/pages/task/create'
  })
}

// let curDate = ref(new Date())

// 页面加载时获取今天的任务
onMounted(() => {
  // 设置当前日期为今天
  changeDate(new Date(new Date().getTime()))
})

onActivated(() => {
  changeDate(new Date(currentDate.value))
})
</script>

<style lang="scss">
.calendar-page {
  min-height: 100vh;
  background: #f8f9fa;
  
  .tasks-section {
    padding: 20rpx;
  }
  
  .task-group {
    margin-bottom: 30rpx;
    background: #fff;
    border-radius: 12rpx;
    box-shadow: 0 2rpx 12rpx rgba(0, 0, 0, 0.05);
    
    &.completed {
      opacity: 0.8;
    }
    
    .group-header {
      display: flex;
      align-items: center;
      padding: 20rpx;
      border-bottom: 1rpx solid #eee;
      
      .title {
        font-size: 28rpx;
        font-weight: 500;
        color: #333;
      }
      
      .count {
        margin-left: 12rpx;
        font-size: 24rpx;
        color: #999;
      }
    }
  }
  
  .task-item {
    display: flex;
    align-items: center;
    padding: 24rpx 20rpx;
    border-bottom: 1rpx solid #f5f5f5;
    
    &:last-child {
      border-bottom: none;
    }
    
    &.is-important {
      background: rgba(255, 82, 82, 0.05);
    }
    
    .task-checkbox {
      margin-right: 16rpx;
      
      .checkbox {
        display: block;
        width: 36rpx;
        height: 36rpx;
        border: 2rpx solid #ddd;
        border-radius: 50%;
        
        &.checked {
          background: #4CAF50;
          border-color: #4CAF50;
          position: relative;
          
          &::after {
            content: '';
            position: absolute;
            left: 12rpx;
            top: 6rpx;
            width: 8rpx;
            height: 16rpx;
            border: solid white;
            border-width: 0 2rpx 2rpx 0;
            transform: rotate(45deg);
          }
        }
      }
    }
    
    .task-content {
      flex: 1;
      display: flex;
      align-items: center;
      justify-content: space-between;
      
      .task-main {
        flex: 1;
      }
      
      .task-title {
        font-size: 28rpx;
        color: #333;
        margin-bottom: 8rpx;
      }
      
      .task-meta {
        display: flex;
        align-items: center;
        font-size: 24rpx;
        color: #999;
        
        .due-time {
          margin-right: 16rpx;
        }
        
        .category {
          background: #f5f5f5;
          padding: 4rpx 12rpx;
          border-radius: 20rpx;
        }
      }
      
      .priority-tag {
        font-size: 22rpx;
        padding: 4rpx 12rpx;
        border-radius: 4rpx;
        
        &.p2 {
          background: #FFF3E0;
          color: #FF9800;
        }
        
        &.p3 {
          background: #FFEBEE;
          color: #F44336;
        }
      }
      
      .complete-time {
        font-size: 24rpx;
        color: #999;
      }
    }
  }
  
  .empty-state {
    padding: 60rpx 0;
    text-align: center;
    
    image {
      width: 240rpx;
      height: 240rpx;
      margin-bottom: 20rpx;
    }
    
    .empty-text {
      font-size: 28rpx;
      color: #666;
      margin-bottom: 12rpx;
    }
    
    .sub-text {
      font-size: 24rpx;
      color: #999;
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
