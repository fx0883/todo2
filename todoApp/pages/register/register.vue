<template>
  <view class="register-container">
    <view class="register-header">
      <text class="title">创建账号</text>
      <text class="subtitle">加入Todo App，开始管理您的任务</text>
    </view>
    
    <view class="register-form">
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
          type="text" 
          v-model="email" 
          placeholder="请输入邮箱"
          @input="validateEmail"
        />
        <text v-if="emailError" class="error-text">{{ emailError }}</text>
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
      
      <view class="form-item">
        <input 
          class="input" 
          type="password" 
          v-model="confirmPassword" 
          placeholder="请确认密码"
          @input="validateConfirmPassword"
        />
        <text v-if="confirmPasswordError" class="error-text">{{ confirmPasswordError }}</text>
      </view>
      
      <button 
        class="register-btn" 
        :disabled="!isValid || loading" 
        :loading="loading"
        @click="handleRegister"
      >
        注册
      </button>
      
      <view class="actions">
        <text>已有账号？</text>
        <text class="action-link" @click="goToLogin">立即登录</text>
      </view>
    </view>
  </view>
</template>

<script setup>
import { ref, computed } from 'vue'
import { userApi } from '@/api'

// 表单数据
const username = ref('')
const email = ref('')
const password = ref('')
const confirmPassword = ref('')
const usernameError = ref('')
const emailError = ref('')
const passwordError = ref('')
const confirmPasswordError = ref('')
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

const validateEmail = () => {
  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/
  if (!email.value) {
    emailError.value = '邮箱不能为空'
    return false
  }
  if (!emailRegex.test(email.value)) {
    emailError.value = '请输入有效的邮箱地址'
    return false
  }
  emailError.value = ''
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

const validateConfirmPassword = () => {
  if (!confirmPassword.value) {
    confirmPasswordError.value = '请确认密码'
    return false
  }
  if (confirmPassword.value !== password.value) {
    confirmPasswordError.value = '两次输入的密码不一致'
    return false
  }
  confirmPasswordError.value = ''
  return true
}

const isValid = computed(() => {
  return username.value && 
         email.value && 
         password.value && 
         confirmPassword.value && 
         !usernameError.value && 
         !emailError.value && 
         !passwordError.value && 
         !confirmPasswordError.value
})

// 注册处理
const handleRegister = async () => {
  if (!isValid.value || loading.value) return
  
  loading.value = true
  try {
    await userApi.register({
      username: username.value,
      email: email.value,
      password: password.value,
      confirm_password: confirmPassword.value
    })
    
    uni.showToast({
      title: '注册成功',
      icon: 'success'
    })
    
    // 注册成功后跳转到登录页
    setTimeout(() => {
      uni.navigateBack()
    }, 1500)
  } catch (error) {
    uni.showToast({
      title: error.data?.error || '注册失败',
      icon: 'none'
    })
  } finally {
    loading.value = false
  }
}

// 页面跳转
const goToLogin = () => {
  uni.navigateBack()
}
</script>

<style lang="scss">
.register-container {
  padding: 40rpx;
  min-height: 100vh;
  background-color: #fff;
  
  .register-header {
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
  
  .register-form {
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
    
    .register-btn {
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
      text-align: center;
      font-size: 28rpx;
      color: #666;
      
      .action-link {
        color: #007AFF;
        margin-left: 10rpx;
      }
    }
  }
}
</style>
