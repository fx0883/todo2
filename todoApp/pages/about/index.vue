<template>
  <view class="about-container">
    <view class="app-info">
      <image class="app-logo" src="/static/logo.png" mode="aspectFit" />
      <text class="app-name">Todo App</text>
      <text class="app-version">Version 1.0.0</text>
    </view>
    
    <view class="info-section">
      <view class="section-title">关于我们</view>
      <view class="section-content">
        Todo App 是一款简单高效的任务管理应用，帮助您更好地规划和完成日常任务。
      </view>
    </view>
    
    <view class="info-section">
      <view class="section-title">主要功能</view>
      <view class="feature-list">
        <view class="feature-item">✓ 任务分类管理</view>
        <view class="feature-item">✓ 任务完成统计</view>
        <view class="feature-item">✓ 任务优先级设置</view>
        <view class="feature-item">✓ 任务提醒</view>
      </view>
    </view>
    
    <view class="info-section">
      <view class="section-title">联系我们</view>
      <view class="section-content">
        如果您有任何问题或建议，欢迎通过以下方式联系我们：
        <view class="contact-item">邮箱：support@todoapp.com</view>
      </view>
    </view>
  </view>
</template>

<script setup>
// 无需额外逻辑
</script>

<style lang="scss">
.about-container {
  padding: 30rpx;
  
  .app-info {
    display: flex;
    flex-direction: column;
    align-items: center;
    margin-bottom: 60rpx;
    
    .app-logo {
      width: 200rpx;
      height: 200rpx;
      margin-bottom: 20rpx;
    }
    
    .app-name {
      font-size: 40rpx;
      font-weight: bold;
      margin-bottom: 10rpx;
    }
    
    .app-version {
      font-size: 24rpx;
      color: #999;
    }
  }
  
  .info-section {
    margin-bottom: 40rpx;
    
    .section-title {
      font-size: 32rpx;
      font-weight: bold;
      margin-bottom: 20rpx;
    }
    
    .section-content {
      font-size: 28rpx;
      color: #666;
      line-height: 1.6;
    }
    
    .feature-list {
      .feature-item {
        font-size: 28rpx;
        color: #666;
        margin-bottom: 10rpx;
        
        &:last-child {
          margin-bottom: 0;
        }
      }
    }
    
    .contact-item {
      margin-top: 10rpx;
      font-size: 28rpx;
      color: #409EFF;
    }
  }
}
</style>
