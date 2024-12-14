<template>
  <view class="calendar-view">
    <!-- 星期标题行 -->
    <view class="week-header">
      <text v-for="day in weekDays" :key="day" class="week-day">{{ day }}</text>
    </view>
    
    <!-- 日历网格 -->
    <view class="calendar-grid">
      <view 
        v-for="(date, index) in calendarDates" 
        :key="index"
        class="date-cell"
        :class="{
          'current-month': date.currentMonth,
          'today': isToday(date.date),
          'selected': isSelected(date.date)
        }"
        @click="onDateClick(date)"
      >
        <!-- 日期 -->
        <text class="date-number">{{ date.date.getDate() }}</text>
        
        <!-- 任务列表 -->
        <view class="task-list">
          <view 
            v-for="task in getDateTasks(date.date)" 
            :key="task.id"
            class="task-item"
            :class="task.status"
            :draggable="true"
            @dragstart="onDragStart($event, task)"
            @dragend="onDragEnd"
            @click.stop="onTaskClick(task)"
          >
            <text class="task-title">{{ task.title }}</text>
          </view>
        </view>
      </view>
    </view>
  </view>
</template>

<script setup>
import { computed, ref } from 'vue'

const props = defineProps({
  type: {
    type: String,
    default: 'month'
  },
  date: {
    type: Date,
    required: true
  },
  tasks: {
    type: Array,
    default: () => []
  }
})

const emit = defineEmits(['date-click', 'task-drop', 'task-click'])

const weekDays = ['日', '一', '二', '三', '四', '五', '六']
const draggedTask = ref(null)

// 计算日历日期
const calendarDates = computed(() => {
  const dates = []
  const firstDay = new Date(props.date.getFullYear(), props.date.getMonth(), 1)
  const lastDay = new Date(props.date.getFullYear(), props.date.getMonth() + 1, 0)
  
  // 填充上个月的日期
  const firstDayWeek = firstDay.getDay()
  for (let i = firstDayWeek - 1; i >= 0; i--) {
    const date = new Date(firstDay)
    date.setDate(date.getDate() - i)
    dates.push({
      date,
      currentMonth: false
    })
  }
  
  // 当月日期
  for (let i = 1; i <= lastDay.getDate(); i++) {
    dates.push({
      date: new Date(props.date.getFullYear(), props.date.getMonth(), i),
      currentMonth: true
    })
  }
  
  // 填充下个月的日期
  const remainingDays = 42 - dates.length // 6行7列
  for (let i = 1; i <= remainingDays; i++) {
    const date = new Date(lastDay)
    date.setDate(date.getDate() + i)
    dates.push({
      date,
      currentMonth: false
    })
  }
  
  return dates
})

// 获取指定日期的任务
const getDateTasks = (date) => {
  return props.tasks.filter(task => {
    const taskDate = new Date(task.due_date)
    return taskDate.toDateString() === date.toDateString()
  })
}

// 检查是否是今天
const isToday = (date) => {
  const today = new Date()
  return date.toDateString() === today.toDateString()
}

// 检查是否是选中日期
const isSelected = (date) => {
  return date.toDateString() === props.date.toDateString()
}

// 拖拽开始
const onDragStart = (event, task) => {
  draggedTask.value = task
  event.dataTransfer.setData('text/plain', task.id)
}

// 拖拽结束
const onDragEnd = () => {
  draggedTask.value = null
}

// 日期点击
const onDateClick = (dateInfo) => {
  emit('date-click', dateInfo.date)
}

// 任务点击
const onTaskClick = (task) => {
  emit('task-click', task)
}

// 放置处理
const onDrop = (event, date) => {
  event.preventDefault()
  if (draggedTask.value) {
    emit('task-drop', draggedTask.value.id, date)
  }
}
</script>

<style lang="scss" scoped>
.calendar-view {
  background: #fff;
  border-radius: 12rpx;
  overflow: hidden;
  
  .week-header {
    display: grid;
    grid-template-columns: repeat(7, 1fr);
    padding: 20rpx 0;
    background: #f5f5f5;
    
    .week-day {
      text-align: center;
      font-size: 28rpx;
      color: #666;
    }
  }
  
  .calendar-grid {
    display: grid;
    grid-template-columns: repeat(7, 1fr);
    grid-auto-rows: minmax(180rpx, auto);
    
    .date-cell {
      border: 1rpx solid #eee;
      padding: 10rpx;
      position: relative;
      
      &.current-month {
        background: #fff;
      }
      
      &.today {
        .date-number {
          background: #007AFF;
          color: #fff;
        }
      }
      
      &.selected {
        background: rgba(0, 122, 255, 0.1);
      }
      
      .date-number {
        display: inline-block;
        width: 50rpx;
        height: 50rpx;
        line-height: 50rpx;
        text-align: center;
        border-radius: 50%;
        font-size: 24rpx;
        color: #333;
      }
      
      .task-list {
        margin-top: 10rpx;
        
        .task-item {
          margin-bottom: 6rpx;
          padding: 4rpx 8rpx;
          border-radius: 4rpx;
          font-size: 20rpx;
          color: #fff;
          white-space: nowrap;
          overflow: hidden;
          text-overflow: ellipsis;
          cursor: move;
          
          &.pending {
            background: #1890ff;
          }
          
          &.completed {
            background: #52c41a;
          }
          
          &.overdue {
            background: #ff4d4f;
          }
        }
      }
    }
  }
}
</style> 