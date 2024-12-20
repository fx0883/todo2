<template>
  <view class="protocol-container">
    <view class="header">
      <text class="title">{{ protocolConfig[type]?.title || type }}</text>
    </view>
    <scroll-view 
      class="content" 
      scroll-y
    >
      <rich-text :nodes="protocolConfig[type]?.content || ''"></rich-text>
    </scroll-view>
  </view>
</template>

<script setup>
import { ref, onMounted } from 'vue'

// 获取页面参数
const type = ref('')

onMounted(() => {
  const pages = getCurrentPages()
  const page = pages[pages.length - 1]
  type.value = page.$page?.options?.type || ''
})

// 协议配置
const protocolConfig = {
  '用户协议': {
    title: '用户协议',
    content: `
      <div style="padding: 20px;">
        <h3>一、总则</h3>
        <p>1.1 用户应当同意本协议的条款并按照页面上的提示完成全部的注册程序。</p>
        <p>1.2 用户在注册过程中点击"同意"按钮即表示用户完全接受本协议项下的全部条款。</p>
        
        <h3>二、服务内容</h3>
        <p>2.1 本应用的具体内容由本应用根据实际情况提供。</p>
        <p>2.2 本应用的部分服务是以收费方式提供的，如用户使用收费服务，请遵守相关的协议。</p>
        
        <h3>三、用户个人隐私信息保护</h3>
        <p>3.1 用户在注册帐号或使用本服务的过程中，可能需要填写或提交一些必要的信息。</p>
        <p>3.2 本应用将尽可能采取适当的安全措施来保护用户的个人隐私信息。</p>
        
        <h3>四、用户注册义务</h3>
        <p>4.1 为了能使用本服务，您同意以下事项：</p>
        <p>a) 依本服务注册表的提示提供您本人的真实、正确、最新及完整的资料。</p>
        <p>b) 维持并更新您个人资料，确保其为真实、正确、最新及完整。</p>
      </div>
    `
  },
  '隐私协议': {
    title: '隐私协议',
    content: `
      <div style="padding: 20px;">
        <h3>一、信息收集</h3>
        <p>1.1 我们可能收集您的以下信息：</p>
        <p>- 账号信息（用户名、密码等）</p>
        <p>- 个人信息（昵称、头像等）</p>
        <p>- 设备信息（设备型号、操作系统等）</p>
        
        <h3>二、信息使用</h3>
        <p>2.1 我们使用收集的信息用于：</p>
        <p>- 提供、维护和改进我们的服务</p>
        <p>- 开发新的服务和功能</p>
        <p>- 保护用户和公众的安全</p>
        
        <h3>三、信息共享</h3>
        <p>3.1 我们不会与第三方分享您的个人信息，除非：</p>
        <p>- 获得您的明确同意</p>
        <p>- 法律要求我们这样做</p>
        
        <h3>四、信息安全</h3>
        <p>4.1 我们采取适当的技术和组织措施来保护您的个人信息。</p>
        <p>4.2 我们定期审查我们的信息收集、存储和处理实践。</p>
      </div>
    `
  }
}
</script>

<style lang="scss">
.protocol-container {
  min-height: 100vh;
  background-color: #fff;
  display: flex;
  flex-direction: column;
  
  .header {
    height: 88rpx;
    display: flex;
    align-items: center;
    justify-content: center;
    background-color: #fff;
    border-bottom: 1px solid #eee;
    position: sticky;
    top: 0;
    z-index: 100;
    
    .title {
      font-size: 32rpx;
      font-weight: 500;
      color: #333;
    }
  }
  
  .content {
    flex: 1;
    padding: 30rpx;
    
    :deep(h3) {
      font-size: 32rpx;
      font-weight: 500;
      color: #333;
      margin: 30rpx 0 20rpx;
    }
    
    :deep(p) {
      font-size: 28rpx;
      color: #666;
      line-height: 1.6;
      margin-bottom: 16rpx;
    }
  }
}
</style>
