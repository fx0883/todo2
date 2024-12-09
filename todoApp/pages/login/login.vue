<template>
  <view class="login-container">
    <view class="login-header">
      <text class="title">Todo App</text>
      <text class="subtitle">登录您的账号</text>
    </view>
    
    <view class="login-form">
      <view class="form-item">
        <input 
          class="input" 
          type="text" 
          v-model="username" 
          placeholder="请输入用户名"
          @input="validateUsername"
        />
        <text v-if="usernameError" class="error-text">{{ usernameError }}</text>
      </view>
      
      <view class="form-item">
        <input 
          class="input" 
          type="password" 
          v-model="password" 
          placeholder="请输入密码"
          @input="validatePassword"
        />
        <text v-if="passwordError" class="error-text">{{ passwordError }}</text>
      </view>
      
      <button 
        class="login-btn" 
        :disabled="!isValid || loading" 
        :loading="loading"
        @click="handleLogin"
      >
        登录
      </button>
      
      <view class="actions">
        <text class="action-link" @click="goToRegister">注册账号</text>
        <text class="action-link" @click="goToResetPassword">忘记密码？</text>
      </view>
    </view>
  </view>
</template>

<script setup>
import { ref, computed } from 'vue'
import { useUserStore } from '@/store/user'
import { userApi } from '@/api'

const userStore = useUserStore()

// 表单数据
const username = ref('')
const password = ref('')
const usernameError = ref('')
const passwordError = ref('')
const loading = ref(false)

// 表单验证
const validateUsername = () => {
  if (!username.value) {
    usernameError.value = '用户名不能为空'
    return false
  }
  if (username.value.length < 3) {
    usernameError.value = '用户名至少3个字符'
    return false
  }
  usernameError.value = ''
  return true
}

const validatePassword = () => {
  if (!password.value) {
    passwordError.value = '密码不能为空'
    return false
  }
  if (password.value.length < 6) {
    passwordError.value = '密码至少6个字符'
    return false
  }
  passwordError.value = ''
  return true
}

const isValid = computed(() => {
  return username.value && 
         password.value && 
         !usernameError.value && 
         !passwordError.value
})

// 登录处理
const handleLogin = async () => {
  if (!isValid.value || loading.value) return
  
  loading.value = true
  try {
    const res = await userApi.login({
      username: username.value,
      password: password.value
    })
    
    // 保存token和用户信息
    userStore.setToken(res.access)
    
    uni.showToast({
      title: '登录成功',
      icon: 'success'
    })
    
    // 跳转到首页
    uni.reLaunch({
      url: '/pages/index/index'
    })
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
const goToRegister = () => {
  uni.navigateTo({
    url: '/pages/register/register'
  })
}

const goToResetPassword = () => {
  uni.navigateTo({
    url: '/pages/reset-password/reset-password'
  })
}
</script>

<style lang="scss">
.login-container {
  padding: 40rpx;
  min-height: 100vh;
  background-color: #fff;
  
  .login-header {
    margin: 60rpx 0;
    text-align: center;
    
    .title {
      font-size: 48rpx;
      font-weight: bold;
      color: #333;
    }
    
    .subtitle {
      margin-top: 20rpx;
      font-size: 28rpx;
      color: #666;
    }
  }
  
  .login-form {
    margin-top: 60rpx;
    
    .form-item {
      margin-bottom: 30rpx;
      
      .input {
        height: 90rpx;
        padding: 0 30rpx;
        background-color: #f5f5f5;
        border-radius: 45rpx;
        font-size: 28rpx;
      }
      
      .error-text {
        margin-top: 10rpx;
        padding-left: 30rpx;
        font-size: 24rpx;
        color: #ff4d4f;
      }
    }
    
    .login-btn {
      margin-top: 60rpx;
      height: 90rpx;
      line-height: 90rpx;
      background-color: #007AFF;
      color: #fff;
      border-radius: 45rpx;
      font-size: 32rpx;
      
      &:disabled {
        opacity: 0.6;
      }
    }
    
    .actions {
      margin-top: 40rpx;
      display: flex;
      justify-content: space-between;
      
      .action-link {
        font-size: 28rpx;
        color: #007AFF;
      }
    }
  }
}
</style>
