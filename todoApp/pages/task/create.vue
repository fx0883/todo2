<template>
  <view class="create-task-container">
    <view class="form-container">
      <view class="form-item">
        <text class="label">标题</text>
        <input 
          class="input" 
          type="text" 
          v-model="taskForm.title" 
          placeholder="请输入任务标题"
        />
      </view>
      
      <view class="form-item">
        <text class="label">描述</text>
        <textarea 
          class="textarea" 
          v-model="taskForm.description" 
          placeholder="请输入任务描述"
        />
      </view>
      
      <view class="form-item">
        <text class="label">分类</text>
        <view v-if="categories.length === 0" class="empty-category">
          <text>还没有分类，</text>
          <text class="link" @click="navigateToCategory">去创建一个</text>
        </view>
        <picker v-else 
          :range="categories" 
          range-key="name"
          :disabled="categories.length === 0"
          @change="handleCategoryChange"
        >
          <view class="picker">
            <text v-if="categories.length === 0">暂无分类</text>
            <text v-else>{{ selectedCategory ? selectedCategory.name : '请选择分类' }}</text>
          </view>
        </picker>
      </view>
      
      <view class="form-item">
        <text class="label">优先级</text>
        <picker 
          :range="priorities" 
          range-key="label"
          @change="handlePriorityChange"
        >
          <view class="picker">
            {{ priorityLabels[taskForm.priority] || '请选择优先级' }}
          </view>
        </picker>
      </view>
      
      <view class="form-item">
        <text class="label">截止日期</text>
        <picker 
          mode="date" 
          :value="taskForm.due_date" 
          @change="handleDateChange"
        >
          <view class="picker">
            {{ taskForm.due_date || '请选择截止日期' }}
          </view>
        </picker>
      </view>
      
      <button 
        class="submit-btn" 
        :disabled="!isValid || loading"
        :loading="loading"
        @click="handleSubmit"
      >
        创建任务
      </button>
    </view>
  </view>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useTaskStore } from '@/store/modules/task'
import taskApi from '@/api/task'
import categoryApi from '@/api/category'

console.log('导入的 categoryApi:', categoryApi)

const taskStore = useTaskStore()
const loading = ref(false)

// 表单数据
const taskForm = ref({
  title: '',
  description: '',
  category: null,
  priority: '',
  due_date: '',
  status: 'pending'
})

// 分类和优先级选项
const categories = ref([])
const priorities = [
  { label: '低', value: 1 },
  { label: '中', value: 2 },
  { label: '高', value: 3 }
]
const priorityLabels = {
  1: '低优先级',
  2: '中优先级',
  3: '高优先级'
}
const selectedCategory = ref(null)

// 获取分类列表
const fetchCategories = async () => {
  try {
    console.log('开始获取分类列表')
    const response = await categoryApi.getCategories()
    console.log('获取到的分类列表:', response)
    categories.value = response.results || []
    console.log('设置后的分类列表:', categories.value)
  } catch (error) {
    console.error('获取分类失败:', error)
    categories.value = []
    uni.showToast({
      title: '获取分类失败',
      icon: 'none'
    })
  }
}

// 页面跳转
const navigateToCategory = () => {
  uni.navigateTo({
    url: '/pages/category/index'
  })
}

// 表单验证
const isValid = computed(() => {
  return taskForm.value.title && 
         taskForm.value.category && 
         taskForm.value.priority && 
         taskForm.value.due_date
})

// 选择器事件处理
const handleCategoryChange = (e) => {
  const index = e.detail.value
  selectedCategory.value = categories.value[index]
  taskForm.value.category = categories.value[index].id
}

const handlePriorityChange = (e) => {
  const index = e.detail.value
  taskForm.value.priority = priorities[index].value
}

const handleDateChange = (e) => {
  taskForm.value.due_date = e.detail.value
}

// 提交表单
const handleSubmit = async () => {
  if (!isValid.value || loading.value) return
  
  try {
    await createTask(taskForm.value)
    uni.showToast({
      title: '创建成功',
      icon: 'success'
    })
    
    setTimeout(() => {
      uni.navigateBack()
    }, 1500)
  } catch (error) {
    uni.showToast({
      title: error.message || '创建失败',
      icon: 'none'
    })
  }
}

const createTask = async (task) => {
  const res = await taskApi.createTask(task)
  taskStore.createTask(res)
}

onMounted(() => {
  fetchCategories()
})
</script>

<style lang="scss">
.create-task-container {
  min-height: 100vh;
  background-color: #fff;
  
  .form-container {
    padding: 30rpx;
    
    .form-item {
      margin-bottom: 30rpx;
      
      .label {
        display: block;
        margin-bottom: 10rpx;
        font-size: 28rpx;
        color: #333;
      }
      
      .input, .textarea, .picker {
        width: 100%;
        padding: 20rpx;
        background-color: #f5f5f5;
        border-radius: 12rpx;
        font-size: 28rpx;
      }
      
      .textarea {
        height: 200rpx;
      }
      
      .picker {
        color: #666;
      }
      
      .empty-category {
        padding: 20rpx;
        background-color: #f5f5f5;
        border-radius: 12rpx;
        
        .link {
          color: #007AFF;
          text-decoration: underline;
        }
      }
    }
    
    .submit-btn {
      margin-top: 60rpx;
      height: 90rpx;
      line-height: 90rpx;
      background-color: #007AFF;
      color: #fff;
      border-radius: 45rpx;
      font-size: 32rpx;
      
      &:disabled {
        opacity: 0.6;
      }
    }
  }
}
</style>
