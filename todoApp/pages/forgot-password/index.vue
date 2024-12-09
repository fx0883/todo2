<template>
  <view class="forgot-password-container">
    <view class="logo">
      <image src="/static/logo.png" mode="aspectFit"></image>
    </view>
    
    <view class="form-container">
      <view class="form-item">
        <text class="label">用户名</text>
        <input 
          class="input" 
          type="text" 
          v-model="form.username" 
          placeholder="请输入用户名"
        />
      </view>
      
      <view class="form-item">
        <text class="label">新密码</text>
        <input 
          class="input" 
          type="password" 
          v-model="form.password" 
          placeholder="请输入新密码"
          password
        />
      </view>
      
      <view class="form-item">
        <text class="label">确认密码</text>
        <input 
          class="input" 
          type="password" 
          v-model="form.confirmPassword" 
          placeholder="请再次输入新密码"
          password
        />
      </view>
      
      <button 
        class="submit-btn" 
        :disabled="!isValid || loading"
        :loading="loading"
        @click="handleResetPassword"
      >
        重置密码
      </button>
      
      <view class="actions">
        <text @click="navigateToLogin">返回登录</text>
      </view>
    </view>
  </view>
</template>

<script setup>
import { ref, computed } from 'vue'
import { userApi } from '@/api'

const loading = ref(false)

// 表单数据
const form = ref({
  username: '',
  password: '',
  confirmPassword: ''
})

// 表单验证
const isValid = computed(() => {
  return form.value.username && 
         form.value.password && 
         form.value.confirmPassword && 
         form.value.password === form.value.confirmPassword
})

// 重置密码
const handleResetPassword = async () => {
  if (!isValid.value || loading.value) return
  
  loading.value = true
  try {
    await userApi.resetPassword({
      username: form.value.username,
      password: form.value.password
    })
    
    uni.showToast({
      title: '密码重置成功',
      icon: 'success'
    })
    
    // 跳转到登录页
    setTimeout(() => {
      navigateToLogin()
    }, 1500)
  } catch (error) {
    uni.showToast({
      title: error.data?.error || '密码重置失败',
      icon: 'none'
    })
  } finally {
    loading.value = false
  }
}

// 页面跳转
const navigateToLogin = () => {
  uni.navigateTo({
    url: '/pages/login/index'
  })
}
</script>

<style lang="scss">
.forgot-password-container {
  min-height: 100vh;
  padding: 60rpx 40rpx;
  background-color: #fff;
  
  .logo {
    display: flex;
    justify-content: center;
    margin-bottom: 80rpx;
    
    image {
      width: 200rpx;
      height: 200rpx;
    }
  }
  
  .form-container {
    .form-item {
      margin-bottom: 40rpx;
      
      .label {
        display: block;
        margin-bottom: 16rpx;
        font-size: 28rpx;
        color: #333;
      }
      
      .input {
        width: 100%;
        height: 88rpx;
        padding: 0 30rpx;
        background-color: #f5f5f5;
        border-radius: 44rpx;
        font-size: 28rpx;
      }
    }
    
    .submit-btn {
      width: 100%;
      height: 88rpx;
      line-height: 88rpx;
      margin-top: 60rpx;
      background-color: #007AFF;
      color: #fff;
      border-radius: 44rpx;
      font-size: 32rpx;
      
      &[disabled] {
        opacity: 0.6;
      }
    }
    
    .actions {
      display: flex;
      justify-content: center;
      margin-top: 40rpx;
      
      text {
        font-size: 28rpx;
        color: #007AFF;
      }
    }
  }
}
</style>
