<template>
  <view class="feedback-container">
    <view class="form-group">
      <text class="label">反馈类型</text>
      <picker :value="feedbackForm.type" :range="feedbackTypes" @change="handleTypeChange">
        <view class="picker">{{ feedbackForm.type || '请选择反馈类型' }}</view>
      </picker>
    </view>

    <view class="form-group">
      <text class="label">标题</text>
      <input
        v-model="feedbackForm.title"
        class="input"
        type="text"
        placeholder="请输入标题"
      />
    </view>

    <view class="form-group">
      <text class="label">内容</text>
      <textarea
        v-model="feedbackForm.content"
        class="textarea"
        placeholder="请详细描述您的问题或建议"
      />
    </view>

<!--    <view class="form-group">
      <text class="label">联系方式（选填）</text>
      <input
        v-model="feedbackForm.contact_info"
        class="input"
        type="text"
        placeholder="请输入您的联系方式"
      />
    </view> -->

    <button class="submit-btn" @tap="handleSubmit" :disabled="isSubmitting">
      {{ isSubmitting ? '提交中...' : '提交反馈' }}
    </button>
  </view>
</template>

<script setup>
import { ref } from 'vue'
import { useFeedback } from '@/composables/useFeedback'

const { feedbackForm, submitFeedback } = useFeedback()
const isSubmitting = ref(false)

const feedbackTypes = ['功能建议', '问题反馈', '其他']

const handleTypeChange = (e) => {
  feedbackForm.value.type = feedbackTypes[e.detail.value]
}

const handleSubmit = async () => {
  if (!feedbackForm.value.type) {
    uni.showToast({
      title: '请选择反馈类型',
      icon: 'none'
    })
    return
  }

  if (!feedbackForm.value.title) {
    uni.showToast({
      title: '请输入标题',
      icon: 'none'
    })
    return
  }

  if (!feedbackForm.value.content) {
    uni.showToast({
      title: '请输入反馈内容',
      icon: 'none'
    })
    return
  }

  isSubmitting.value = true
  try {
    await submitFeedback()
  } finally {
    isSubmitting.value = false
  }
}
</script>

<style lang="scss">
.feedback-container {
  padding: 20rpx;
  background-color: #f8f8f8;
  min-height: 100vh;
}

.form-group {
  margin-bottom: 20rpx;
  background-color: #fff;
  padding: 20rpx;
  border-radius: 8rpx;

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
    border: 1px solid #eee;
    border-radius: 4rpx;
    font-size: 28rpx;
  }

  .textarea {
    width: 100%;
    height: 200rpx;
    padding: 20rpx;
    border: 1px solid #eee;
    border-radius: 4rpx;
    font-size: 28rpx;
  }

  .picker {
    width: 100%;
    height: 80rpx;
    line-height: 80rpx;
    padding: 0 20rpx;
    border: 1px solid #eee;
    border-radius: 4rpx;
    font-size: 28rpx;
    color: #333;
  }
}

.submit-btn {
  width: 100%;
  height: 88rpx;
  line-height: 88rpx;
  background-color: #007aff;
  color: #fff;
  font-size: 32rpx;
  border-radius: 44rpx;
  margin-top: 40rpx;

  &:active {
    opacity: 0.8;
  }

  &[disabled] {
    opacity: 0.6;
    background-color: #ccc;
  }
}
</style>
