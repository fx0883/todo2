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
          <progress
            :percent="completionRate"
            stroke-width="12"
            :color="progressColor"
            class="progress"
          />
          <text class="progress-text">任务完成率: {{ completionRate }}%</text>
        </view>
        <view class="stats-details">
          <view class="detail-item">
            <text class="detail-label">按时完成率：</text>
            <text class="detail-value">{{ onTimeRate }}%</text>
          </view>
          <view class="detail-item">
            <text class="detail-label">平均完成时间：</text>
            <text class="detail-value">{{ avgCompletionDays }}天</text>
          </view>
        </view>
      </view>
    </view>

    <!-- 分类统计和趋势图表 -->
    <view class="charts-section">
      <view class="chart-card">
        <text class="section-title">任务分类分布</text>
        <view class="chart-wrapper">
          <VChart class="chart" :option="categoryChartOption" autoresize />
        </view>
      </view>
      <view class="chart-card">
        <text class="section-title">每日任务趋势</text>
        <view class="chart-wrapper">
          <VChart class="chart" :option="trendChartOption" autoresize />
        </view>
      </view>
    </view>
  </view>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useTaskStore } from '@/store/modules/task'
import VChart from 'vue-echarts'
import * as echarts from 'echarts/core'
import { CanvasRenderer } from 'echarts/renderers'
import { PieChart, LineChart } from 'echarts/charts'
import {
  TitleComponent,
  TooltipComponent,
  LegendComponent,
  GridComponent
} from 'echarts/components'

// 注册必需的组件
echarts.use([
  CanvasRenderer,
  PieChart,
  LineChart,
  TitleComponent,
  TooltipComponent,
  LegendComponent,
  GridComponent
])

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
const dailyTrend = computed(() => taskStore.dailyTrend || [])

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

// 模拟数据 - 实际项目中应从后端获取
const onTimeRate = computed(() => 85)
const avgCompletionDays = computed(() => 2.5)

// 获取统计数据
const fetchStatistics = async () => {
  await Promise.all([
    taskStore.fetchMonthStats(currentMonth.value),
    taskStore.fetchCategoryStats(currentMonth.value),
    taskStore.fetchDailyTrend(currentMonth.value)
  ])
}

// 监听月份变化
const handleMonthChange = (e) => {
  const date = new Date(e.detail.value)
  currentMonth.value = date.toISOString().slice(0, 7)
  fetchStatistics()
}

// 分类统计图表配置
const categoryChartOption = computed(() => ({
  tooltip: {
    trigger: 'item',
    formatter: '{b}: {c} ({d}%)'
  },
  legend: {
    orient: 'vertical',
    left: 'left',
    top: 'middle'
  },
  series: [
    {
      type: 'pie',
      radius: ['40%', '70%'],
      avoidLabelOverlap: false,
      itemStyle: {
        borderRadius: 10,
        borderColor: '#fff',
        borderWidth: 2
      },
      label: {
        show: true,
        position: 'outside',
        formatter: '{b}: {c}'
      },
      emphasis: {
        label: {
          show: true,
          fontSize: '16',
          fontWeight: 'bold'
        }
      },
      data: categoryStats.value
    }
  ]
}))

// 每日趋势图表配置
const trendChartOption = computed(() => ({
  tooltip: {
    trigger: 'axis',
    formatter: '{b}<br />任务数: {c}'
  },
  grid: {
    left: '3%',
    right: '4%',
    bottom: '3%',
    containLabel: true
  },
  xAxis: {
    type: 'category',
    data: dailyTrend.value.map(item => item.date),
    axisLabel: {
      rotate: 45
    }
  },
  yAxis: {
    type: 'value',
    name: '任务数',
    nameLocation: 'middle',
    nameGap: 40
  },
  series: [
    {
      data: dailyTrend.value.map(item => item.count),
      type: 'line',
      smooth: true,
      symbolSize: 8,
      itemStyle: {
        color: '#409EFF'
      },
      areaStyle: {
        color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
          {
            offset: 0,
            color: 'rgba(64,158,255,0.3)'
          },
          {
            offset: 1,
            color: 'rgba(64,158,255,0.1)'
          }
        ])
      }
    }
  ]
}))

// 组件挂载时获取数据
onMounted(() => {
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
  border: 1px solid #ddd;
  border-radius: 10px;
  box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
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
}

.analysis-section .section-title {
  font-size: 18px;
  font-weight: bold;
  color: #303133;
  margin-bottom: 10px;
}

.completion-analysis {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.progress-section {
  display: flex;
  flex-direction: column;
  align-items: center;
}

.progress-section .progress {
  width: 100px;
  height: 100px;
  border-radius: 50%;
}

.progress-section .progress-text {
  font-size: 14px;
  color: #606266;
  margin-top: 10px;
}

.stats-details {
  display: flex;
  flex-direction: column;
  align-items: flex-start;
}

.stats-details .detail-item {
  display: flex;
  align-items: center;
  margin-bottom: 10px;
}

.stats-details .detail-item .detail-label {
  font-size: 14px;
  color: #606266;
  margin-right: 10px;
}

.stats-details .detail-item .detail-value {
  font-size: 14px;
  font-weight: bold;
  color: #303133;
}

.charts-section {
  margin-top: 20px;
}

.chart-card {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 20px;
  border: 1px solid #ddd;
  border-radius: 10px;
  box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
}

.chart-card .section-title {
  font-size: 18px;
  font-weight: bold;
  color: #303133;
  margin-bottom: 10px;
}

.chart-wrapper {
  width: 100%;
  height: 400px;
}

.chart {
  width: 100%;
  height: 100%;
}
</style>
