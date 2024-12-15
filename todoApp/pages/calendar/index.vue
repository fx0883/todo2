<template>
  <div class="calendar-page">
    <div class="calendar-controls">
      <div class="view-controls">
        <a-radio-group v-model:value="viewType" button-style="solid">
          <a-radio-button value="month">月</a-radio-button>
          <a-radio-button value="week">周</a-radio-button>
          <a-radio-button value="day">日</a-radio-button>
        </a-radio-group>
      </div>
      <div class="filter-controls">
        <a-select v-model:value="taskStatus" style="width: 120px">
          <a-select-option value="all">全部任务</a-select-option>
          <a-select-option value="completed">已完成</a-select-option>
          <a-select-option value="pending">未完成</a-select-option>
        </a-select>
      </div>
      <div class="date-controls">
        <a-button @click="goToToday">今天</a-button>
        <a-button-group>
          <a-button @click="previousPeriod">
            <template #icon><left-outlined /></template>
          </a-button>
          <a-button @click="nextPeriod">
            <template #icon><right-outlined /></template>
          </a-button>
        </a-button-group>
        <span class="current-date">{{ formatCurrentPeriod }}</span>
      </div>
    </div>

    <div class="calendar-content">
      <div v-if="loading" class="loading-state">
        <a-spin size="large" />
      </div>
      <template v-else>
        <div v-if="tasks.length === 0" class="empty-state">
          <a-empty :description="emptyStateMessage" />
        </div>
        <div v-else class="task-list">
          <div v-for="task in tasks" :key="task.id" class="task-item" :class="{
            'task-completed': task.completed,
            'task-important': task.is_important,
            'task-recurring': task.is_recurring_instance
          }">
            <div class="task-status">
              <a-checkbox
                :checked="task.completed"
                @change="(e) => toggleTaskStatus(task, e.target.checked)"
              />
            </div>
            <div class="task-content" @click="navigateToTask(task)">
              <div class="task-title">
                {{ task.title }}
                <a-tag v-if="task.is_recurring_instance" color="blue">重复</a-tag>
                <a-tag v-if="task.is_important" color="red">重要</a-tag>
              </div>
              <div class="task-meta">
                <span class="task-due">
                  {{ formatTaskDueDate(task.due_date) }}
                </span>
                <span v-if="task.category" class="task-category">
                  <a-tag :color="task.category.color">{{ task.category.name }}</a-tag>
                </span>
              </div>
            </div>
          </div>
        </div>
      </template>
    </div>

    <div class="calendar-stats">
      <a-card title="任务统计" :loading="statsLoading">
        <template v-if="!statsLoading">
          <a-row :gutter="16">
            <a-col :span="6">
              <a-statistic
                title="今日任务"
                :value="statistics.today.total"
                :suffix="`/ ${statistics.today.completed}`"
              />
            </a-col>
            <a-col :span="6">
              <a-statistic
                title="本周任务"
                :value="statistics.week.total"
                :suffix="`/ ${statistics.week.completed}`"
              />
            </a-col>
            <a-col :span="6">
              <a-statistic
                title="逾期任务"
                :value="statistics.overdue"
                :valueStyle="{ color: statistics.overdue > 0 ? '#cf1322' : '#3f8600' }"
              />
            </a-col>
            <a-col :span="6">
              <a-statistic
                title="总计完成"
                :value="statistics.all.completed"
                :suffix="`/ ${statistics.all.total}`"
              />
            </a-col>
          </a-row>
        </template>
      </a-card>
    </div>

    <a-button
      type="primary"
      shape="circle"
      size="large"
      class="add-button"
      @click="navigateToCreate"
    >
      <template #icon><plus-outlined /></template>
    </a-button>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, watch } from 'vue'
import { useRouter } from 'vue-router'
import { message } from 'ant-design-vue'
import { LeftOutlined, RightOutlined, PlusOutlined } from '@ant-design/icons-vue'
import { formatDate, isSameDate, getDateRange } from '@/utils/dateTime'
import { useTaskStore } from '@/stores/task'

const router = useRouter()
const taskStore = useTaskStore()

// 状态
const viewType = ref('month')
const taskStatus = ref('all')
const currentDate = ref(new Date())
const loading = ref(false)
const statsLoading = ref(false)
const tasks = ref([])
const statistics = ref({
  today: { total: 0, completed: 0, pending: 0 },
  week: { total: 0, completed: 0, pending: 0 },
  overdue: 0,
  all: { total: 0, completed: 0, pending: 0 }
})

// 计算属性
const formatCurrentPeriod = computed(() => {
  const date = currentDate.value
  if (viewType.value === 'month') {
    return formatDate(date, 'YYYY年MM月')
  } else if (viewType.value === 'week') {
    const { startDate, endDate } = getDateRange(date, 'week')
    return `${formatDate(startDate, 'MM.DD')} - ${formatDate(endDate, 'MM.DD')}`
  } else {
    return formatDate(date, 'YYYY年MM月DD日')
  }
})

