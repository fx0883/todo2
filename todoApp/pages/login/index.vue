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
        />
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
import { useUserStore } from '@/store/user'
import { userApi } from '@/api'

const userStore = useUserStore()
const loading = ref(false)

// 表单数据
const form = ref({
  username: '',
  password: ''
})

// 表单验证
const isValid = computed(() => {
  return form.value.username && form.value.password
})

// 登录
const handleLogin = async () => {
  if (!isValid.value || loading.value) return
  
  loading.value = true
  try {
    const res = await userApi.login(form.value)
    
    // 保存token和refresh token
    userStore.setToken(res.access)
    uni.setStorageSync('refreshToken', res.refresh)
    userStore.setUserInfo(res.user)
    
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
  } catch (error) {
    uni.showToast({
      title: error.data?.error || '登录失败',
      icon: 'none'
    })
  } finally {
    loading.value = false
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
      justify-content: space-between;
      margin-top: 40rpx;
      
      text {
        font-size: 28rpx;
        color: #007AFF;
      }
    }
  }
}
</style>
