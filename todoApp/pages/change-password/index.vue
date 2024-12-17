<template>
  <view class="change-password">
    <view class="form-group">
      <text class="label">新密码</text>
      <input
        v-model="form.new_password"
        class="input"
        type="password"
        placeholder="请输入新密码"
      />
    </view>

    <view class="form-group">
      <text class="label">确认密码</text>
      <input
        v-model="form.confirm_password"
        class="input"
        type="password"
        placeholder="请再次输入新密码"
      />
    </view>

    <view class="form-group">
      <text class="label">验证码</text>
      <view class="code-input">
        <input
          v-model="form.code"
          class="input"
          type="text"
          placeholder="请输入验证码"
        />
        <button 
          class="code-btn" 
          :disabled="cooldown > 0 || isRequesting"
          @tap="handleSendCode"
        >
          {{ cooldown > 0 ? `${cooldown}s` : (isRequesting ? '发送中...' : '获取验证码') }}
        </button>
      </view>
    </view>

    <button 
      class="submit-btn" 
      @tap="handleSubmit"
    >
      确认修改
    </button>
  </view>
</template>

<script setup>
import { ref } from 'vue'
import { usePassword } from '@/composables/usePassword'

const { requestPasswordReset, confirmPasswordReset, isRequesting, isConfirming } = usePassword()
const cooldown = ref(0)
const form = ref({
  new_password: '',
  confirm_password: '',
  code: ''
})

// 发送验证码
const handleSendCode = async () => {
  if (cooldown.value > 0) return

  try {
    await requestPasswordReset()
    // 开始倒计时
    cooldown.value = 60
    const timer = setInterval(() => {
      cooldown.value--
      if (cooldown.value <= 0) {
        clearInterval(timer)
      }
    }, 1000)
  } catch (error) {
    console.error('发送验证码失败:', error)
  }
}

// 提交修改
const handleSubmit = async () => {
  if (!form.value.new_password) {
    uni.showToast({
      title: '请输入新密码',
      icon: 'none'
    })
    return
  }

  if (!form.value.confirm_password) {
    uni.showToast({
      title: '请确认新密码',
      icon: 'none'
    })
    return
  }

  if (form.value.new_password !== form.value.confirm_password) {
    uni.showToast({
      title: '两次输入的密码不一致',
      icon: 'none'
    })
    return
  }

  if (!form.value.code) {
    uni.showToast({
      title: '请输入验证码',
      icon: 'none'
    })
    return
  }

  const success = await confirmPasswordReset({
    token: form.value.code,
    new_password: form.value.new_password,
    confirm_password: form.value.confirm_password
  })

  if (success) {
    // 重置表单
    form.value = {
      new_password: '',
      confirm_password: '',
      code: ''
    }
  }
}
</script>

<style lang="scss">
.change-password {
  padding: 30rpx;

  .form-group {
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
      border: 1px solid #eee;
      border-radius: 8rpx;
      font-size: 28rpx;
    }

    .code-input {
      display: flex;
      align-items: center;
      gap: 20rpx;

      .input {
        flex: 1;
      }

      .code-btn {
        width: 200rpx;
        height: 80rpx;
        line-height: 80rpx;
        font-size: 28rpx;
        background: #007AFF;
        color: #fff;
        border-radius: 8rpx;

        &:active {
          opacity: 0.8;
        }

        &[disabled] {
          opacity: 0.6;
          background: #ccc;
        }
      }
    }
  }

  .submit-btn {
    width: 100%;
    height: 88rpx;
    line-height: 88rpx;
    background: #007AFF;
    color: #fff;
    border-radius: 44rpx;
    font-size: 32rpx;
    margin-top: 60rpx;

    &:active {
      opacity: 0.8;
    }
  }
}
</style>
