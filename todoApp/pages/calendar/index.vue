<template>
  <view class="calendar-page">
    <!-- 顶部导航栏 -->
    <view class="calendar-header">
      <view class="view-switcher">
        <text 
          v-for="type in viewTypes" 
          :key="type.value"
          :class="['view-type', { active: viewType === type.value }]"
          @tap="changeViewType(type.value)"
        >
          {{ type.label }}
        </text>
      </view>
      
      <view class="date-navigator">
        <text class="icon" @tap="navigateDate('prev')">←</text>
        <text class="current-date">{{ formatDate(currentDate) }}</text>
        <text class="icon" @tap="navigateDate('next')">→</text>
      </view>
    </view>

    <!-- 日历主体 -->
    <view class="calendar-body">
      <calendar-view
        :type="viewType"
        :date="currentDate"
        :tasks="tasks"
        @date-click="onDateClick"
        @task-drop="onTaskDrop"
      />
    </view>

    <!-- 快速添加任务按钮 -->
    <view class="quick-add-btn" @tap="showQuickAddModal">
      <text class="icon">+</text>
    </view>

    <!-- 快速添加任务弹窗 -->
    <uni-popup ref="quickAddPopup" type="bottom">
      <view class="quick-add-form">
        <input 
          v-model="newTask.title"
          placeholder="输入任务标题"
          @confirm="submitQuickAdd"
        />
        <button @tap="submitQuickAdd">添加</button>
      </view>
    </uni-popup>
  </view>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useCalendar } from '@/composables/useCalendar'

const {
  viewType,
  currentDate,
  tasks,
  loading,
  fetchCalendarTasks,
  updateTaskDate,
  quickAddTask,
  changeViewType,
  changeDate
} = useCalendar()

const quickAddPopup = ref(null)
const newTask = ref({ title: '', date: null })

const viewTypes = [
  { label: '月', value: 'month' },
  { label: '周', value: 'week' },
  { label: '日', value: 'day' }
]

// 格式化日期显示
const formatDate = (date) => {
  return date.toLocaleDateString('zh-CN', {
    year: 'numeric',
    month: 'long',
    day: 'numeric'
  })
}

// 日期导航
const navigateDate = (direction) => {
  const newDate = new Date(currentDate.value)
  switch (viewType.value) {
    case 'day':
      newDate.setDate(newDate.getDate() + (direction === 'next' ? 1 : -1))
      break
    case 'week':
      newDate.setDate(newDate.getDate() + (direction === 'next' ? 7 : -7))
      break
    case 'month':
      newDate.setMonth(newDate.getMonth() + (direction === 'next' ? 1 : -1))
      break
  }
  changeDate(newDate)
}

// 日期点击处理
const onDateClick = (date) => {
  newTask.value.date = date
  quickAddPopup.value.open()
}

// 任务拖拽处理
const onTaskDrop = async (taskId, newDate) => {
  await updateTaskDate(taskId, newDate)
}

// 提交快速添加任务
const submitQuickAdd = async () => {
  if (!newTask.value.title || !newTask.value.date) return
  
  await quickAddTask(newTask.value.title, newTask.value.date)
  newTask.value = { title: '', date: null }
  quickAddPopup.value.close()
}

onMounted(() => {
  fetchCalendarTasks()
})
</script>

<style lang="scss">
.calendar-page {
  height: 100vh;
  display: flex;
  flex-direction: column;
  
  .calendar-header {
    padding: 20rpx;
    display: flex;
    justify-content: space-between;
    align-items: center;
    
    .view-switcher {
      display: flex;
      gap: 20rpx;
      
      .view-type {
        padding: 10rpx 20rpx;
        border-radius: 8rpx;
        
        &.active {
          background-color: #007AFF;
          color: #fff;
        }
      }
    }
    
    .date-navigator {
      display: flex;
      align-items: center;
      gap: 20rpx;
      
      .icon {
        padding: 10rpx;
        cursor: pointer;
      }
    }
  }
  
  .calendar-body {
    flex: 1;
    overflow: auto;
  }
  
  .quick-add-btn {
    position: fixed;
    right: 40rpx;
    bottom: 40rpx;
    width: 100rpx;
    height: 100rpx;
    border-radius: 50%;
    background-color: #007AFF;
    color: #fff;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 40rpx;
    box-shadow: 0 4rpx 12rpx rgba(0,0,0,0.15);
  }
  
  .quick-add-form {
    padding: 40rpx;
    background-color: #fff;
    border-radius: 20rpx 20rpx 0 0;
    
    input {
      margin-bottom: 20rpx;
      padding: 20rpx;
      border: 2rpx solid #eee;
      border-radius: 8rpx;
    }
  }
}
</style>
