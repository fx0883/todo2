<template>
  <view class="privacy-container">
    <view class="section">
      <view class="section-title">隐私政策</view>
      <view class="update-time">更新日期：2024年12月17日</view>
      
      <view class="content">
        <view class="paragraph">
          欢迎使用Todo App！我们非常重视您的个人隐私和数据安全。本隐私政策将帮助您了解我们如何收集、使用和保护您的个人信息。
        </view>
        
        <view class="sub-section">
          <view class="sub-title">1. 信息收集</view>
          <view class="paragraph">
            我们收集的信息包括：
            <view class="list-item">• 账户信息：用户名、密码（加密存储）</view>
            <view class="list-item">• 任务数据：您创建的任务内容、分类、完成状态</view>
            <view class="list-item">• 使用数据：应用使用频率、功能使用情况</view>
          </view>
        </view>
        
        <view class="sub-section">
          <view class="sub-title">2. 信息使用</view>
          <view class="paragraph">
            我们使用收集的信息：
            <view class="list-item">• 提供、维护和改进我们的服务</view>
            <view class="list-item">• 个性化您的使用体验</view>
            <view class="list-item">• 发送服务相关通知</view>
          </view>
        </view>
        
        <view class="sub-section">
          <view class="sub-title">3. 信息安全</view>
          <view class="paragraph">
            我们采取多种安全措施保护您的个人信息：
            <view class="list-item">• 使用加密技术保护数据传输</view>
            <view class="list-item">• 定期备份数据</view>
            <view class="list-item">• 严格的访问控制</view>
          </view>
        </view>
        
        <view class="sub-section">
          <view class="sub-title">4. 信息共享</view>
          <view class="paragraph">
            我们不会出售、出租或以其他方式与第三方共享您的个人信息，除非：
            <view class="list-item">• 获得您的明确同意</view>
            <view class="list-item">• 法律法规要求</view>
            <view class="list-item">• 保护我们的合法权益</view>
          </view>
        </view>
        
        <view class="sub-section">
          <view class="sub-title">5. 您的权利</view>
          <view class="paragraph">
            您对自己的个人信息拥有以下权利：
            <view class="list-item">• 访问和查看个人信息</view>
            <view class="list-item">• 更正或更新个人信息</view>
            <view class="list-item">• 删除个人信息</view>
            <view class="list-item">• 撤回同意</view>
          </view>
        </view>
        
        <view class="sub-section">
          <view class="sub-title">6. 联系我们</view>
          <view class="paragraph">
            如果您对本隐私政策有任何疑问或建议，请通过以下方式联系我们：
            <view class="list-item">邮箱：privacy@todoapp.com</view>
          </view>
        </view>
      </view>
    </view>
  </view>
</template>

<script setup>
// 无需额外逻辑
</script>

<style lang="scss">
.privacy-container {
  padding: 30rpx;
  
  .section {
    .section-title {
      font-size: 36rpx;
      font-weight: bold;
      text-align: center;
      margin-bottom: 20rpx;
    }
    
    .update-time {
      font-size: 24rpx;
      color: #999;
      text-align: center;
      margin-bottom: 40rpx;
    }
    
    .content {
      .paragraph {
        font-size: 28rpx;
        color: #333;
        line-height: 1.6;
        margin-bottom: 30rpx;
      }
      
      .sub-section {
        margin-bottom: 40rpx;
        
        .sub-title {
          font-size: 32rpx;
          font-weight: bold;
          margin-bottom: 20rpx;
        }
        
        .list-item {
          font-size: 28rpx;
          color: #333;
          line-height: 1.6;
          margin-left: 20rpx;
          margin-bottom: 10rpx;
        }
      }
    }
  }
}
</style>
