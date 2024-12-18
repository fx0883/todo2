<template>
  <view class="category-container">
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
            @click="handleDelete(category.id)"
          >
            删除
          </button>
        </view>
      </view>
    </view>
    
    <!-- 添加按钮 -->
    <view class="add-category">
      <button 
        class="add-btn"
        @click="handleAdd"
      >
        添加分类
      </button>
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
            @click="handleSave"
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
  </view>
</template>

<script setup>
import { ref, onMounted, defineOptions } from 'vue'
import { useCategory } from '@/composables/useCategory'

// 导入 uni-ui 组件
import uniPopup from '@dcloudio/uni-ui/lib/uni-popup/uni-popup.vue'
import uniLoadMore from '@dcloudio/uni-ui/lib/uni-load-more/uni-load-more.vue'

// 定义组件
defineOptions({
  components: {
    uniPopup,
    uniLoadMore
  }
})

// 使用 composables
const {
  loading,
  error,
  categories,
  createCategory,
  updateCategory,
  deleteCategory,
  fetchCategories
} = useCategory()

// 状态
const editPopup = ref(null)
const deletePopup = ref(null)
const editingCategory = ref(null)
const deletingCategoryId = ref(null)
const formData = ref({
  name: '',
  color: '#2196F3' // 使用默认颜色
})

// 初始化数据
const initData = async () => {
  try {
    await fetchCategories()
  } catch (e) {
    uni.showToast({
      title: e.message || '获取分类失败',
      icon: 'none'
    })
  }
}

// 添加分类
const handleAdd = () => {
  editingCategory.value = null
  formData.value = {
    name: '',
    color: '#2196F3'
  }
  editPopup.value?.open()
}

// 编辑分类
const handleEdit = (category) => {
  editingCategory.value = category
  formData.value = {
    name: category.name,
    color: category.color
  }
  editPopup.value?.open()
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
    const categoryData = {
      name: formData.value.name.trim(),
      color: formData.value.color
    }

    if (editingCategory.value) {
      await updateCategory(editingCategory.value.id, categoryData)
    } else {
      await createCategory(categoryData)
    }

    editPopup.value?.close()
    await initData()
    
    uni.showToast({
      title: editingCategory.value ? '更新成功' : '创建成功',
      icon: 'success'
    })
  } catch (e) {
    uni.showToast({
      title: e.message || '保存失败',
      icon: 'none'
    })
  }
}

// 取消编辑
const handleCancel = () => {
  editPopup.value?.close()
}

// 删除分类
const handleDelete = (categoryId) => {
  deletingCategoryId.value = categoryId
  deletePopup.value?.open()
}

// 确认删除
const confirmDelete = async () => {
  try {
    await deleteCategory(deletingCategoryId.value)
    deletePopup.value?.close()
    await initData()
    
    uni.showToast({
      title: '删除成功',
      icon: 'success'
    })
  } catch (e) {
    uni.showToast({
      title: e.message || '删除失败',
      icon: 'none'
    })
  }
}

// 取消删除
const cancelDelete = () => {
  deletePopup.value?.close()
  deletingCategoryId.value = null
}

onMounted(() => {
  initData()
})
</script>

<style lang="scss">
.category-container {
  padding: 20rpx;
  
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
  
  .add-category {
    position: fixed;
    bottom: 40rpx;
    left: 0;
    right: 0;
    display: flex;
    justify-content: center;
    
    .add-btn {
      background-color: #2196F3;
      color: #fff;
      padding: 20rpx 60rpx;
      border-radius: 30rpx;
      font-size: 28rpx;
    }
  }
}

.dialog-content {
  background-color: #fff;
  border-radius: 16rpx;
  padding: 30rpx;
  width: 560rpx;
  box-sizing: border-box;
  
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
      padding: 0;
      
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
</style>
