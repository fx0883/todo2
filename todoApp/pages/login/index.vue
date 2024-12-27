<template>
  <view class="login-container">
    <view class="logo">
      <image src="/static/logo.png" mode="aspectFit"></image>
    </view>
    
    <view class="form-container" v-if="!isWeixinClient">
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
        :disabled="!isValid || loading || !state.protocol"
        :loading="loading"
        @click="handleLogin"
      >
        {{ loading ? '登录中...' : '登录' }}
      </button>
      <view class="actions" v-if="!isWeixinClient">
        <text @click="navigateToRegister">注册账号</text>
        <text @click="navigateToForgotPassword">忘记密码？</text>
      
      </view>
     
	  
    </view>
    

<view v-if="isWeixinClient" style="height: 220rpx;"></view>
		
	<view class="agreement-box">
	  <label class="radio" @tap="onChange">
	    <radio
	      :checked="state.protocol"
	      color="#007AFF"
	      style="transform: scale(0.8)"
	      @tap.stop="onChange"
	    >
	    <view class="agreement-text">
	      我已阅读并同意
	      <text class="protocol-link" @tap.stop="onProtocol('用户协议')">
	        用户协议
	      </text>
	      <text>与</text>
	      <text class="protocol-link" @tap.stop="onProtocol('隐私协议')">
	        隐私协议
	      </text>
	    </view>
	    </radio>
	  </label>
	</view>
		
	<view v-if="isWeixinClient">
	  <button 
	    class="wechat-btn" 
	    :loading="wxLoading"
	    :disabled="!state.protocol"
	    @click="handleWechatLogin"
	  >
	    <image 
	      src="/static/images/wechat.png" 
	      mode="aspectFit" 
	      class="wechat-icon"
	    />
	    微信一键登录
	  </button>
	</view>
</view>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useAuth } from '@/composables'
const { loading, error, login, wechatLogin } = useAuth()

// 表单数据
const form = ref({
  username: '',
  password: ''
})

// 表单验证
const isValid = computed(() => {
  return form.value.username.trim() && form.value.password.trim()
})

// 微信环境检测
const isWeixinClient = ref(false)
onMounted(() => {
  // #ifdef MP-WEIXIN 
  isWeixinClient.value = true
  // #endif
})

// 用户协议状态
const state = ref({
  protocol: false
})

// 切换协议勾选状态
const onChange = () => {
  state.value.protocol = !state.value.protocol
}

// 查看协议
const onProtocol = (type) => {
  const pages = {
    '用户协议': '/pages/agreement/index',
    '隐私协议': '/pages/privacy/index'
  }
  uni.navigateTo({
    url: pages[type]
  })
}

// 登录处理
const handleLogin = async () => {
  if (!isValid.value || loading.value || !state.value.protocol) return

  // 显示加载中
  uni.showLoading({
    title: '登录中...',
    mask: true
  })

  try {
    const loginParam = {
      username: form.value.username.trim(),
      password: form.value.password
    }
    // 显示加载中
    uni.showLoading({
      title: '登录中...',
      mask: true
    })
    
    const success = await login(loginParam)
    
    // 隐藏加载中
    uni.hideLoading()
    
    if (success) {
      uni.showToast({
        title: '登录成功',
        icon: 'success',
        duration: 1500
      })
      
      // 跳转到主页
      setTimeout(() => {
        uni.switchTab({
          url: '/pages/index/index'
        })
      }, 1500)
    } else {
      uni.showToast({
        title: error.value || '登录失败，请检查用户名和密码',
        icon: 'error',
        duration: 2000
      })
    }
  } catch (err) {
    console.error('Login failed:', err)
    // 隐藏加载中
    uni.hideLoading()
    
    uni.showToast({
      title: err?.data?.error_message || '登录失败，请稍后重试',
      icon: 'error',
      duration: 2000
    })
  } finally {
    // 无论成功失败都隐藏 loading
    uni.hideLoading()
  }
}

// 处理微信登录
const handleWechatLogin = async () => {
  uni.showLoading({
    title: '登录中...',
    mask: true
  })

  try {
    const success = await wechatLogin()
    uni.hideLoading()

    if (success) {
      uni.showToast({
        title: '登录成功',
        icon: 'success',
        duration: 1500
      })
      setTimeout(() => {
        uni.switchTab({
          url: '/pages/index/index'
        })
      }, 1500)
    } else {
      uni.showToast({
        title: error.value || '微信登录失败，请重试',
        icon: 'error',
        duration: 2000
      })
    }
  } catch (err) {
    console.error('WeChat login failed:', err)
    uni.showToast({
      title: err?.data?.error_message || '微信登录失败，请稍后重试',
      icon: 'error',
      duration: 2000
    })
  } finally {
    // 无论成功失败都隐藏 loading
    uni.hideLoading()
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

  .wechat-btn {
    width: 100%;
    max-width: 600rpx;
    height: 88rpx;
    line-height: 88rpx;
    background-color: #07c160;
    color: #fff;
    font-size: 32rpx;
    border-radius: 8rpx;
    display: flex;
    align-items: center;
    justify-content: center;
	margin-top: 50rpx;
    margin-bottom: 30rpx;
    border: none;
    
    .wechat-icon {
      width: 40rpx;
      height: 40rpx;
      margin-right: 10rpx;
    }
    
    &:active {
      opacity: 0.8;
    }

    &[disabled] {
      background-color: #ccc;
      opacity: 0.6;
      cursor: not-allowed;
    }

    &.loading {
      opacity: 0.8;
      cursor: not-allowed;
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
    
    .agreement-box {
      margin: 20rpx 0;
      padding: 0 20rpx;
      
      .radio {
        display: flex;
        align-items: center;
        font-size: 26rpx;
        
        .agreement-text {
          margin-left: 8rpx;
          color: #666;
          display: flex;
          align-items: center;
          flex-wrap: wrap;
        }
        
        .protocol-link {
          color: #007AFF;
          padding: 0 4rpx;
          
          &:active {
            opacity: 0.6;
          }
        }
      }
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
        cursor: not-allowed;
      }

      &.loading {
        opacity: 0.8;
        cursor: not-allowed;
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
