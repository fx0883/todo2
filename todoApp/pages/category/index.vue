<template>
  <view class="category-container" ref="categoryPage">
    <!-- 加载状态 -->
    <uni-load-more v-if="loading" status="loading" />
    
    <!-- 分类列表 -->
    <view class="category-list" v-else>
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
          <text class="task-count">({{ category.taskCount }})</text>
        </view>
        
        <view class="category-actions">
          <button 
            class="edit-btn"
            @click="handleEdit(category)"
          >
            编辑
          </button>
          <button 
            class="delete-btn"
            @click="handleDelete(category)"
          >
            删除
          </button>
        </view>
      </view>
    </view>
    
    <!-- 编辑弹窗 -->
    <uni-popup ref="editPopup" type="center">
      <view class="dialog-content">
        <text class="dialog-title">{{ editingCategory ? '编辑分类' : '新建分类' }}</text>
        <input 
          class="dialog-input"
          type="text"
          v-model="formData.name"
          placeholder="请输入分类名称"
        />
        <view class="dialog-buttons">
          <button 
            class="dialog-button cancel"
            @click="handleCancel"
          >
            取消
          </button>
          <button 
            class="dialog-button confirm"
            @click="handleSave(formData.name)"
          >
            确定
          </button>
        </view>
      </view>
    </uni-popup>

    <!-- 删除确认弹窗 -->
    <uni-popup ref="deletePopup" type="center">
      <view class="dialog-content">
        <text class="dialog-title">删除确认</text>
        <text class="dialog-message">确定要删除这个分类吗？该分类下的任务将变为无分类。</text>
        <view class="dialog-buttons">
          <button 
            class="dialog-button cancel"
            @click="cancelDelete"
          >
            取消
          </button>
          <button 
            class="dialog-button confirm"
            @click="confirmDelete"
          >
            确定
          </button>
        </view>
      </view>
    </uni-popup>
    
    <!-- 悬浮添加按钮 -->
    <button class="floating-add-btn" @click="handleAdd">
      添加分类
    </button>
  </view>
</template>

<script>
export default {
  onNavigationBarButtonTap() {
    console.log('选项式 API - onNavigationBarButtonTap 被调用')
    if (this.handleAdd) {
      console.log('调用 handleAdd')
      this.handleAdd()
    } else {
      console.log('handleAdd 不存在')
    }
  }
}
</script>

<script setup>
import { ref, onMounted, getCurrentInstance } from 'vue'
import { useCategory } from '@/composables/useCategory'
import { onReady } from '@dcloudio/uni-app'

// 使用 composables
const {
  loading,
  categories,
  fetchCategories,
  createCategory,
  updateCategory,
  deleteCategory
} = useCategory()

// 表单数据
const formData = ref({
  name: '',
  color: '#2196F3'
})

// 编辑状态
const editingCategory = ref(null)
const editPopup = ref(null)
const deletePopup = ref(null)

// 获取分类列表
onMounted(async () => {
  await fetchCategories()
})

// 导航栏按钮点击处理
const onNavigationBarButtonTap = () => {
  console.log('组合式 API - onNavigationBarButtonTap 被调用')
  handleAdd()
}

// 添加分类
const handleAdd = () => {
  console.log('handleAdd 被调用')
  editingCategory.value = null
  formData.value.name = ''
  editPopup.value?.open()
}

// 获取当前组件实例
const instance = getCurrentInstance()
if (instance) {
  // 将 handleAdd 方法添加到组件实例上
  instance.proxy.handleAdd = handleAdd
}

// 编辑分类
const handleEdit = (category) => {
  console.log('handleEdit 被调用')
  editingCategory.value = category
  formData.value.name = category.name
  editPopup.value?.open()
}

// 删除分类
const handleDelete = (category) => {
  console.log('handleDelete 被调用')
  editingCategory.value = category
  deletePopup.value?.open()
}

// 取消编辑
const handleCancel = () => {
  console.log('handleCancel 被调用')
  editPopup.value?.close()
  editingCategory.value = null
  formData.value.name = ''
}

// 保存分类
const handleSave = async (name) => {
  console.log('handleSave 被调用')
  if (!name.trim()) {
    uni.showToast({
      title: '分类名称不能为空',
      icon: 'none'
    })
    return
  }

  try {
    if (editingCategory.value) {
      await updateCategory({
        id: editingCategory.value.id,
        name: name.trim(),
        color: formData.value.color
      })
    } else {
      await createCategory({
        name: name.trim(),
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
  console.log('confirmDelete 被调用')
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
  console.log('cancelDelete 被调用')
  deletePopup.value?.close()
  editingCategory.value = null
}
</script>

<style lang="scss">
.category-container {
  padding: 20rpx;
  position: relative;
  
  .category-list {
    margin-bottom: 20rpx;
    
    .category-item {
      display: flex;
      justify-content: space-between;
      align-items: center;
      padding: 20rpx;
      margin-bottom: 20rpx;
      background-color: #fff;
      border-radius: 10rpx;
      box-shadow: 0 2rpx 4rpx rgba(0, 0, 0, 0.1);
      
      .category-info {
        display: flex;
        align-items: center;
        
        .category-color {
          width: 30rpx;
          height: 30rpx;
          border-radius: 50%;
          margin-right: 20rpx;
        }
        
        .category-name {
          font-size: 28rpx;
          color: #333;
        }
        
        .task-count {
          font-size: 24rpx;
          color: #999;
          margin-left: 10rpx;
        }
      }
      
      .category-actions {
        display: flex;
        gap: 20rpx;
        
        button {
          font-size: 24rpx;
          padding: 10rpx 20rpx;
          border-radius: 6rpx;
          
          &.edit-btn {
            background-color: #4CAF50;
            color: #fff;
          }
          
          &.delete-btn {
            background-color: #f44336;
            color: #fff;
          }
        }
      }
    }
  }
}

.dialog-content {
  background-color: #fff;
  border-radius: 16rpx;
  padding: 30rpx;
  width: 560rpx;
  
  .dialog-title {
    display: block;
    font-size: 32rpx;
    font-weight: bold;
    text-align: center;
    margin-bottom: 30rpx;
    color: #333;
  }
  
  .dialog-message {
    display: block;
    font-size: 28rpx;
    color: #666;
    text-align: center;
    margin-bottom: 30rpx;
  }
  
  .dialog-input {
    width: 100%;
    height: 80rpx;
    border: 1px solid #ddd;
    border-radius: 8rpx;
    padding: 0 20rpx;
    font-size: 28rpx;
    margin-bottom: 30rpx;
    box-sizing: border-box;
  }
  
  .dialog-buttons {
    display: flex;
    justify-content: space-between;
    gap: 20rpx;
    
    .dialog-button {
      flex: 1;
      height: 80rpx;
      line-height: 80rpx;
      font-size: 28rpx;
      border-radius: 8rpx;
      margin: 0;
      
      &.cancel {
        background-color: #f5f5f5;
        color: #666;
      }
      
      &.confirm {
        background-color: #2196F3;
        color: #fff;
      }
    }
  }
}

.floating-add-btn {
  position: fixed;
  bottom: 30rpx;
  right: 30rpx;
  width: 100rpx;
  height: 100rpx;
  border-radius: 50%;
  background-color: #42b983;
  color: #fff;
  display: flex;
  align-items: center;
  justify-content: center;
  box-shadow: 0 2rpx 8rpx rgba(0, 0, 0, 0.2);
}
</style>
