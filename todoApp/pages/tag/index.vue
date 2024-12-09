<template>
  <view class="tag-container">
    <view class="tag-list">
      <view 
        v-for="tag in tags" 
        :key="tag.id" 
        class="tag-item"
      >
        <view class="tag-info">
          <view 
            class="tag-color" 
            :style="{ backgroundColor: tag.color }"
          ></view>
          <text class="tag-name">{{ tag.name }}</text>
        </view>
        
        <view class="tag-actions">
          <button 
            class="action-btn edit" 
            @click="handleEdit(tag)"
          >
            编辑
          </button>
          <button 
            class="action-btn delete" 
            @click="handleDelete(tag)"
          >
            删除
          </button>
        </view>
      </view>
    </view>
    
    <view class="add-tag">
      <button 
        class="add-btn" 
        @click="showAddModal = true"
      >
        新建标签
      </button>
    </view>
    
    <!-- 新建/编辑标签弹窗 -->
    <uni-popup ref="popup" type="center">
      <view class="modal-content">
        <text class="modal-title">{{ editingTag ? '编辑标签' : '新建标签' }}</text>
        
        <view class="form-item">
          <text class="label">名称</text>
          <input 
            class="input" 
            type="text" 
            v-model="tagForm.name" 
            placeholder="请输入标签名称"
          />
        </view>
        
        <view class="form-item">
          <text class="label">颜色</text>
          <view class="color-picker">
            <view 
              v-for="color in colors" 
              :key="color"
              class="color-item"
              :class="{ active: tagForm.color === color }"
              :style="{ backgroundColor: color }"
              @click="tagForm.color = color"
            ></view>
          </view>
        </view>
        
        <view class="modal-actions">
          <button 
            class="cancel-btn" 
            @click="closeModal"
          >
            取消
          </button>
          <button 
            class="confirm-btn" 
            @click="handleSubmit"
          >
            确定
          </button>
        </view>
      </view>
    </uni-popup>
  </view>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useTaskStore } from '@/store/task'
import { tagApi } from '@/api'

const taskStore = useTaskStore()
const popup = ref(null)
const showAddModal = ref(false)
const editingTag = ref(null)
const tags = ref([])

// 预设颜色
const colors = [
  '#f5222d', '#fa8c16', '#fadb14', '#52c41a',
  '#13c2c2', '#1890ff', '#722ed1', '#eb2f96'
]

// 表单数据
const tagForm = ref({
  name: '',
  color: colors[0]
})

// 获取标签列表
const fetchTags = async () => {
  try {
    const res = await tagApi.getTags()
    tags.value = res
    taskStore.setTags(res)
  } catch (error) {
    uni.showToast({
      title: '获取标签失败',
      icon: 'none'
    })
  }
}

// 编辑标签
const handleEdit = (tag) => {
  editingTag.value = tag
  tagForm.value = { ...tag }
  showAddModal.value = true
}

// 删除标签
const handleDelete = (tag) => {
  uni.showModal({
    title: '确认删除',
    content: '确定要删除这个标签吗？',
    success: async (res) => {
      if (res.confirm) {
        try {
          await tagApi.deleteTag(tag.id)
          await fetchTags()
          
          uni.showToast({
            title: '删除成功',
            icon: 'success'
          })
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

// 提交表单
const handleSubmit = async () => {
  if (!tagForm.value.name) {
    uni.showToast({
      title: '请输入标签名称',
      icon: 'none'
    })
    return
  }
  
  try {
    if (editingTag.value) {
      await tagApi.updateTag(
        editingTag.value.id,
        tagForm.value
      )
    } else {
      await tagApi.createTag(tagForm.value)
    }
    
    await fetchTags()
    closeModal()
    
    uni.showToast({
      title: `${editingTag.value ? '编辑' : '创建'}成功`,
      icon: 'success'
    })
  } catch (error) {
    uni.showToast({
      title: error.data?.error || `${editingTag.value ? '编辑' : '创建'}失败`,
      icon: 'none'
    })
  }
}

// 关闭弹窗
const closeModal = () => {
  showAddModal.value = false
  editingTag.value = null
  tagForm.value = {
    name: '',
    color: colors[0]
  }
}

onMounted(() => {
  fetchTags()
})
</script>

<style lang="scss">
.tag-container {
  min-height: 100vh;
  background-color: #f5f5f5;
  padding: 30rpx;
  
  .tag-list {
    background-color: #fff;
    border-radius: 12rpx;
    padding: 20rpx;
    margin-bottom: 40rpx;
    
    .tag-item {
      display: flex;
      align-items: center;
      justify-content: space-between;
      padding: 30rpx;
      border-bottom: 2rpx solid #f5f5f5;
      
      &:last-child {
        border-bottom: none;
      }
      
      .tag-info {
        display: flex;
        align-items: center;
        gap: 20rpx;
        
        .tag-color {
          width: 32rpx;
          height: 32rpx;
          border-radius: 50%;
        }
        
        .tag-name {
          font-size: 30rpx;
          color: #333;
        }
      }
      
      .tag-actions {
        display: flex;
        gap: 20rpx;
        
        .action-btn {
          min-width: 120rpx;
          height: 60rpx;
          line-height: 60rpx;
          font-size: 26rpx;
          border-radius: 30rpx;
          
          &.edit {
            background-color: #fff;
            color: #007AFF;
            border: 2rpx solid #007AFF;
          }
          
          &.delete {
            background-color: #fff;
            color: #ff4d4f;
            border: 2rpx solid #ff4d4f;
          }
        }
      }
    }
  }
  
  .add-tag {
    .add-btn {
      width: 100%;
      height: 90rpx;
      line-height: 90rpx;
      background-color: #007AFF;
      color: #fff;
      border-radius: 45rpx;
      font-size: 32rpx;
    }
  }
  
  .modal-content {
    width: 600rpx;
    background-color: #fff;
    border-radius: 20rpx;
    padding: 40rpx;
    
    .modal-title {
      font-size: 36rpx;
      font-weight: bold;
      color: #333;
      text-align: center;
      margin-bottom: 40rpx;
    }
    
    .form-item {
      margin-bottom: 30rpx;
      
      .label {
        display: block;
        font-size: 28rpx;
        color: #333;
        margin-bottom: 10rpx;
      }
      
      .input {
        width: 100%;
        height: 80rpx;
        padding: 0 20rpx;
        background-color: #f5f5f5;
        border-radius: 12rpx;
        font-size: 28rpx;
      }
      
      .color-picker {
        display: flex;
        flex-wrap: wrap;
        gap: 20rpx;
        
        .color-item {
          width: 60rpx;
          height: 60rpx;
          border-radius: 50%;
          border: 4rpx solid transparent;
          
          &.active {
            border-color: #333;
          }
        }
      }
    }
    
    .modal-actions {
      display: flex;
      gap: 20rpx;
      margin-top: 40rpx;
      
      button {
        flex: 1;
        height: 80rpx;
        line-height: 80rpx;
        border-radius: 40rpx;
        font-size: 30rpx;
      }
      
      .cancel-btn {
        background-color: #f5f5f5;
        color: #666;
      }
      
      .confirm-btn {
        background-color: #007AFF;
        color: #fff;
      }
    }
  }
}
</style>
