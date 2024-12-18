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
    <uni-popup ref="popup" type="dialog">
      <uni-popup-dialog
        :title="editingCategory ? '编辑分类' : '新建分类'"
        :before-close="true"
        @confirm="handleSave"
        @close="handleCancel"
      >
        <uni-forms :model="formData">
          <uni-forms-item label="名称" required>
            <uni-easyinput
              v-model="formData.name"
              placeholder="请输入分类名称"
            />
          </uni-forms-item>
          <uni-forms-item label="颜色">
            <uni-easyinput
              v-model="formData.color"
              placeholder="请选择颜色"
            />
          </uni-forms-item>
        </uni-forms>
      </uni-popup-dialog>
    </uni-popup>
  </view>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useCategory } from '@/composables/useCategory'

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
const popup = ref(null)
const editingCategory = ref(null)
const formData = ref({
  name: '',
  color: '#000000'
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
    color: '#000000'
  }
  popup.value?.open('center')
}

// 编辑分类
const handleEdit = (category) => {
  editingCategory.value = category
  formData.value = {
    name: category.name,
    color: category.color
  }
  popup.value?.open('center')
}

// 保存分类
const handleSave = async () => {
  try {
    if (editingCategory.value) {
      await updateCategory(editingCategory.value.id, formData.value)
    } else {
      await createCategory(formData.value)
    }
    popup.value?.close()
    await initData()
  } catch (e) {
    uni.showToast({
      title: e.message || '保存失败',
      icon: 'none'
    })
  }
}

// 删除分类
const handleDelete = async (categoryId) => {
  try {
    await uni.showModal({
      title: '确认删除',
      content: '确定要删除这个分类吗？'
    })
    
    await deleteCategory(categoryId)
    await initData()
  } catch (e) {
    uni.showToast({
      title: e.message || '删除失败',
      icon: 'none'
    })
  }
}

// 取消编辑
const handleCancel = () => {
  popup.value?.close()
}

onMounted(() => {
  initData()
})
</script>

<style lang="scss">
.category-container {
  min-height: 100vh;
  background-color: #f5f5f5;
  padding: 30rpx;
  
  .category-list {
    .category-item {
      display: flex;
      justify-content: space-between;
      align-items: center;
      background-color: #fff;
      padding: 30rpx;
      margin-bottom: 20rpx;
      border-radius: 12rpx;
      
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
          font-size: 32rpx;
          color: #333;
        }
        
        .task-count {
          font-size: 28rpx;
          color: #999;
        }
      }
      
      .category-actions {
        display: flex;
        gap: 20rpx;
        
        button {
          min-width: 120rpx;
          height: 60rpx;
          line-height: 60rpx;
          font-size: 28rpx;
          
          &.edit-btn {
            background-color: #1890ff;
            color: #fff;
          }
          
          &.delete-btn {
            background-color: #ff4d4f;
            color: #fff;
          }
        }
      }
    }
  }
  
  .add-category {
    position: fixed;
    bottom: 120rpx;
    left: 0;
    right: 0;
    padding: 0 30rpx;
    
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
}
</style>
