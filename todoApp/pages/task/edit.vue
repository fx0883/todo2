<template>
  <view class="task-edit-container">
    <view v-if="task" class="task-form">
      <view class="form-item">
        <text class="label">标题</text>
        <input 
          class="input" 
          type="text" 
          v-model="editForm.title" 
          placeholder="请输入任务标题"
        />
      </view>
      
      <view class="form-item">
        <text class="label">描述</text>
        <textarea 
          class="textarea" 
          v-model="editForm.description" 
          placeholder="请输入任务描述"
        />
      </view>
      
      <view class="form-item">
        <text class="label">截止日期</text>
        <picker 
          mode="date" 
          :value="editForm.due_date" 
          @change="onDateChange"
        >
          <view class="picker">
            {{ editForm.due_date || '请选择截止日期' }}
          </view>
        </picker>
      </view>
      
      <view class="form-item">
        <text class="label">分类</text>
        <picker 
          :range="categoryOptions" 
          :range-key="'name'"
          :value="categoryIndex" 
          @change="onCategoryChange"
        >
          <view class="picker">
            {{ editForm.category ? getCategoryName(editForm.category) : '请选择分类' }}
          </view>
        </picker>
      </view>
      
      <view class="form-item">
        <text class="label">优先级</text>
        <picker 
          :range="priorityOptions" 
          :value="priorityIndex" 
          @change="onPriorityChange"
        >
          <view class="picker">
            {{ priorityOptions[priorityIndex] }}
          </view>
        </picker>
      </view>
      
      <view class="action-buttons">
        <button 
          class="btn save" 
          @click="handleSave"
          :disabled="loading"
        >
          保存
        </button>
        <button 
          class="btn cancel" 
          @click="handleCancel"
        >
          取消
        </button>
      </view>
    </view>
    
    <view v-else class="loading">
      加载中...
    </view>
  </view>
</template>

<script setup>
import { ref, onMounted, computed } from 'vue'
import { useTask } from '@/composables/useTask'
import { useCategory } from '@/composables/useCategory'
import { useRoute } from '@/composables/useRoute'
import { formatDate } from '@/utils/date'

const route = useRoute()
const { getTaskDetail, updateTask, loading } = useTask()
const { categories, initCategoryData } = useCategory()
const task = ref(null)
const editForm = ref({})

// 分类选项
const categoryOptions = computed(() => {
  return [{ id: null, name: '无分类' }, ...categories.value]
})
const categoryIndex = computed(() => {
  if (!editForm.value.category) return 0
  return categoryOptions.value.findIndex(cat => cat.id === editForm.value.category)
})
const getCategoryName = (categoryId) => {
  const category = categoryOptions.value.find(cat => cat.id === categoryId)
  return category ? category.name : '无分类'
}

// 优先级选项
const priorityOptions = ['低', '中', '高']
const priorityMap = { '低': 1, '中': 2, '高': 3 }
const priorityIndex = computed(() => {
  return editForm.value.priority ? editForm.value.priority - 1 : 0
})

// 获取任务详情
const fetchTaskDetail = async () => {
  try {
    task.value = await getTaskDetail(route.params.id)
    // 初始化表单数据
    editForm.value = {
      title: task.value.title,
      description: task.value.description,
      due_date: task.value.due_date ? task.value.due_date.split('T')[0] : '',
      priority: task.value.priority,
      category: task.value.category
    }
  } catch (error) {
    uni.showToast({
      title: '获取任务详情失败',
      icon: 'none'
    })
  }
}

// 日期选择处理
const onDateChange = (e) => {
  editForm.value.due_date = e.detail.value + 'T00:00:00+08:00'
}

// 分类选择处理
const onCategoryChange = (e) => {
  const index = e.detail.value
  editForm.value.category = categoryOptions.value[index].id
}

// 优先级选择处理
const onPriorityChange = (e) => {
  const index = e.detail.value
  editForm.value.priority = priorityMap[priorityOptions[index]]
}

// 保存任务
const handleSave = async () => {
  if (!editForm.value.title?.trim()) {
    uni.showToast({
      title: '请输入任务标题',
      icon: 'none'
    })
    return
  }

  const taskData = {
    title: editForm.value.title,
    description: editForm.value.description,
    due_date: editForm.value.due_date,
    priority: editForm.value.priority,
    category: editForm.value.category
  }

  try {
    await updateTask(route.params.id, taskData)
    
    uni.showToast({
      title: '更新成功',
      icon: 'success'
    })
    
    // 返回详情页
    uni.navigateBack()
  } catch (error) {
    uni.showToast({
      title: '更新失败',
      icon: 'none'
    })
  }
}

// 取消编辑
const handleCancel = () => {
  uni.navigateBack()
}

onMounted(async () => {
  await initCategoryData()
  await fetchTaskDetail()
})
</script>

<style lang="scss">
.task-edit-container {
  min-height: 100vh;
  background-color: #fff;
  padding: 30rpx;
  
  .task-form {
    .form-item {
      margin-bottom: 30rpx;
      
      .label {
        display: block;
        font-size: 28rpx;
        color: #666;
        margin-bottom: 10rpx;
      }
      
      .input, .textarea, .picker {
        width: 100%;
        padding: 20rpx;
        border: 1px solid #ddd;
        border-radius: 8rpx;
        font-size: 28rpx;
      }
      
      .textarea {
        height: 200rpx;
      }
    }
    
    .action-buttons {
      margin-top: 60rpx;
      display: flex;
      gap: 30rpx;
      
      .btn {
        flex: 1;
        padding: 20rpx;
        border-radius: 8rpx;
        font-size: 28rpx;
        text-align: center;
        
        &.save {
          background-color: #007AFF;
          color: #fff;
          
          &:disabled {
            opacity: 0.5;
          }
        }
        
        &.cancel {
          background-color: #f5f5f5;
          color: #666;
        }
      }
    }
  }
  
  .loading {
    text-align: center;
    padding: 30rpx;
    color: #999;
  }
}
</style>