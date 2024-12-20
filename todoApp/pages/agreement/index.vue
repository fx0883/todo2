<template>
  <view class="agreement-container">
    <view class="section">
      <view class="section-title">用户协议</view>
      <view class="update-time">更新日期：2024年12月17日</view>
      
      <view class="content">
        <view class="paragraph">
          欢迎使用Todo App！本协议是您与Todo App之间关于使用本应用服务所订立的协议。使用本应用即表示您同意接受本协议的所有条款。
        </view>
        
        <view class="sub-section">
          <view class="sub-title">1. 服务内容</view>
          <view class="paragraph">
            Todo App提供以下服务：
            <view class="list-item">• 任务管理：创建、编辑、删除任务</view>
            <view class="list-item">• 日程安排：设置任务日期、提醒</view>
            <view class="list-item">• 数据统计：任务完成情况分析</view>
          </view>
        </view>
        
        <view class="sub-section">
          <view class="sub-title">2. 账号注册</view>
          <view class="paragraph">
            用户注册时需要：
            <view class="list-item">• 提供真实、准确的个人信息</view>
            <view class="list-item">• 妥善保管账号密码</view>
            <view class="list-item">• 不得将账号转让或出借给他人</view>
          </view>
        </view>
        
        <view class="sub-section">
          <view class="sub-title">3. 用户义务</view>
          <view class="paragraph">
            用户在使用本应用时应：
            <view class="list-item">• 遵守相关法律法规</view>
            <view class="list-item">• 不得从事违法或有害活动</view>
            <view class="list-item">• 尊重他人的合法权益</view>
          </view>
        </view>
        
        <view class="sub-section">
          <view class="sub-title">4. 知识产权</view>
          <view class="paragraph">
            关于知识产权：
            <view class="list-item">• 应用的所有权利归Todo App所有</view>
            <view class="list-item">• 用户内容的权利归用户所有</view>
            <view class="list-item">• 未经许可不得复制或传播应用内容</view>
          </view>
        </view>
        
        <view class="sub-section">
          <view class="sub-title">5. 服务变更</view>
          <view class="paragraph">
            我们保留以下权利：
            <view class="list-item">• 修改或终止服务的权利</view>
            <view class="list-item">• 更新本协议的权利</view>
            <view class="list-item">• 对违规账号进行处理的权利</view>
          </view>
        </view>
        
        <view class="sub-section">
          <view class="sub-title">6. 联系方式</view>
          <view class="paragraph">
            如有任何问题，请联系我们：
            <view class="list-item">邮箱：support@todoapp.com</view>
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
.agreement-container {
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
