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

			<!-- 任务列表内容 -->
			<template v-if="filteredTasks && filteredTasks.length > 0">
				<view class="task-list">
					<view v-for="task in filteredTasks" :key="task.id" class="task-item" :class="[
              { completed: task.status === 'completed' },
              `p${task.priority}`
            ]" @click="navigateToDetail(task.id)">
						<checkbox :checked="task.status === 'completed'" @tap.stop="toggleTaskStatus(task.id)"
							class="checkbox" />
						<view class="content">
							<text class="title"
								:class="{ 'completed-text': task.status === 'completed' }">{{ task.title }}</text>
							<view class="meta">
								<!-- <text class="due-date" v-if="task.due_date">{{ formatDate(task.due_date) }}</text> -->
								<text class="priority"
									:class="'p' + task.priority">{{ getPriorityText(task.priority) }}</text>
							</view>
						</view>
					</view>
				</view>
			</template>
    <!-- 添加任务按钮 -->
    <view class="add-btn" @tap="showQuickAddModal">
      <text class="icon">+</text>
    </view>
	
  </view>
</template>

<script setup>
import { ref, computed, onMounted, onActivated } from 'vue'
	import {
		onLoad,
		onPageScroll,
		onPullDownRefresh,
		onReachBottom,
		onShow
	} from '@dcloudio/uni-app';
import { useCalendar } from '@/composables/useCalendar'
import { formatDateTime, isSameDay } from '@/utils/dateTime'
import { getPriorityText } from '@/utils/task'
	import {
		useTaskStore
	} from '@/store/modules/task'
	
	import {
		storeToRefs
	} from 'pinia'
const {
  currentDate,
  fetchCalendarTasks,
  updateTaskDate,
  quickAddTask,
  changeDate,
  updateTaskStatus,
  toggleTaskStatus
} = useCalendar()

const taskStore = useTaskStore()
const {
	calendarTasks,
	loading
} = storeToRefs(taskStore)
// 获取今天日期
const today = new Date()



	// 过滤和排序任务


// 格式化时间
const formatTime = (dateStr) => {
  if (!dateStr) return ''
  return formatDateTime(new Date(dateStr), 'HH:mm')
}

// 判断是否是今天
const isToday = computed(() => {
  return isSameDay(currentDate.value, today)
})


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

// 显示快速添加任务弹窗
const showQuickAddModal = () => {
  uni.navigateTo({
    url: '/pages/task/create'
  })
}

const navigateToDetail = (taskId) => {
	uni.navigateTo({
		url: `/pages/task/detail?id=${taskId}`
	})
}

// 页面加载时获取今天的任务
onMounted(() => {
  // 设置当前日期为今天
  changeDate(new Date(new Date().getTime()))
})
onShow(async () => {
  changeDate(new Date(currentDate.value))
})




		




// 过滤和排序任务
const filteredTasks = computed(() => {
	if (!Array.isArray(calendarTasks.value)) return []

	let filtered = [...calendarTasks.value]

	// 排序：未完成的任务优先，然后按创建时间倒序
	return filtered.sort((a, b) => {
		if (a.status !== b.status) {
			return a.status === 'completed' ? 1 : -1
		}
		return new Date(b.createdAt) - new Date(a.createdAt)
	})
})
</script>

<style lang="scss">
.calendar-page {
  min-height: 100vh;
  background: #f5f5f5;
  
  .tasks-section {
    padding: 20rpx;
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
			border-left-color: #34C759; // 低优先级
		}
	
		&.p2 {
			border-left-color: #FF9500; // 中优先级
		}
	
		&.p3 {
			border-left-color: #FF3B30; // 高优先级
		}
	}
  
  	.loading,
  	.empty {
  		padding: 40rpx;
  		text-align: center;
  		color: #8c8c8c;
  		font-size: 28rpx;
  	}
  }
  
  .task-group {
    margin-bottom: 30rpx;
    background: #fff;
    border-radius: 12rpx;
    box-shadow: 0 2rpx 16rpx rgba(0, 0, 0, 0.08);
    
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
        font-weight: 600;
        color: #333;
      }
      
      .count {
        margin-left: 12rpx;
        font-size: 24rpx;
        color: #999;
        background: #f5f5f5;
        padding: 2rpx 12rpx;
        border-radius: 20rpx;
      }
    }
  }
  

  
  .empty-state {
    padding: 60rpx 0;
    text-align: center;
    
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
	/* #ifdef H5 */
	bottom: 140rpx;
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
}
</style>
