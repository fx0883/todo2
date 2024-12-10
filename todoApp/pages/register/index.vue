<template>
  <view class="register-container">
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
          @keypress.enter="handleRegister"
        />
        <text class="hint" v-if="form.username">用户名长度需要在3-20个字符之间</text>
      </view>
      
      <view class="form-item">
        <text class="label">邮箱</text>
        <input 
          class="input" 
          type="email" 
          v-model="form.email" 
          placeholder="请输入邮箱"
          @keypress.enter="handleRegister"
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
          @keypress.enter="handleRegister"
        />
        <text class="hint" v-if="form.password">密码长度需要在6-20个字符之间</text>
      </view>
      
      <view class="form-item">
        <text class="label">确认密码</text>
        <input 
          class="input" 
          type="password" 
          v-model="form.confirmPassword" 
          placeholder="请再次输入密码"
          password
          @keypress.enter="handleRegister"
        />
        <text class="error" v-if="passwordMismatch">两次输入的密码不一致</text>
      </view>

      <view class="error-message" v-if="error">
        {{ error }}
      </view>
      
      <button 
        class="submit-btn" 
        :disabled="!isValid || loading"
        :loading="loading"
        @click="handleRegister"
      >
        注册
      </button>
      
      <view class="actions">
        <text @click="navigateToLogin">已有账号？去登录</text>
      </view>
    </view>
  </view>
</template>

<script setup>
import { ref, computed } from 'vue'
import { useAuth } from '@/composables'

const { loading, error, register } = useAuth()

// 表单数据
const form = ref({
  username: '',
  email: '',
  password: '',
  confirmPassword: ''
})

// 表单验证
const isUsernameValid = computed(() => {
  const username = form.value.username.trim()
  return username.length >= 3 && username.length <= 20
})

const isEmailValid = computed(() => {
  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/
  return emailRegex.test(form.value.email.trim())
})

const isPasswordValid = computed(() => {
  const password = form.value.password
  return password.length >= 6 && password.length <= 20
})

const passwordMismatch = computed(() => {
  return form.value.password && 
         form.value.confirmPassword && 
         form.value.password !== form.value.confirmPassword
})

const isValid = computed(() => {
  return isUsernameValid.value && 
         isEmailValid.value && 
         isPasswordValid.value && 
         !passwordMismatch.value
})

// 注册处理
const handleRegister = async () => {
  if (!isValid.value || loading.value) return

  try {
    await register({
      username: form.value.username.trim(),
      email: form.value.email.trim(),
      password: form.value.password,
      confirm_password: form.value.confirmPassword
    })
    
    uni.showToast({
      title: '注册成功',
      icon: 'success'
    })
    
    // 跳转到登录页
    setTimeout(() => {
      navigateToLogin()
    }, 1500)
  } catch (err) {
    // 错误已经在 useAuth 中处理
    console.error('Registration failed:', err)
  }
}

// 页面跳转
const navigateToLogin = () => {
  uni.navigateBack()
}
</script>

<style lang="scss">
.register-container {
  min-height: 100vh;
  padding: 40rpx;
  background-color: #f8f8f8;
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

      .hint {
        display: block;
        margin-top: 6rpx;
        font-size: 24rpx;
        color: #999;
      }

      .error {
        display: block;
        margin-top: 6rpx;
        font-size: 24rpx;
        color: #ff4d4f;
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
      justify-content: center;
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
