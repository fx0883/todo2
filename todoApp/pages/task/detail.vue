<template>
  <view class="task-detail-container">
    <view v-if="task" class="task-content">
      <view class="header">
        <view class="title-row">
          <text class="title">{{ task.title }}</text>
          <view class="status-tag" :class="task.status">
            {{ statusText[task.status] }}
          </view>
        </view>
        
        <view class="info-row">
          <view class="info-item">
            <text class="label">优先级：</text>
            <text class="value" :class="'p' + task.priority">{{ priorityText[task.priority] }}</text>
          </view>
          <view class="info-item">
            <text class="label">截止日期：</text>
            <text class="value">{{ formatTaskDate(task.due_date) }}</text>
          </view>
        </view>
      </view>
      
      <view class="description">
        <text class="section-title">任务描述</text>
        <text class="content">{{ task.description || '暂无描述' }}</text>
      </view>
      

      
      <scroll-view 
        class="comments" 
        scroll-y
        @scrolltolower="onLoadMoreComments"
      >
        <text class="section-title">评论</text>
        <view v-if="comments.length" class="comment-list">
          <view v-for="comment in comments" :key="comment.id" class="comment-item">
            <text class="comment-content">{{ comment.content }}</text>
            <text class="comment-time">{{ formatDate(comment.created_at) }}</text>
          </view>
        </view>
        
        <view v-if="loading && hasMoreComments" class="loading-more">
          加载中...
        </view>
        
        <view v-if="!hasMoreComments && comments.length > 0" class="no-more">
          没有更多评论了
        </view>
        
        <view v-if="!comments.length && !loading" class="empty-comments">
          暂无评论
        </view>
        
        <view class="comment-input">
          <input 
            class="input" 
            type="text" 
            v-model="newComment"
            placeholder="添加评论..."
          />
          <button 
            class="send-btn" 
            :disabled="!newComment.trim()"
            @click="handleAddComment"
          >
            发送
          </button>
        </view>
      </scroll-view>
    </view>
    
    <view v-else class="loading">
      加载中...
    </view>
    
    <view class="action-buttons">
      <button 
        class="action-btn edit" 
        @click="handleEdit"
      >
        编辑任务
      </button>
      <button 
        class="action-btn complete" 
        v-if="task?.status === 'pending'"
        @click="handleComplete"
      >
        完成任务
      </button>
      <button 
        class="action-btn delete" 
        @click="handleDelete"
      >
        删除任务
      </button>
    </view>
  </view>
</template>

<script setup>
import { ref, onMounted, onActivated } from 'vue'
import { storeToRefs } from 'pinia'
import { useTaskStore } from '@/store/modules/task'
import { formatDate } from '@/utils/date'
import { useTask } from '@/composables/useTask'
import { useRoute } from '@/composables/useRoute'

const taskStore = useTaskStore()
const { loading,comments } = storeToRefs(taskStore)
const { getTaskDetail, updateTask, deleteTask, addComment, getTaskComments, loadMoreComments, hasMoreComments } = useTask()
const route = useRoute()
const task = ref(null)
// const comments = ref(taskStore.comments)
const newComment = ref('')

// 状态和优先级文本映射
const statusText = {
  pending: '待完成',
  completed: '已完成',
  overdue: '已逾期'
}

const priorityText = {
  1: '低',
  2: '中',
  3: '高'
}

// 格式化日期函数
const formatTaskDate = (date) => {
  if (!date) return '无截止日期'
  return formatDate(date)
}

// 获取任务详情
const fetchTaskDetail = async () => {
  const taskId = route.params.id
  
  try {
    task.value = await getTaskDetail(taskId)
  } catch (error) {
    uni.showToast({
      title: '获取任务详情失败',
      icon: 'none'
    })
  }
}

// 获取任务评论
const fetchComments = async () => {
  const taskId = route.params.id
  
  try {
    await getTaskComments(taskId)
  } catch (error) {
	console.log(error)
  }
}

// 添加评论
const handleAddComment = async () => {
  if (!newComment.value.trim()) return
  
  try {
    const res = await addComment({
      task_pk: route.params.id,
      content: newComment.value
    })
    newComment.value = ''
  } catch (error) {
    uni.showToast({
      title: '添加评论失败',
      icon: 'none'
    })
  }
}

// 编辑任务
const handleEdit = () => {
  uni.navigateTo({
    url: `/pages/task/edit?id=${task.value.id}`
  })
}

// 完成任务
const handleComplete = async () => {
  try {
    // 准备完整的更新数据
    const updateData = {
      ...task.value,  // 保留任务的所有现有数据
      status: 'completed'  // 只更新状态
    }
    
    const updatedTask = await updateTask(task.value.id, updateData)
    task.value = updatedTask
    
    uni.showToast({
      title: '任务已完成',
      icon: 'success'
    })
  } catch (error) {
    uni.showToast({
      title: '操作失败',
      icon: 'none'
    })
  }
}

// 删除任务
const handleDelete = () => {
  uni.showModal({
    title: '确认删除',
    content: '确定要删除这个任务吗？',
    success: async (res) => {
      if (res.confirm) {
        try {
          await deleteTask(task.value.id)
          
          uni.showToast({
            title: '删除成功',
            icon: 'success'
          })
          
          // 立即返回上一页
          uni.navigateBack()
          
        } catch (error) {
          uni.showToast({
            title: '删除失败',
            icon: 'none'
          })
        }
      }
    }
  })
}

