<template>
  <view class="feedback-page">
    <!-- 反馈表单 -->
    <view class="feedback-form">
      <view class="form-item">
        <text class="label">反馈类型</text>
        <picker 
          :value="feedbackForm.type" 
          :range="feedbackTypes" 
          @change="handleTypeChange"
        >
          <view class="picker">
            {{ feedbackForm.type || '请选择反馈类型' }}
          </view>
        </picker>
      </view>

      <view class="form-item">
        <text class="label">标题</text>
        <input 
          v-model="feedbackForm.title"
          placeholder="请输入标题"
          class="input"
        />
      </view>

      <view class="form-item">
        <text class="label">内容</text>
        <textarea
          v-model="feedbackForm.content"
          placeholder="请详细描述您的问题或建议"
          class="textarea"
        />
      </view>

      <view class="form-item">
        <text class="label">联系方式（选填）</text>
        <input
          v-model="feedbackForm.contact_info"
          placeholder="请输入您的联系方式"
          class="input"
        />
      </view>

      <button 
        class="submit-btn" 
        :disabled="loading"
        @tap="handleSubmit"
      >
        {{ loading ? '提交中...' : '提交反馈' }}
      </button>
    </view>

    <!-- 反馈列表 -->
    <view class="feedback-list" v-if="feedbackList.length">
      <view class="list-header">
        <text class="title">我的反馈</text>
      </view>
      <view 
        v-for="feedback in feedbackList" 
        :key="feedback.id"
        class="feedback-item"
      >
        <view class="feedback-header">
          <text class="feedback-title">{{ feedback.title }}</text>
          <text class="feedback-status" :class="feedback.status">
            {{ getStatusText(feedback.status) }}
          </text>
        </view>
        <text class="feedback-content">{{ feedback.content }}</text>
        <view class="feedback-footer">
          <text class="feedback-time">{{ formatTime(feedback.created_at) }}</text>
        </view>
        <view class="feedback-response" v-if="feedback.response">
          <text class="response-label">回复：</text>
          <text class="response-content">{{ feedback.response }}</text>
        </view>
      </view>
    </view>

    <view class="empty-state" v-else-if="!loading">
      <text>暂无反馈记录</text>
    </view>
  </view>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useFeedback } from '@/composables/useFeedback'
import { formatDateTime } from '@/utils/dateTime'

const { 
  feedbackForm, 
  submitFeedback, 
  getFeedbackList,
  feedbackList,
  loading,
  error 
} = useFeedback()

const feedbackTypes = ['bug', 'feature_request', 'complaint', 'other']

// 处理类型选择
const handleTypeChange = (e) => {
  feedbackForm.value.type = feedbackTypes[e.detail.value]
}

// 处理提交
const handleSubmit = async () => {
  if (!feedbackForm.value.type) {
    uni.showToast({
      title: '请选择反馈类型',
      icon: 'none'
    })
    return
  }
  if (!feedbackForm.value.title.trim()) {
    uni.showToast({
      title: '请输入标题',
      icon: 'none'
    })
    return
  }
  if (!feedbackForm.value.content.trim()) {
    uni.showToast({
      title: '请输入内容',
      icon: 'none'
    })
    return
  }

  try {
    await submitFeedback()
    // 刷新列表
    await getFeedbackList()
  } catch (error) {
    console.error('提交反馈失败:', error)
  }
}

// 获取状态文本
const getStatusText = (status) => {
  const statusMap = {
    'pending': '待处理',
    'in_progress': '处理中',
    'resolved': '已解决',
    'closed': '已关闭'
  }
  return statusMap[status] || status
}

// 格式化时间
const formatTime = (time) => {
  return formatDateTime(time)
}

// 页面加载时获取反馈列表
onMounted(async () => {
  try {
    await getFeedbackList()
  } catch (error) {
    console.error('获取反馈列表失败:', error)
  }
})
</script>

<style lang="scss">
.feedback-page {
  padding: 20rpx;
  
  .feedback-form {
    background: #fff;
    padding: 30rpx;
    border-radius: 12rpx;
    margin-bottom: 30rpx;
    
    .form-item {
      margin-bottom: 20rpx;
      
      .label {
        display: block;
        margin-bottom: 10rpx;
        font-size: 28rpx;
        color: #333;
      }
      
      .input {
        width: 100%;
        height: 80rpx;
        padding: 0 20rpx;
        border: 1px solid #ddd;
        border-radius: 8rpx;
      }
      
      .textarea {
        width: 100%;
        height: 200rpx;
        padding: 20rpx;
        border: 1px solid #ddd;
        border-radius: 8rpx;
      }
      
      .picker {
        width: 100%;
        height: 80rpx;
        line-height: 80rpx;
        padding: 0 20rpx;
        border: 1px solid #ddd;
        border-radius: 8rpx;
      }
    }
    
    .submit-btn {
      width: 100%;
      height: 88rpx;
      line-height: 88rpx;
      background: #007AFF;
      color: #fff;
      border-radius: 44rpx;
      font-size: 32rpx;
      margin-top: 40rpx;
      
      &:active {
        opacity: 0.8;
      }
    }
  }
  
  .feedback-list {
    .list-header {
      margin-bottom: 20rpx;
      
      .title {
        font-size: 32rpx;
        font-weight: bold;
        color: #333;
      }
    }
    
    .feedback-item {
      background: #fff;
      padding: 20rpx;
      border-radius: 12rpx;
      margin-bottom: 20rpx;
      
      .feedback-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 10rpx;
        
        .feedback-title {
          font-size: 30rpx;
          font-weight: bold;
          color: #333;
        }
        
        .feedback-status {
          font-size: 24rpx;
          padding: 4rpx 12rpx;
          border-radius: 20rpx;
          
          &.pending {
            background: #FFF3CD;
            color: #856404;
          }
          
          &.in_progress {
            background: #CCE5FF;
            color: #004085;
          }
          
          &.resolved {
            background: #D4EDDA;
            color: #155724;
          }
          
          &.closed {
            background: #F8F9FA;
            color: #6C757D;
          }
        }
      }
      
      .feedback-content {
        font-size: 28rpx;
        color: #666;
        margin-bottom: 10rpx;
      }
      
      .feedback-footer {
        font-size: 24rpx;
        color: #999;
      }
      
      .feedback-response {
        margin-top: 20rpx;
        padding-top: 20rpx;
        border-top: 1px solid #eee;
        
        .response-label {
          font-size: 26rpx;
          color: #333;
          font-weight: bold;
        }
        
        .response-content {
          font-size: 26rpx;
          color: #666;
        }
      }
    }
  }
  
  .empty-state {
    text-align: center;
    padding: 100rpx 0;
    color: #999;
    font-size: 28rpx;
  }
}
</style>
