<template>
  <view class="profile-container">
    <view class="user-info">
      <image 
        class="avatar" 
        :src="userInfo?.avatar || '/static/default-avatar.png'"
      />
      <text class="username">{{ userInfo?.username || '未登录' }}</text>
      <text class="email">{{ userInfo?.email }}</text>
    </view>
    
    <view class="stats-cards">
      <view class="stats-card">
        <text class="number">{{ stats.total || 0 }}</text>
        <text class="label">总任务</text>
      </view>
      <view class="stats-card">
        <text class="number">{{ stats.completed || 0 }}</text>
        <text class="label">已完成</text>
      </view>
      <view class="stats-card">
        <text class="number">{{ stats.pending || 0 }}</text>
        <text class="label">待完成</text>
      </view>
    </view>
    
    <view class="menu-list">
      <view class="menu-group">
        <view class="menu-item" @click="navigateTo('/pages/category/index')">
          <text class="menu-label">分类管理</text>
          <text class="arrow">></text>
        </view>
        <view class="menu-item" @click="navigateTo('/pages/tag/index')">
          <text class="menu-label">标签管理</text>
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
import { ref, onMounted } from 'vue'
import { useUserStore } from '@/store/user'
import { userApi } from '@/api'

const userStore = useUserStore()
const userInfo = ref(null)
const stats = ref({
  total: 0,
  completed: 0,
  pending: 0
})

// 获取用户信息
const fetchUserInfo = () => {
  userInfo.value = userStore.userInfo
}

// 获取任务统计
const fetchStats = async () => {
  try {
    const res = await userApi.getTaskStats()
    stats.value = res
  } catch (error) {
    console.error('获取统计信息失败:', error)
  }
}

// 页面跳转
const navigateTo = (url) => {
  uni.navigateTo({ url })
}

// 修改密码
const handleChangePassword = () => {
  uni.navigateTo({
    url: '/pages/change-password/change-password'
  })
}

// 意见反馈
const handleFeedback = () => {
  uni.navigateTo({
    url: '/pages/feedback/feedback'
  })
}

// 关于
const handleAbout = () => {
  uni.showModal({
    title: '关于 Todo App',
    content: '版本 1.0.0\n一个简单而强大的待办事项管理应用',
    showCancel: false
  })
}

// 退出登录
const handleLogout = () => {
  uni.showModal({
    title: '确认退出',
    content: '确定要退出登录吗？',
    success: (res) => {
      if (res.confirm) {
        userStore.logout()
        uni.reLaunch({
          url: '/pages/login/login'
        })
      }
    }
  })
}

onMounted(() => {
  fetchUserInfo()
  fetchStats()
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
    
    .avatar {
      width: 160rpx;
      height: 160rpx;
      border-radius: 50%;
      margin-bottom: 20rpx;
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
    padding: 30rpx;
    gap: 20rpx;
    
    .stats-card {
      flex: 1;
      background-color: #fff;
      border-radius: 12rpx;
      padding: 30rpx;
      text-align: center;
      
      .number {
        display: block;
        font-size: 40rpx;
        font-weight: bold;
        color: #333;
        margin-bottom: 10rpx;
      }
      
      .label {
        font-size: 26rpx;
        color: #666;
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
