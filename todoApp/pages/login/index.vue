<template>
  <view class="login-container">
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
          @keypress.enter="handleLogin"
        />
      </view>
      
      <view class="form-item">
        <text class="label">密码</text>
        <input 
          class="input" 
          type="password" 
          v-model="form.password" 
          placeholder="请输入密码"
          password
          @keypress.enter="handleLogin"
        />
      </view>

      <view class="error-message" v-if="error">
        {{ error }}
      </view>
      
      <button 
        class="submit-btn" 
        :disabled="!isValid || loading"
        :loading="loading"
        @click="handleLogin"
      >
        登录
      </button>
      
      <view class="actions">
        <text @click="navigateToRegister">注册账号</text>
        <text @click="navigateToForgotPassword">忘记密码？</text>
      </view>
    </view>
  </view>
</template>

<script setup>
import { ref, computed } from 'vue'
import { useAuth } from '@/composables'

const { loading, error, login } = useAuth()

// 表单数据
const form = ref({
  username: '',
  password: ''
})

// 表单验证
const isValid = computed(() => {
  return form.value.username.trim() && form.value.password.trim()
})

// 登录处理
const handleLogin = async () => {
  if (!isValid.value || loading.value) return

  try {
    const loginParam = {
      username: form.value.username.trim(),
      password: form.value.password
    }
    const success = await login(loginParam)
    
    if (success) {
      uni.showToast({
        title: '登录成功',
        icon: 'success'
      })
      
      // 跳转到主页
      setTimeout(() => {
        uni.switchTab({
          url: '/pages/index/index'
        })
      }, 1500)
    } else {
      uni.showToast({
        title: '登录失败',
        icon: 'error'
      })
    }
  } catch (err) {
    console.error('Login failed:', err)
    uni.showToast({
      title: '登录失败',
      icon: 'error'
    })
  }
}

// 页面跳转
const navigateToRegister = () => {
  uni.navigateTo({
    url: '/pages/register/index'
  })
}

const navigateToForgotPassword = () => {
  uni.navigateTo({
    url: '/pages/forgot-password/index'
  })
}
</script>

<style lang="scss">
.login-container {
  min-height: 100vh;
  padding: 40rpx;
  background-color: #f8f8f8;
  display: flex;
  flex-direction: column;
  align-items: center;
  
  .logo {
    margin: 80rpx 0;
    width: 200rpx;
    height: 200rpx;
    
    image {
      width: 100%;
      height: 100%;
    }
  }
  
  .form-container {
    width: 100%;
    max-width: 600rpx;
    padding: 40rpx;
    background-color: #fff;
    border-radius: 20rpx;
    box-shadow: 0 4rpx 12rpx rgba(0, 0, 0, 0.1);
    
    .form-item {
      margin-bottom: 30rpx;
      
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
        border: 2rpx solid #ddd;
        border-radius: 8rpx;
        font-size: 28rpx;
        
        &:focus {
          border-color: #007AFF;
        }
      }
    }

    .error-message {
      color: #ff4d4f;
      font-size: 24rpx;
      margin-bottom: 20rpx;
      text-align: center;
    }
    
    .submit-btn {
      width: 100%;
      height: 80rpx;
      line-height: 80rpx;
      background-color: #007AFF;
      color: #fff;
      font-size: 32rpx;
      border-radius: 8rpx;
      margin: 40rpx 0;
      
      &:active {
        opacity: 0.8;
      }
      
      &[disabled] {
        background-color: #ccc;
        opacity: 0.6;
      }
    }
    
    .actions {
      display: flex;
      justify-content: space-between;
      font-size: 26rpx;
      color: #007AFF;
      
      text {
        padding: 10rpx;
        
        &:active {
          opacity: 0.6;
        }
      }
    }
  }
}
</style>
