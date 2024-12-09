<template>
  <view class="category-container">
    <view class="category-list">
      <view 
        v-for="category in categories" 
        :key="category.id" 
        class="category-item"
      >
        <view class="category-info">
          <view 
            class="category-color" 
            :style="{ backgroundColor: category.color }"
          ></view>
          <text class="category-name">{{ category.name }}</text>
          <text class="task-count">({{ category.taskCount || 0 }})</text>
        </view>
        
        <view class="category-actions">
          <button 
            class="action-btn edit" 
            @click="handleEdit(category)"
          >
            编辑
          </button>
          <button 
            class="action-btn delete" 
            @click="handleDelete(category)"
          >
            删除
          </button>
        </view>
      </view>
    </view>
    
    <view class="add-category">
      <button 
        class="add-btn" 
        @click="showAddModal = true"
      >
        新建分类
      </button>
    </view>
    
    <!-- 新建/编辑分类弹窗 -->
    <uni-popup ref="popup" type="center">
      <view class="modal-content">
        <text class="modal-title">{{ editingCategory ? '编辑分类' : '新建分类' }}</text>
        
        <view class="form-item">
          <text class="label">名称</text>
          <input 
            class="input" 
            type="text" 
            v-model="categoryForm.name" 
            placeholder="请输入分类名称"
          />
        </view>
        
        <view class="form-item">
          <text class="label">颜色</text>
          <view class="color-picker">
            <view 
              v-for="color in colors" 
              :key="color"
              class="color-item"
              :class="{ active: categoryForm.color === color }"
              :style="{ backgroundColor: color }"
              @click="categoryForm.color = color"
            ></view>
          </view>
        </view>
        
        <view class="form-item">
          <text class="label">图标</text>
          <input 
            class="input" 
            type="text" 
            v-model="categoryForm.icon" 
            placeholder="请输入图标名称"
          />
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
import { categoryApi } from '@/api'

const taskStore = useTaskStore()
const popup = ref(null)
const showAddModal = ref(false)
const editingCategory = ref(null)
const categories = ref([])

// 预设颜色
const colors = [
  '#f5222d', '#fa8c16', '#fadb14', '#52c41a',
  '#13c2c2', '#1890ff', '#722ed1', '#eb2f96'
]

// 表单数据
const categoryForm = ref({
  name: '',
  color: colors[0],
  icon: ''
})

// 获取分类列表
const fetchCategories = async () => {
  try {
    const res = await categoryApi.getCategories()
    categories.value = res
    taskStore.setCategories(res)
  } catch (error) {
    uni.showToast({
      title: '获取分类失败',
      icon: 'none'
    })
  }
}

// 编辑分类
const handleEdit = (category) => {
  editingCategory.value = category
  categoryForm.value = { ...category }
  showAddModal.value = true
}

// 删除分类
const handleDelete = (category) => {
  uni.showModal({
    title: '确认删除',
    content: '确定要删除这个分类吗？相关任务的分类将被清空',
    success: async (res) => {
      if (res.confirm) {
        try {
          await categoryApi.deleteCategory(category.id)
          await fetchCategories()
          
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
  if (!categoryForm.value.name) {
    uni.showToast({
      title: '请输入分类名称',
      icon: 'none'
    })
    return
  }
  
  try {
    if (editingCategory.value) {
      await categoryApi.updateCategory(
        editingCategory.value.id,
        categoryForm.value
      )
    } else {
      await categoryApi.createCategory(categoryForm.value)
    }
    
    await fetchCategories()
    closeModal()
    
    uni.showToast({
      title: `${editingCategory.value ? '编辑' : '创建'}成功`,
      icon: 'success'
    })
  } catch (error) {
    uni.showToast({
      title: error.data?.error || `${editingCategory.value ? '编辑' : '创建'}失败`,
      icon: 'none'
    })
  }
}

// 关闭弹窗
const closeModal = () => {
  showAddModal.value = false
  editingCategory.value = null
  categoryForm.value = {
    name: '',
    color: colors[0],
    icon: ''
  }
}

onMounted(() => {
  fetchCategories()
})
</script>

<style lang="scss">
.category-container {
  min-height: 100vh;
  background-color: #f5f5f5;
  padding: 30rpx;
  
  .category-list {
    background-color: #fff;
    border-radius: 12rpx;
    padding: 20rpx;
    margin-bottom: 40rpx;
    
    .category-item {
      display: flex;
      align-items: center;
      justify-content: space-between;
      padding: 30rpx;
      border-bottom: 2rpx solid #f5f5f5;
      
      &:last-child {
        border-bottom: none;
      }
      
      .category-info {
        display: flex;
        align-items: center;
        gap: 20rpx;
        
        .category-color {
          width: 32rpx;
          height: 32rpx;
          border-radius: 50%;
        }
        
        .category-name {
          font-size: 30rpx;
          color: #333;
        }
        
        .task-count {
          font-size: 26rpx;
          color: #999;
        }
      }
      
      .category-actions {
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
  
  .add-category {
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
