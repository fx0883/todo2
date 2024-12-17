<template>
  <view class="feedback-container">
    <textarea
      class="feedback-input"
      v-model="content"
      placeholder="请输入您的意见或建议..."
      maxlength="500"
    />
    <view class="word-count">{{ content.length }}/500</view>
    
    <view class="contact-input">
      <input
        type="text"
        v-model="contact"
        placeholder="请留下您的联系方式（选填）"
      />
    </view>
    
    <button 
      class="submit-btn"
      @click="handleSubmit"
    >
      提交反馈
    </button>
  </view>
</template>

<script setup>
import { ref } from 'vue'

const content = ref('')
const contact = ref('')

const handleSubmit = async () => {
  try {
    if (!content.value) {
      throw new Error('请输入反馈内容')
    }
    
    // TODO: 调用后端API提交反馈
    // await submitFeedback({
    //   content: content.value,
    //   contact: contact.value
    // })
    
    uni.showToast({
      title: '感谢您的反馈',
      icon: 'success'
    })
    
    // 返回上一页
    setTimeout(() => {
      uni.navigateBack()
    }, 1500)
  } catch (error) {
    uni.showToast({
      title: error.message || '提交失败',
      icon: 'none'
    })
  }
}
</script>

<style lang="scss">
.feedback-container {
  padding: 30rpx;
  
  .feedback-input {
    width: 100%;
    height: 400rpx;
    padding: 20rpx;
    background-color: #fff;
    border-radius: 20rpx;
    font-size: 28rpx;
    margin-bottom: 20rpx;
  }
  
  .word-count {
    text-align: right;
    font-size: 24rpx;
    color: #999;
    margin-bottom: 30rpx;
  }
  
  .contact-input {
    margin-bottom: 60rpx;
    
    input {
      width: 100%;
      height: 90rpx;
      padding: 0 30rpx;
      background-color: #fff;
      border-radius: 45rpx;
      font-size: 28rpx;
    }
  }
  
  .submit-btn {
    width: 100%;
    height: 90rpx;
    line-height: 90rpx;
    background-color: #409EFF;
    color: #fff;
    border-radius: 45rpx;
    font-size: 32rpx;
  }
}
</style>
