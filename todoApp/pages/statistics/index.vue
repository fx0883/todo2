<template>
  <view class="statistics-container">
    <!-- 总览卡片 -->
    <view class="overview-card">
      <view class="card-header">
        <text class="title">任务总览</text>
        <picker 
          mode="date" 
          fields="month" 
          :value="currentMonth" 
          @change="handleMonthChange"
        >
          <text class="month">{{ currentMonth }}</text>
        </picker>
      </view>
      
      <view class="stats-grid">
        <view class="stats-item">
          <text class="number">{{ stats.total }}</text>
          <text class="label">总任务</text>
        </view>
        <view class="stats-item">
          <text class="number">{{ stats.completed }}</text>
          <text class="label">已完成</text>
        </view>
        <view class="stats-item">
          <text class="number">{{ stats.pending }}</text>
          <text class="label">进行中</text>
        </view>
        <view class="stats-item">
          <text class="number">{{ stats.overdue }}</text>
          <text class="label">已逾期</text>
        </view>
      </view>
      
      <view class="completion-rate">
        <text class="rate-text">完成率</text>
        <progress 
          :percent="completionRate" 
          stroke-width="12" 
          color="#007AFF"
          backgroundColor="#f5f5f5"
        />
        <text class="rate-number">{{ completionRate }}%</text>
      </view>
    </view>
    
    <!-- 分类统计 -->
    <view class="category-stats">
      <view class="section-header">
        <text class="title">分类统计</text>
      </view>
      
      <view class="category-list">
        <view 
          v-for="category in categoryStats" 
          :key="category.id" 
          class="category-item"
        >
          <view class="category-info">
            <view 
              class="category-color"
              :style="{ backgroundColor: category.color }"
            ></view>
            <text class="category-name">{{ category.name }}</text>
            <text class="task-count">{{ category.count }}个任务</text>
          </view>
          
          <view class="category-progress">
            <progress 
              :percent="category.completionRate" 
              stroke-width="8" 
              :color="category.color"
              backgroundColor="#f5f5f5"
            />
            <text class="progress-text">{{ category.completionRate }}%</text>
          </view>
        </view>
      </view>
    </view>
    
    <!-- 每日完成趋势 -->
    <view class="daily-trend">
      <view class="section-header">
        <text class="title">每日完成趋势</text>
      </view>
      
      <view class="trend-chart">
        <!-- 这里可以使用图表组件，如 uCharts 或 F2 -->
        <view class="chart-placeholder">
          <text>图表区域</text>
        </view>
      </view>
    </view>
  </view>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useTaskStore } from '@/store/task'
import { formatDate } from '@/utils/date'

const taskStore = useTaskStore()
const currentMonth = ref(formatDate(new Date(), 'YYYY-MM'))

// 统计数据
const stats = ref({
  total: 0,
  completed: 0,
  pending: 0,
  overdue: 0
})

// 分类统计
const categoryStats = ref([])

// 计算完成率
const completionRate = computed(() => {
  if (stats.value.total === 0) return 0
  return Math.round((stats.value.completed / stats.value.total) * 100)
})

// 获取月度统计数据
const fetchMonthStats = async (month) => {
  try {
    // 这里应该调用后端API获取数据
    // 临时使用模拟数据
    stats.value = {
      total: 50,
      completed: 35,
      pending: 10,
      overdue: 5
    }
  } catch (error) {
    console.error('获取统计数据失败:', error)
  }
}

// 获取分类统计数据
const fetchCategoryStats = async (month) => {
  try {
    // 这里应该调用后端API获取数据
    // 临时使用模拟数据
    categoryStats.value = [
      {
        id: 1,
        name: '工作',
        color: '#1890ff',
        count: 20,
        completionRate: 80
      },
      {
        id: 2,
        name: '学习',
        color: '#52c41a',
        count: 15,
        completionRate: 60
      },
      {
        id: 3,
        name: '生活',
        color: '#faad14',
        count: 10,
        completionRate: 90
      }
    ]
  } catch (error) {
    console.error('获取分类统计失败:', error)
  }
}

// 月份变更
const handleMonthChange = (e) => {
  currentMonth.value = e.detail.value
  fetchMonthStats(currentMonth.value)
  fetchCategoryStats(currentMonth.value)
}

onMounted(() => {
  fetchMonthStats(currentMonth.value)
  fetchCategoryStats(currentMonth.value)
})
</script>

<style lang="scss">
.statistics-container {
  min-height: 100vh;
  background-color: #f5f5f5;
  padding: 30rpx;
  
  .overview-card {
    background-color: #fff;
    border-radius: 12rpx;
    padding: 30rpx;
    margin-bottom: 30rpx;
    
    .card-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 30rpx;
      
      .title {
        font-size: 32rpx;
        font-weight: bold;
        color: #333;
      }
      
      .month {
        font-size: 28rpx;
        color: #666;
      }
    }
    
    .stats-grid {
      display: grid;
      grid-template-columns: repeat(4, 1fr);
      gap: 20rpx;
      margin-bottom: 30rpx;
      
      .stats-item {
        text-align: center;
        
        .number {
          display: block;
          font-size: 36rpx;
          font-weight: bold;
          color: #333;
          margin-bottom: 10rpx;
        }
        
        .label {
          font-size: 24rpx;
          color: #666;
        }
      }
    }
    
    .completion-rate {
      .rate-text {
        font-size: 28rpx;
        color: #666;
        margin-bottom: 10rpx;
      }
      
      .rate-number {
        font-size: 28rpx;
        color: #333;
        margin-left: 20rpx;
      }
    }
  }
  
  .category-stats {
    background-color: #fff;
    border-radius: 12rpx;
    padding: 30rpx;
    margin-bottom: 30rpx;
    
    .section-header {
      margin-bottom: 30rpx;
      
      .title {
        font-size: 32rpx;
        font-weight: bold;
        color: #333;
      }
    }
    
    .category-list {
      .category-item {
        margin-bottom: 30rpx;
        
        &:last-child {
          margin-bottom: 0;
        }
        
        .category-info {
          display: flex;
          align-items: center;
          margin-bottom: 10rpx;
          
          .category-color {
            width: 24rpx;
            height: 24rpx;
            border-radius: 50%;
            margin-right: 10rpx;
          }
          
          .category-name {
            font-size: 28rpx;
            color: #333;
            margin-right: 20rpx;
          }
          
          .task-count {
            font-size: 26rpx;
            color: #666;
          }
        }
        
        .category-progress {
          display: flex;
          align-items: center;
          
          progress {
            flex: 1;
            margin-right: 20rpx;
          }
          
          .progress-text {
            font-size: 26rpx;
            color: #333;
            width: 80rpx;
          }
        }
      }
    }
  }
  
  .daily-trend {
    background-color: #fff;
    border-radius: 12rpx;
    padding: 30rpx;
    
    .section-header {
      margin-bottom: 30rpx;
      
      .title {
        font-size: 32rpx;
        font-weight: bold;
        color: #333;
      }
    }
    
    .trend-chart {
      height: 400rpx;
      
      .chart-placeholder {
        height: 100%;
        display: flex;
        align-items: center;
        justify-content: center;
        background-color: #f5f5f5;
        border-radius: 12rpx;
        
        text {
          font-size: 28rpx;
          color: #999;
        }
      }
    }
  }
}
</style>