// 加载更多评论
const onLoadMoreComments = async () => {
  if (!hasMoreComments.value || loading.value) return
  try {
    await loadMoreComments(route.params.id)
  } catch (error) {
    uni.showToast({
      title: '加载更多失败',
      icon: 'none'
    })
  }
}



onMounted(async () => {
  await fetchTaskDetail()
  await fetchComments()
})

// 页面显示时刷新数据
onActivated(async () => {
  await fetchTaskDetail()
  await fetchComments()
})
</script>



<style lang="scss">
.task-detail-container {
  min-height: 100vh;
  background-color: #fff;
  padding-bottom: 120rpx;
  
  .task-content {
    padding: 30rpx;
    
    .header {
      margin-bottom: 40rpx;
      
      .title-row {
        display: flex;
        align-items: center;
        justify-content: space-between;
        margin-bottom: 20rpx;
        
        .title {
          font-size: 36rpx;
          font-weight: bold;
          color: #333;
        }
        
        .status-tag {
          padding: 6rpx 20rpx;
          border-radius: 20rpx;
          font-size: 24rpx;
          
          &.pending {
            background-color: #e6f7ff;
            color: #1890ff;
          }
          
          &.completed {
            background-color: #f6ffed;
            color: #52c41a;
          }
          
          &.overdue {
            background-color: #fff2f0;
            color: #ff4d4f;
          }
        }
      }
      
      .info-row {
        display: flex;
        gap: 30rpx;
        
        .info-item {
          display: flex;
          align-items: center;
          
          .label {
            font-size: 26rpx;
            color: #666;
          }
          
          .value {
            font-size: 26rpx;
            color: #333;
            
            &.high {
              color: #ff4d4f;
            }
            
            &.medium {
              color: #faad14;
            }
            
            &.low {
              color: #52c41a;
            }
          }
        }
      }
    }
    
    .description {
      margin-bottom: 40rpx;
      
      .section-title {
        display: block;
        font-size: 30rpx;
        font-weight: bold;
        color: #333;
        margin-bottom: 20rpx;
      }
      
      .content {
        font-size: 28rpx;
        color: #666;
        line-height: 1.6;
      }
    }
    
    .category-tags {
      display: flex;
      flex-wrap: wrap;
      gap: 20rpx;
      margin-bottom: 40rpx;
      
      .category, .tag {
        padding: 6rpx 20rpx;
        border-radius: 20rpx;
        font-size: 24rpx;
      }
      
      .category {
        background-color: #f0f5ff;
        color: #2f54eb;
      }
      
      .tag {
        background-color: #f5f5f5;
        color: #666;
      }
    }
    
    .comments {
      height: calc(100vh - 400rpx);
      overflow-y: auto;
      
      .comment-list {
        margin-bottom: 30rpx;
        
        .comment-item {
          padding: 20rpx;
          background-color: #f5f5f5;
          border-radius: 12rpx;
          margin-bottom: 20rpx;
          
          .comment-content {
            font-size: 28rpx;
            color: #333;
            margin-bottom: 10rpx;
          }
          
          .comment-time {
            font-size: 24rpx;
            color: #999;
          }
        }
      }
      
      .no-comments {
        text-align: center;
        color: #999;
        font-size: 28rpx;
        padding: 40rpx 0;
      }
      
      .comment-input {
        display: flex;
        gap: 20rpx;
        
        .input {
          flex: 1;
          height: 80rpx;
          padding: 0 20rpx;
          background-color: #f5f5f5;
          border-radius: 40rpx;
          font-size: 28rpx;
        }
        
        .send-btn {
          width: 160rpx;
          height: 80rpx;
          line-height: 80rpx;
          background-color: #007AFF;
          color: #fff;
          border-radius: 40rpx;
          font-size: 28rpx;
          
          &:disabled {
            opacity: 0.6;
          }
        }
      }
      
      .loading-more {
        text-align: center;
        padding: 20rpx;
        color: #999;
        font-size: 24rpx;
      }
      
      .no-more {
        text-align: center;
        padding: 20rpx;
        color: #999;
        font-size: 24rpx;
      }
      
      .empty-comments {
        text-align: center;
        padding: 40rpx;
        color: #999;
        font-size: 28rpx;
      }
    }
  }
  
  .action-buttons {
    position: fixed;
    left: 0;
    right: 0;
    bottom: 0;
    padding: 20rpx 30rpx;
    background-color: #fff;
    box-shadow: 0 -2rpx 10rpx rgba(0, 0, 0, 0.05);
    display: flex;
    gap: 20rpx;
    z-index: 100;
    
    // 适配底部安全区
    padding-bottom: calc(20rpx + env(safe-area-inset-bottom));
    
    .action-btn {
      flex: 1;
      height: 80rpx;
      line-height: 80rpx;
      border-radius: 40rpx;
      font-size: 28rpx;
      
      &.edit {
        background-color: #fff;
        color: #007AFF;
        border: 2rpx solid #007AFF;
      }
      
      &.complete {
        background-color: #52c41a;
        color: #fff;
      }
      
      &.delete {
        background-color: #ff4d4f;
        color: #fff;
      }
    }
  }
}
</style>
