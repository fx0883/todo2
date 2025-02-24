<template>
  <view class="statistics-page">
    <!-- 顶部月份选择和总览 -->
    <view class="header-section">
      <view class="month-selector">
        <text class="section-title">统计月份</text>
        <picker
          mode="date"
          fields="month"
          :value="currentMonth"
          @change="handleMonthChange"
        >
          <view class="picker-text">{{ formatMonth }}</view>
        </picker>
      </view>
    </view>

    <!-- 统计卡片 -->
    <view class="stats-grid">
      <view class="stat-card">
        <text class="stat-value">{{ monthStats.total }}</text>
        <text class="stat-label">总任务数</text>
      </view>
      <view class="stat-card completed">
        <text class="stat-value">{{ monthStats.completed }}</text>
        <text class="stat-label">已完成</text>
      </view>
      <view class="stat-card pending">
        <text class="stat-value">{{ monthStats.pending }}</text>
        <text class="stat-label">进行中</text>
      </view>
      <view class="stat-card overdue">
        <text class="stat-value">{{ monthStats.overdue }}</text>
        <text class="stat-label">已逾期</text>
      </view>
    </view>

    <!-- 任务完成情况分析 -->
    <view class="analysis-section">
      <text class="section-title">任务完成情况分析</text>
      <view class="completion-analysis">
        <view class="progress-section">
          <view class="progress-bar-container">
            <progress
              :percent="completionRate"
              stroke-width="12"
              :color="progressColor"
              class="progress"
            />
          </view>
          <view class="stats-row">
            <text class="stat-item">按时完成率：{{ onTimeRate }}%</text>
            <text class="stat-item">任务完成率：{{ completionRate }}%</text>
            <text class="stat-item">平均完成时间：{{ avgCompletionDays }}天</text>
          </view>
        </view>
      </view>
    </view>

    <!-- 分类统计和趋势图表 -->
    <view class="charts-section">
      <!-- 任务分类分布 -->
      <view class="chart-card">
        <text class="section-title">任务分类分布</text>
        <view class="category-list">
          <view 
            v-for="(category, index) in categoryStats" 
            :key="category.name"
            class="category-item"
          >
            <text class="category-name">{{ category.name }}</text>
            <view class="progress-container">
              <view 
                class="progress-bar" 
                :style="{ 
                  width: `${(category.value / maxTaskCount) * 100}%`,
                  backgroundColor: categoryColors[index % categoryColors.length]
                }"
              >
                <text class="progress-text">{{ category.value }}</text>
              </view>
            </view>
          </view>
        </view>
      </view>

      <!-- 优先级分布统计 -->
      <view class="chart-card">
        <text class="section-title">优先级分布统计</text>
        <view class="priority-list">
          <view 
            v-for="priority in priorityChartData" 
            :key="priority.name"
            class="priority-item"
          >
            <view class="priority-info">
              <text class="priority-name">{{ priority.name }}</text>
              <text class="priority-value">{{ priority.value }}</text>
            </view>
            <view class="priority-progress">
              <view 
                class="priority-bar"
                :style="{ 
                  width: `${(priority.value / monthStats.total) * 100}%`,
                  backgroundColor: getPriorityColor(priority.name)
                }"
              />
            </view>
          </view>
        </view>
      </view>
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
import { useTaskStore } from '@/store/modules/task'

const taskStore = useTaskStore()
const currentMonth = ref(new Date().toISOString().slice(0, 7)) // YYYY-MM

// 格式化显示月份
const formatMonth = computed(() => {
  const [year, month] = currentMonth.value.split('-')
  return `${year}年${month}月`
})

// 从 store 获取数据
const monthStats = computed(() => taskStore.monthStats || {})
const categoryStats = computed(() => taskStore.categoryStats || [])
const priorityStats = computed(() => taskStore.priorityStats || { high: 0, medium: 0, low: 0 })

// 优先级分布统计数据转换
const priorityChartData = computed(() => [
  { name: '高优先级', value: priorityStats.value.high },
  { name: '中优先级', value: priorityStats.value.medium },
  { name: '低优先级', value: priorityStats.value.low }
])

// 计算任务完成率
const completionRate = computed(() => {
  if (!monthStats.value.total) return 0
  return Math.round((monthStats.value.completed / monthStats.value.total) * 100)
})

// 进度条颜色
const progressColor = computed(() => {
  const rate = completionRate.value
  if (rate >= 80) return '#07c160'
  if (rate >= 60) return '#ff9900'
  return '#ff0000'
})

// 获取优先级颜色
function getPriorityColor(priority) {
  switch (priority) {
    case '高优先级':
      return '#F56C6C'
    case '中优先级':
      return '#E6A23C'
    case '低优先级':
      return '#67C23A'
    default:
      return '#909399'
  }
}