const emptyStateMessage = computed(() => {
  if (loading.value) return '加载中...'
  if (isSameDate(currentDate.value, new Date())) {
    return '今天没有任务'
  }
  return '当前日期没有任务'
})

// 方法
const loadTasks = async () => {
  loading.value = true
  try {
    const { startDate, endDate } = getDateRange(currentDate.value, viewType.value)
    const response = await taskStore.fetchCalendarTasks({
      startDate: formatDate(startDate, 'YYYY-MM-DD'),
      endDate: formatDate(endDate, 'YYYY-MM-DD'),
      viewType: viewType.value,
      status: taskStatus.value
    })
    tasks.value = response
  } catch (error) {
    message.error('加载任务失败')
  } finally {
    loading.value = false
  }
}

const loadStatistics = async () => {
  statsLoading.value = true
  try {
    statistics.value = await taskStore.fetchTaskStatistics()
  } catch (error) {
    message.error('加载统计信息失败')
  } finally {
    statsLoading.value = false
  }
}

const toggleTaskStatus = async (task, completed) => {
  try {
    await taskStore.toggleTaskStatus(task.id, completed)
    await loadTasks()
    await loadStatistics()
    message.success(completed ? '任务已完成' : '任务已重新开始')
  } catch (error) {
    message.error('更新任务状态失败')
  }
}

const navigateToTask = (task) => {
  router.push(`/tasks/${task.id}`)
}

const navigateToCreate = () => {
  router.push('/tasks/create')
}

const formatTaskDueDate = (date) => {
  return formatDate(new Date(date), 'HH:mm')
}

const goToToday = () => {
  currentDate.value = new Date()
}

const previousPeriod = () => {
  const date = new Date(currentDate.value)
  if (viewType.value === 'month') {
    date.setMonth(date.getMonth() - 1)
  } else if (viewType.value === 'week') {
    date.setDate(date.getDate() - 7)
  } else {
    date.setDate(date.getDate() - 1)
  }
  currentDate.value = date
}

const nextPeriod = () => {
  const date = new Date(currentDate.value)
  if (viewType.value === 'month') {
    date.setMonth(date.getMonth() + 1)
  } else if (viewType.value === 'week') {
    date.setDate(date.getDate() + 7)
  } else {
    date.setDate(date.getDate() + 1)
  }
  currentDate.value = date
}

// 监听器
watch([viewType, taskStatus, currentDate], () => {
  loadTasks()
})

// 生命周期
onMounted(() => {
  loadTasks()
  loadStatistics()
})
</script>

<style lang="less" scoped>
.calendar-page {
  padding: 24px;
  height: 100%;
  display: flex;
  flex-direction: column;
  gap: 24px;
}

.calendar-controls {
  display: flex;
  justify-content: space-between;
  align-items: center;
  gap: 16px;
  
  .date-controls {
    display: flex;
    align-items: center;
    gap: 8px;
    
    .current-date {
      font-size: 16px;
      font-weight: 500;
      min-width: 120px;
      text-align: center;
    }
  }
}

.calendar-content {
  flex: 1;
  overflow-y: auto;
  background: #fff;
  border-radius: 8px;
  padding: 16px;
  
  .loading-state {
    display: flex;
    justify-content: center;
    align-items: center;
    height: 200px;
  }
  
  .empty-state {
    padding: 48px 0;
  }
  
  .task-list {
    display: flex;
    flex-direction: column;
    gap: 8px;
    
    .task-item {
      display: flex;
      align-items: flex-start;
      padding: 12px;
      border-radius: 6px;
      background: #f5f5f5;
      transition: all 0.3s;
      
      &:hover {
        background: #e6f7ff;
      }
      
      &.task-completed {
        opacity: 0.6;
        background: #f0f0f0;
        
        .task-title {
          text-decoration: line-through;
        }
      }
      
      &.task-important {
        border-left: 4px solid #ff4d4f;
      }
      
      &.task-recurring {
        border-right: 4px solid #1890ff;
      }
      
      .task-status {
        padding: 4px 8px;
      }
      
      .task-content {
        flex: 1;
        cursor: pointer;
        
        .task-title {
          font-size: 14px;
          margin-bottom: 4px;
        }
        
        .task-meta {
          font-size: 12px;
          color: rgba(0, 0, 0, 0.45);
          display: flex;
          gap: 8px;
        }
      }
    }
  }
}

.calendar-stats {
  margin-top: auto;
}

.add-button {
  position: fixed;
  right: 24px;
  bottom: 24px;
  width: 48px;
  height: 48px;
}
</style>
