<template>
  <view class="calendar-page">
    <!-- 顶部日期导航 -->
    <view class="date-header">
      <text class="date-text">{{ formatYearMonth(currentDate) }} ▼</text>
      <view class="header-right">
        <text class="today-btn" @tap="goToday">今天</text>
        <text class="time-axis-btn" @tap="toggleTimeAxis">
          时间轴
          <text class="icon">🕒</text>
        </text>
      </view>
    </view>

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
          <text class="title">未完成</text>
          <text class="count">{{ unfinishedTasks.length }}</text>
        </view>
        <view class="task-list">
          <view 
            v-for="task in unfinishedTasks" 
            :key="task.id"
            class="task-item"
            @tap="navigateToDetail(task.id)"
          >
            <view class="task-icon">
              <image :src="task.icon || '/static/icons/default-task.png'" mode="aspectFit"/>
            </view>
            <view class="task-content">
              <text class="task-title">{{ task.title }}</text>
              <text class="task-progress">{{ task.progress || '0/1次' }}</text>
            </view>
          </view>
        </view>
      </view>

      <!-- 已完成任务 -->
      <view class="task-group" v-if="finishedTasks.length">
        <view class="group-header">
          <text class="title">已完成</text>
          <text class="count">{{ finishedTasks.length }}</text>
        </view>
        <view class="task-list">
          <view 
            v-for="task in finishedTasks" 
            :key="task.id"
            class="task-item completed"
            @tap="navigateToDetail(task.id)"
          >
            <view class="task-icon">
              <image :src="task.icon || '/static/icons/default-task.png'" mode="aspectFit"/>
            </view>
            <view class="task-content">
              <text class="task-title">{{ task.title }}</text>
              <text class="task-progress">{{ task.progress }}</text>
            </view>
          </view>
        </view>
      </view>

      <!-- 空状态 -->
      <view v-if="!unfinishedTasks.length && !finishedTasks.length" class="empty-state">
        <image src="/static/images/empty-calendar.png" mode="aspectFit"/>
        <text>暂无已完成计划</text>
        <text class="sub-text">快来制定你的自律之路吧</text>
      </view>
    </view>

    <!-- 添加任务按钮 -->
    <view class="add-btn" @tap="showQuickAddModal">
      <text class="icon">+</text>
    </view>
  </view>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useCalendar } from '@/composables/useCalendar'

const {
  currentDate,
  tasks,
  loading,
  fetchCalendarTasks,
  updateTaskDate,
  quickAddTask,
  changeDate
} = useCalendar()

// 格式化年月
const formatYearMonth = (date) => {
  return `${date.getFullYear()}年${date.getMonth() + 1}月`
}

// 跳转到今天
const goToday = () => {
  changeDate(new Date())
}

// 切换时间轴视图
const toggleTimeAxis = () => {
  // TODO: 实现时间轴视图切换
}

// 计算未完成任务
const unfinishedTasks = computed(() => {
  return tasks.value.filter(task => !task.completed)
})

// 计算已完成任务
const finishedTasks = computed(() => {
  return tasks.value.filter(task => task.completed)
})

// 日历确认事件
const onConfirmCalendar = (e) => {
  const date = new Date(e.fulldate)
  changeDate(date)
}

// 日历变化事件
const onChangeCalendar = (e) => {
  const date = new Date(e.fulldate)
  changeDate(date)
}

// 跳转到任务详情
const navigateToDetail = (taskId) => {
  uni.navigateTo({
    url: `/pages/task/detail?id=${taskId}`
  })
}

// 显示快速添加任务弹窗
const showQuickAddModal = () => {
  // TODO: 实现快速添加任务弹窗
}

// 页面加载时获取今天的任务
onMounted(() => {
  fetchCalendarTasks()
})
</script>

<style lang="scss">
.calendar-page {
  min-height: 100vh;
  background: #f5f5f5;
  display: flex;
  flex-direction: column;

  .date-header {
    padding: 30rpx;
    background: #fff;
    display: flex;
    justify-content: space-between;
    align-items: center;
    
    .date-text {
      font-size: 34rpx;
      font-weight: bold;
      color: #333;
    }
    
    .header-right {
      display: flex;
      align-items: center;
      gap: 20rpx;
      
      .today-btn,
      .time-axis-btn {
        padding: 10rpx 20rpx;
        border-radius: 30rpx;
        font-size: 28rpx;
        color: #666;
        background: #f5f5f5;
        
        .icon {
          margin-left: 6rpx;
        }
      }
    }
  }

  .tasks-section {
    flex: 1;
    padding: 0 30rpx;
    
    .task-group {
      margin-bottom: 40rpx;
      
      .group-header {
        display: flex;
        align-items: center;
        margin-bottom: 20rpx;
        
        .title {
          font-size: 32rpx;
          color: #333;
          font-weight: bold;
        }
        
        .count {
          margin-left: 20rpx;
          font-size: 28rpx;
          color: #999;
        }
      }
      
      .task-list {
        .task-item {
          display: flex;
          align-items: center;
          padding: 20rpx;
          background: #fff;
          border-radius: 12rpx;
          margin-bottom: 20rpx;
          
          .task-icon {
            width: 80rpx;
            height: 80rpx;
            margin-right: 20rpx;
            
            image {
              width: 100%;
              height: 100%;
            }
          }
          
          .task-content {
            flex: 1;
            
            .task-title {
              font-size: 30rpx;
              color: #333;
              margin-bottom: 10rpx;
            }
            
            .task-progress {
              font-size: 26rpx;
              color: #999;
            }
          }
          
          &.completed {
            opacity: 0.6;
          }
        }
      }
    }
    
    .empty-state {
      padding: 100rpx 0;
      text-align: center;
      
      image {
        width: 300rpx;
        height: 300rpx;
        margin-bottom: 30rpx;
      }
      
      text {
        display: block;
        font-size: 32rpx;
        color: #999;
        margin-bottom: 10rpx;
      }
      
      .sub-text {
        font-size: 28rpx;
        color: #ccc;
      }
    }
  }

  .add-btn {
    position: fixed;
    right: 40rpx;
    bottom: 40rpx;
    width: 100rpx;
    height: 100rpx;
    border-radius: 50%;
    background: #007AFF;
    color: #fff;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 50rpx;
    box-shadow: 0 4rpx 12rpx rgba(0, 122, 255, 0.4);
  }
}
</style>
