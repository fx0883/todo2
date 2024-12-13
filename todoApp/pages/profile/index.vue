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
import { ref, onMounted, onActivated  } from 'vue'
import { storeToRefs } from 'pinia'
import { useUserStore } from '@/store/modules/user'
import { useTask } from '@/composables/useTask'
import { useAuth } from '@/composables/useAuth'
import { useProfile } from '@/composables/useProfile'

// 使用 composables
const { fetchTaskStats } = useTask()
const { refreshUserData, loading: authLoading } = useAuth()
const { uploading, uploadAvatar } = useProfile()

// 状态管理
const userStore = useUserStore()
const { userInfo } = storeToRefs(userStore)
const stats = ref({ total: 0, completed: 0, pending: 0 })
const loading = ref(false)
const error = ref(null)

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

// 刷新页面数据
const refreshPageData = async () => {
  loading.value = true
  error.value = null
  
  try {
    // 并行请求数据
    await Promise.all([
      refreshUserData(),  // 刷新用户数据
      fetchStats()        // 刷新统计数据
    ])
  } catch (e) {
    error.value = e.message || '获取数据失败'
    uni.showToast({
      title: error.value,
      icon: 'none'
    })
  } finally {
    loading.value = false
  }
}

// 获取任务统计
const fetchStats = async () => {
  try {
    const result = await fetchTaskStats()
    if (result) {
      stats.value = result
    }
  } catch (e) {
    console.error('获取统计失败:', e)
  }
}

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

// 生命周期钩子
onMounted(() => {
  // refreshPageData()
})

// 页面显示时刷新数据
onActivated (() => {
  refreshPageData()
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
