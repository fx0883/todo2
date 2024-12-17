<template>
  <view class="change-password-container">
    <view class="form-group">
      <input 
        class="input" 
        type="password" 
        v-model="formData.token" 
        placeholder="请输入验证码"
      />
      <button 
        class="send-code-btn" 
        :disabled="cooldown > 0" 
        @click="handleSendCode"
      >
        {{ cooldown > 0 ? `${cooldown}s` : '获取验证码' }}
      </button>
    </view>
    
    <view class="form-group">
      <input 
        class="input" 
        type="password" 
        v-model="formData.new_password" 
        placeholder="请输入新密码"
      />
    </view>
    
    <view class="form-group">
      <input 
        class="input" 
        type="password" 
        v-model="formData.confirm_password" 
        placeholder="请确认新密码"
      />
    </view>
    
    <button 
      class="submit-btn" 
      @click="handleSubmit"
    >
      确认修改
    </button>
  </view>
</template>

<script setup>
import { ref } from 'vue'
import { useUserStore } from '@/store/modules/user'

const userStore = useUserStore()
const cooldown = ref(0)
const formData = ref({
  token: '',
  new_password: '',
  confirm_password: ''
})

// 发送验证码
const handleSendCode = async () => {
  try {
    await userStore.requestPasswordReset()
    // 开始倒计时
    cooldown.value = 60
    const timer = setInterval(() => {
      cooldown.value--
      if (cooldown.value <= 0) {
        clearInterval(timer)
      }
    }, 1000)
  } catch (error) {
    uni.showToast({
      title: error.message || '发送验证码失败',
      icon: 'none'
    })
  }
}

// 提交修改密码
const handleSubmit = async () => {
  try {
    if (!formData.value.token) {
      throw new Error('请输入验证码')
    }
    if (!formData.value.new_password) {
      throw new Error('请输入新密码')
    }
    if (!formData.value.confirm_password) {
      throw new Error('请确认新密码')
    }
    if (formData.value.new_password !== formData.value.confirm_password) {
      throw new Error('两次输入的密码不一致')
    }
    
    await userStore.confirmPasswordReset(formData.value)
    uni.showToast({
      title: '密码修改成功',
      icon: 'success'
    })
    // 返回上一页
    setTimeout(() => {
      uni.navigateBack()
    }, 1500)
  } catch (error) {
    uni.showToast({
      title: error.message || '修改密码失败',
      icon: 'none'
    })
  }
}
</script>

<style lang="scss">
.change-password-container {
  padding: 30rpx;
  
  .form-group {
    position: relative;
    margin-bottom: 30rpx;
    
    .input {
      width: 100%;
      height: 90rpx;
      padding: 0 30rpx;
      background-color: #fff;
      border-radius: 45rpx;
      font-size: 28rpx;
      
      &.with-button {
        padding-right: 200rpx;
      }
    }
    
    .send-code-btn {
      position: absolute;
      right: 10rpx;
      top: 50%;
      transform: translateY(-50%);
      width: 180rpx;
      height: 70rpx;
      line-height: 70rpx;
      background-color: #409EFF;
      color: #fff;
      border-radius: 35rpx;
      font-size: 24rpx;
      text-align: center;
      
      &:disabled {
        background-color: #ccc;
      }
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
    margin-top: 60rpx;
  }
}
</style>