// 模拟数据 - 实际项目中应从后端获取
const onTimeRate = computed(() => 85)
const avgCompletionDays = computed(() => 2.5)

// 获取统计数据
const fetchStatistics = async () => {
  await Promise.all([
    taskStore.fetchMonthStats(currentMonth.value),
    taskStore.fetchCategoryStats(currentMonth.value),
    taskStore.fetchPriorityStats(currentMonth.value)
  ])
}

// 监听月份变化
const handleMonthChange = (e) => {
  const date = new Date(e.detail.value)
  currentMonth.value = date.toISOString().slice(0, 7)
  fetchStatistics()
}

// 分类颜色数组
const categoryColors = [
  '#409EFF', // 蓝色
  '#67C23A', // 绿色
  '#E6A23C', // 橙色
  '#F56C6C', // 红色
  '#909399', // 灰色
  '#9B59B6', // 紫色
  '#3498DB', // 浅蓝
  '#1ABC9C', // 青绿
  '#D35400', // 深橙
  '#2C3E50'  // 深灰
]

// 计算最大任务数量
const maxTaskCount = computed(() => {
  if (!categoryStats.value || categoryStats.value.length === 0) return 0
  return Math.max(...categoryStats.value.map(item => item.value))
})

// 组件挂载时获取数据
onMounted(() => {
  fetchStatistics()
})

onShow(async () => {
  fetchStatistics()
})
</script>

<style scoped>
.statistics-page {
  padding: 20px;
  background-color: #f5f7fa;
  min-height: 100vh;
}

.header-section {
  display: flex;
  justify-content: space-between;
  align-items: center;
  background: #fff;
  padding: 15px;
  border-radius: 8px;
  margin-bottom: 20px;
}

.month-selector {
  display: flex;
  align-items: center;
}

.month-selector .section-title {
  margin-right: 10px;
}

.month-selector .picker-text {
  padding: 10px;
  border: 1px solid #ddd;
  border-radius: 5px;
}

.stats-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 20px;
  margin-top: 20px;
}

.stat-card {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 20px;
  background: #fff;
  border-radius: 10px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.1);
}

.stat-card .stat-value {
  font-size: 24px;
  font-weight: bold;
  color: #303133;
}

.stat-card .stat-label {
  font-size: 14px;
  color: #909399;
  margin-top: 10px;
}

.stat-card.completed .stat-value {
  color: #67C23A;
}

.stat-card.pending .stat-value {
  color: #E6A23C;
}

.stat-card.overdue .stat-value {
  color: #F56C6C;
}

.analysis-section {
  margin-top: 20px;
  background: #fff;
  border-radius: 8px;
  padding: 15px;
}

.completion-analysis {
  margin-top: 15px;
}

.progress-section {
  width: 100%;
}

.progress-bar-container {
  width: 100%;
  margin-bottom: 15px;
}

.progress {
  width: 100% !important;
}

.stats-row {
  display: flex;
  justify-content: space-between;
  flex-wrap: wrap;
  gap: 10px;
  margin-top: 10px;
}

.stat-item {
  font-size: 14px;
  color: #606266;
  flex: 1;
  min-width: 120px;
  text-align: center;
}

.charts-section {
  margin-top: 20px;
}

.chart-card {
  background: #fff;
  border-radius: 8px;
  padding: 15px;
  margin-bottom: 20px;
}

.section-title {
  font-size: 16px;
  font-weight: bold;
  color: #303133;
  margin-bottom: 15px;
}

.category-list {
  margin-top: 15px;
}

.category-item {
  margin-bottom: 15px;
}

.category-name {
  font-size: 14px;
  color: #303133;
  margin-bottom: 8px;
  display: block;
}

.progress-container {
  height: 24px;
  background-color: #f5f7fa;
  border-radius: 12px;
  overflow: hidden;
}

.progress-bar {
  height: 100%;
  border-radius: 12px;
  transition: width 0.3s ease;
  display: flex;
  align-items: center;
  justify-content: flex-end;
  padding: 0 10px;
  min-width: 30px;
}

.progress-text {
  color: #fff;
  font-size: 12px;
  text-shadow: 0 0 2px rgba(0, 0, 0, 0.2);
}

.priority-list {
  margin-top: 15px;
}

.priority-item {
  margin-bottom: 15px;
}

.priority-info {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 8px;
}

.priority-name {
  font-size: 14px;
  color: #303133;
}

.priority-value {
  font-size: 14px;
  color: #909399;
}

.priority-progress {
  height: 8px;
  background-color: #f5f7fa;
  border-radius: 4px;
  overflow: hidden;
}

.priority-bar {
  height: 100%;
  border-radius: 4px;
  transition: width 0.3s ease;
}
</style>