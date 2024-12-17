<template>
  <view class="profile-container">
    <view class="user-info">
      <view class="avatar-section">
        <image 
          class="avatar" 
          :src="userInfo?.avatar || '/static/default-avatar.png'"
          @tap="chooseImage"
        />
        <text v-if="uploading" class="uploading-text">上传中...</text>
      </view>
      <text class="username">{{ userInfo?.username || '未登录' }}</text>
      <text class="email">{{ userInfo?.email }}</text>
    </view>
    
    <view class="stats-cards">
      <view class="stats-card">
        <text class="number">{{ stats.total || 0 }}</text>
        <text class="label">总任务数</text>
      </view>
      <view class="stats-card">
        <text class="number">{{ stats.completed || 0 }}</text>
        <text class="label">已完成</text>
      </view>
      <view class="stats-card">
        <text class="number">{{ stats.pending || 0 }}</text>
        <text class="label">待完成</text>
      </view>
      <view class="stats-card">
        <text class="number">{{ (stats.completion_rate || 0).toFixed(2) }}%</text>
        <text class="label">完成率</text>
      </view>
    </view>
    
    <view class="menu-list">
      <view class="menu-group">
        <view class="menu-item" @click="navigateTo('/pages/category/index')">
          <text class="menu-label">分类管理</text>
          <text class="arrow">></text>
        </view>
      </view>
      
      <view class="menu-group">
        <view class="menu-item" @click="handleChangePassword">
          <text class="menu-label">修改密码</text>
          <text class="arrow">></text>
        </view>
        <view class="menu-item" @click="handleFeedback">
          <text class="menu-label">意见反馈</text>
          <text class="arrow">></text>
        </view>
        <view class="menu-item" @click="handleAbout">
          <text class="menu-label">关于</text>
          <text class="arrow">></text>
        </view>
        <view class="menu-item" @click="handlePrivacy">
          <text class="menu-label">隐私政策</text>
          <text class="arrow">></text>
        </view>
      </view>
    </view>
    
    <view class="logout">
      <button 
        class="logout-btn" 
        @click="handleLogout"
      >
        退出登录
      </button>
    </view>
  </view>
</template>

<script setup>
import { ref, onMounted, onActivated  } from 'vue'
import { storeToRefs } from 'pinia'
import { useUserStore } from '@/store/modules/user'
import { useProfile } from '@/composables/useProfile'
import { useTaskStatsStore } from '@/store/modules/taskStats.js'

// 状态管理
const userStore = useUserStore()
const { userInfo } = storeToRefs(userStore)
const { uploading, uploadAvatar, taskStatsLoading, fetchStats } = useProfile()
const { stats } = useTaskStatsStore()

// 选择并上传图片
const chooseImage = async () => {
  try {
    const { tempFiles } = await uni.chooseImage({
      count: 1,
      sizeType: ['compressed'],
      sourceType: ['album', 'camera']
    })
    
    if (tempFiles[0]) {
      await uploadAvatar(tempFiles[0])
    }
  } catch (error) {
    console.error('选择图片失败:', error)
    uni.showToast({
      title: '选择图片失败',
      icon: 'none'
    })
  }
}

// 页面加载时获取统计数据
onMounted(async () => {
  try {
    // await fetchStats()
  } catch (error) {
    console.error('获取统计数据失败:', error)
  }
})

// 页面跳转
const navigateTo = (url) => {
  uni.navigateTo({ url })
}

// 修改密码
const handleChangePassword = () => {
  uni.navigateTo({
    url: '/pages/change-password/index'
  })
}

// 意见反馈
const handleFeedback = () => {
  uni.navigateTo({
    url: '/pages/feedback/index'
  })
}

// 关于
const handleAbout = () => {
  uni.navigateTo({
    url: '/pages/about/index'
  })
}

// 隐私政策
const handlePrivacy = () => {
  uni.navigateTo({
    url: '/pages/privacy/index'
  })
}

// 退出登录
const handleLogout = async () => {
  try {
    await userStore.logout()
    uni.reLaunch({
      url: '/pages/login/index'
    })
  } catch (error) {
    console.error('退出登录失败:', error)
  }
}

// 页面显示时刷新数据
onActivated (async () => {
  await fetchStats()
  console.log(stats)
})
</script>

<style lang="scss">
.profile-container {
  min-height: 100vh;
  background-color: #f5f5f5;
  
  .user-info {
    padding: 60rpx 40rpx;
    background-color: #fff;
    display: flex;
    flex-direction: column;
    align-items: center;
    
    .avatar-section {
      position: relative;
      margin-bottom: 20rpx;
      
      .avatar {
        width: 160rpx;
        height: 160rpx;
        border-radius: 50%;
        border: 2rpx solid #eee;
      }
      
      .uploading-text {
        position: absolute;
        bottom: -30rpx;
        left: 50%;
        transform: translateX(-50%);
        font-size: 24rpx;
        color: #666;
      }
    }
    
    .username {
      font-size: 36rpx;
      font-weight: bold;
      color: #333;
      margin-bottom: 10rpx;
    }
    
    .email {
      font-size: 28rpx;
      color: #666;
    }
  }
  
  .stats-cards {
    display: flex;
    gap: 20rpx;
    margin-top: 30rpx;
    padding: 0 30rpx;
    
    .stats-card {
      flex: 1;
      background-color: #fff;
      padding: 20rpx;
      border-radius: 12rpx;
      box-shadow: 0 2rpx 10rpx rgba(0,0,0,0.1);
      text-align: center;
      
      .number {
        font-size: 32rpx;
        font-weight: bold;
        color: #333;
        display: block;
      }
      
      .label {
        font-size: 22rpx;
        color: #666;
        margin-top: 10rpx;
        display: block;
        white-space: nowrap;
      }
    }
  }
  
  .menu-list {
    margin: 30rpx;
    
    .menu-group {
      background-color: #fff;
      border-radius: 12rpx;
      margin-bottom: 30rpx;
      
      .menu-item {
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 30rpx;
        border-bottom: 2rpx solid #f5f5f5;
        
        &:last-child {
          border-bottom: none;
        }
        
        .menu-label {
          font-size: 30rpx;
          color: #333;
        }
        
        .arrow {
          font-size: 30rpx;
          color: #999;
        }
      }
    }
  }
  
  .logout {
    padding: 30rpx;
    
    .logout-btn {
      width: 100%;
      height: 90rpx;
      line-height: 90rpx;
      background-color: #ff4d4f;
      color: #fff;
      border-radius: 45rpx;
      font-size: 32rpx;
    }
  }
}
</style>
