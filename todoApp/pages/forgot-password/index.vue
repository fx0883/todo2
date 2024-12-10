<template>
  <view class="forgot-password-container">
    <view class="logo">
      <image src="/static/logo.png" mode="aspectFit"></image>
    </view>
    
    <view class="form-container">
      <view class="form-item">
        <text class="label">邮箱</text>
        <input 
          class="input" 
          type="text" 
          v-model="form.email" 
          placeholder="请输入注册邮箱"
          @input="validateEmail"
        />
        <text v-if="errors.email" class="error-text">{{ errors.email }}</text>
      </view>
      
      <view class="form-item">
        <text class="label">新密码</text>
        <input 
          class="input" 
          type="password" 
          v-model="form.password" 
          placeholder="请输入新密码"
          password
          @input="validatePassword"
        />
        <text v-if="errors.password" class="error-text">{{ errors.password }}</text>
      </view>
      
      <view class="form-item">
        <text class="label">确认密码</text>
        <input 
          class="input" 
          type="password" 
          v-model="form.confirmPassword" 
          placeholder="请再次输入新密码"
          password
          @input="validateConfirmPassword"
        />
        <text v-if="errors.confirmPassword" class="error-text">{{ errors.confirmPassword }}</text>
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
        <text @click="navigateToLogin" class="link-text">返回登录</text>
      </view>
    </view>
  </view>
</template>

<script setup>
import { ref, computed } from 'vue'
import { useAuth } from '@/composables'

const { resetPassword } = useAuth()

const loading = ref(false)
const form = ref({
  email: '',
  password: '',
  confirmPassword: ''
})

const errors = ref({
  email: '',
  password: '',
  confirmPassword: ''
})

// 表单验证
const validateEmail = () => {
  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/
  if (!form.value.email) {
    errors.value.email = '请输入邮箱'
  } else if (!emailRegex.test(form.value.email)) {
    errors.value.email = '请输入有效的邮箱地址'
  } else {
    errors.value.email = ''
  }
}

const validatePassword = () => {
  if (!form.value.password) {
    errors.value.password = '请输入新密码'
  } else if (form.value.password.length < 6) {
    errors.value.password = '密码长度至少为6位'
  } else {
    errors.value.password = ''
  }
  validateConfirmPassword()
}

const validateConfirmPassword = () => {
  if (!form.value.confirmPassword) {
    errors.value.confirmPassword = '请确认新密码'
  } else if (form.value.confirmPassword !== form.value.password) {
    errors.value.confirmPassword = '两次输入的密码不一致'
  } else {
    errors.value.confirmPassword = ''
  }
}

const isValid = computed(() => {
  return form.value.email && 
         form.value.password && 
         form.value.confirmPassword && 
         form.value.password === form.value.confirmPassword &&
         !errors.value.email &&
         !errors.value.password &&
         !errors.value.confirmPassword
})

// 重置密码
const handleResetPassword = async () => {
  if (!isValid.value || loading.value) return
  
  validateEmail()
  validatePassword()
  validateConfirmPassword()
  
  if (!isValid.value) return
  
  loading.value = true
  try {
    await resetPassword({
      email: form.value.email,
      password: form.value.password
    })
    
    uni.showToast({
      title: '密码重置成功',
      icon: 'success'
    })
    
    setTimeout(() => {
      navigateToLogin()
    }, 1500)
  } catch (error) {
    uni.showToast({
      title: error.message || '密码重置失败',
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
  padding: 40rpx;
  background-color: #f5f5f5;
  display: flex;
  flex-direction: column;
  align-items: center;
  
  .logo {
    margin: 60rpx 0;
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
      
      .error-text {
        display: block;
        margin-top: 10rpx;
        font-size: 24rpx;
        color: #ff4d4f;
      }
    }
    
    .submit-btn {
      width: 100%;
      height: 88rpx;
      margin-top: 40rpx;
      background-color: #007AFF;
      color: #fff;
      border-radius: 8rpx;
      font-size: 32rpx;
      
      &:disabled {
        background-color: #ccc;
      }
    }
    
    .actions {
      margin-top: 30rpx;
      text-align: center;
      
      .link-text {
        font-size: 28rpx;
        color: #007AFF;
        text-decoration: underline;
      }
    }
  }
}
</style>
