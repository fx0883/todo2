<template>
  <view class="category-container">
    <!-- 分类列表 -->
    <scroll-view scroll-y class="category-list">
      <view 
        v-for="category in categories" 
        :key="category.id"
        class="category-item"
      >
        <view class="category-info">
          <view 
            class="category-color"
            :style="{ backgroundColor: category.color }"
          />
          <text class="category-name">{{ category.name }}</text>
          <text class="task-count">({{ category.taskCount || 0 }})</text>
        </view>
        
        <view class="category-actions">
          <button 
            class="action-btn edit-btn"
            @click="handleEdit(category)"
          >
            编辑
          </button>
          <button 
            class="action-btn delete-btn"
            @click="handleDelete(category)"
          >
            删除
          </button>
        </view>
      </view>
    </scroll-view>

    <!-- 悬浮添加按钮 -->
    <view class="floating-add-btn" @click="handleAdd">
      <text>+</text>
    </view>

    <!-- 编辑弹窗 -->
    <uni-popup ref="editPopup" type="center">
      <view class="popup-content">
        <text class="popup-title">{{ editingCategory ? '编辑分类' : '新建分类' }}</text>
        <input 
          class="popup-input"
          type="text"
          v-model="formData.name"
          placeholder="请输入分类名称"
        />
        <view class="popup-buttons">
          <button class="popup-btn cancel" @click="handleCancel">取消</button>
          <button class="popup-btn confirm" @click="handleSave">确定</button>
        </view>
      </view>
    </uni-popup>

    <!-- 删除确认弹窗 -->
    <uni-popup ref="deletePopup" type="center">
      <view class="popup-content">
        <text class="popup-title">删除确认</text>
        <text class="popup-message">确定要删除这个分类吗？该分类下的任务将变为无分类。</text>
        <view class="popup-buttons">
          <button class="popup-btn cancel" @click="cancelDelete">取消</button>
          <button class="popup-btn confirm" @click="confirmDelete">确定</button>
        </view>
      </view>
    </uni-popup>
  </view>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useCategory } from '@/composables/useCategory'

// 使用 composables
const {
  loading,
  categories,
  fetchCategories,
  createCategory,
  updateCategory,
  deleteCategory
} = useCategory()

// 弹窗引用
const editPopup = ref(null)
const deletePopup = ref(null)

// 表单数据
const formData = ref({
  name: '',
  color: '#2196F3'
})

// 编辑状态
const editingCategory = ref(null)

// 获取分类列表
onMounted(async () => {
  await fetchCategories()
})

// 添加分类
const handleAdd = () => {
  editingCategory.value = null
  formData.value.name = ''
  editPopup.value?.open()
}

// 编辑分类
const handleEdit = (category) => {
  editingCategory.value = category
  formData.value.name = category.name
  editPopup.value?.open()
}

// 删除分类
const handleDelete = (category) => {
  editingCategory.value = category
  deletePopup.value?.open()
}

// 取消编辑
const handleCancel = () => {
  editPopup.value?.close()
  editingCategory.value = null
  formData.value.name = ''
}

// 保存分类
const handleSave = async () => {
  if (!formData.value.name.trim()) {
    uni.showToast({
      title: '分类名称不能为空',
      icon: 'none'
    })
    return
  }

  try {
    if (editingCategory.value) {
      await updateCategory(editingCategory.value.id, {
        name: formData.value.name.trim(),
        color: formData.value.color
      })
    } else {
      await createCategory({
        name: formData.value.name.trim(),
        color: formData.value.color
      })
    }
    
    editPopup.value?.close()
    editingCategory.value = null
    formData.value.name = ''
    await fetchCategories()
    
    uni.showToast({
      title: editingCategory.value ? '修改成功' : '添加成功',
      icon: 'success'
    })
  } catch (error) {
    uni.showToast({
      title: error.message || '操作失败',
      icon: 'none'
    })
  }
}

// 确认删除
const confirmDelete = async () => {
  if (!editingCategory.value) return
  
  try {
    await deleteCategory(editingCategory.value.id)
    deletePopup.value?.close()
    editingCategory.value = null
    await fetchCategories()
    
    uni.showToast({
      title: '删除成功',
      icon: 'success'
    })
  } catch (error) {
    uni.showToast({
      title: error.message || '删除失败',
      icon: 'none'
    })
  }
}

// 取消删除
const cancelDelete = () => {
  deletePopup.value?.close()
  editingCategory.value = null
}
</script>

<style lang="scss">
.category-container {
  min-height: 100vh;
  background-color: #f5f5f5;
  padding: 20rpx;
  
  .category-list {
    height: calc(100vh - 40rpx);
  }
  
  .category-item {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 30rpx;
    margin-bottom: 20rpx;
    background-color: #fff;
    border-radius: 12rpx;
    box-shadow: 0 2rpx 4rpx rgba(0, 0, 0, 0.05);
    
    .category-info {
      display: flex;
      align-items: center;
      flex: 1;
      
      .category-color {
        width: 32rpx;
        height: 32rpx;
        border-radius: 50%;
        margin-right: 20rpx;
      }
      
      .category-name {
        font-size: 32rpx;
        color: #333;
      }
      
      .task-count {
        font-size: 28rpx;
        color: #999;
        margin-left: 12rpx;
      }
    }
    
    .category-actions {
      display: flex;
      gap: 20rpx;
      
      .action-btn {
        min-width: 120rpx;
        height: 60rpx;
        line-height: 60rpx;
        font-size: 28rpx;
        margin: 0;
        padding: 0 30rpx;
        border-radius: 30rpx;
        
        &.edit-btn {
          background-color: #e6f7ff;
          color: #1890ff;
        }
        
        &.delete-btn {
          background-color: #fff1f0;
          color: #ff4d4f;
        }
      }
    }
  }
}

.floating-add-btn {
  position: fixed;
  right: 40rpx;
  bottom: calc(140rpx + env(safe-area-inset-bottom));
  width: 96rpx;
  height: 96rpx;
  background-color: #1890ff;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  color: #fff;
  font-size: 48rpx;
  box-shadow: 0 4rpx 12rpx rgba(0, 0, 0, 0.15);
}

.popup-content {
  background-color: #fff;
  border-radius: 12rpx;
  padding: 40rpx;
  width: 600rpx;
  
  .popup-title {
    font-size: 36rpx;
    font-weight: 500;
    text-align: center;
    margin-bottom: 30rpx;
  }
  
  .popup-message {
    font-size: 28rpx;
    color: #666;
    text-align: center;
    margin-bottom: 30rpx;
  }
  
  .popup-input {
    width: 100%;
    height: 80rpx;
    border: 1px solid #e8e8e8;
    border-radius: 8rpx;
    padding: 0 20rpx;
    margin-bottom: 30rpx;
    font-size: 28rpx;
  }
  
  .popup-buttons {
    display: flex;
    justify-content: space-between;
    gap: 20rpx;
    
    .popup-btn {
      flex: 1;
      height: 80rpx;
      line-height: 80rpx;
      text-align: center;
      border-radius: 8rpx;
      font-size: 32rpx;
      margin: 0;
      
      &.cancel {
        background-color: #f5f5f5;
        color: #666;
      }
      
      &.confirm {
        background-color: #1890ff;
        color: #fff;
      }
    }
  }
}
</style>
