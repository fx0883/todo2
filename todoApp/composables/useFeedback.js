import { ref } from 'vue'
import { useFeedbackStore } from '@/store/modules/feedback'

export function useFeedback() {
  const feedbackStore = useFeedbackStore()
  const feedbackForm = ref({
    type: '',
    title: '',
    content: '',
    contact_info: ''
  })
  
  // 提交反馈
  const submitFeedback = async () => {
    try {
      const response = await feedbackStore.createFeedback({
        type: feedbackForm.value.type,
        title: feedbackForm.value.title,
        content: feedbackForm.value.content,
        contact_info: feedbackForm.value.contact_info
      })
      
      uni.showToast({
        title: '反馈提交成功',
        icon: 'success',
        duration: 1500,
        success: () => {
          // 延迟关闭页面，等待 Toast 显示完成
          setTimeout(() => {
            uni.navigateBack()
          }, 1500)
        }
      })
      
      // 重置表单
      feedbackForm.value = {
        type: '',
        title: '',
        content: '',
        contact_info: ''
      }
      return response
    } catch (error) {
      console.error('提交反馈失败:', error)
      uni.showToast({
        title: error.message || '提交失败',
        icon: 'error'
      })
      throw error
    }
  }

  // 获取反馈列表
  const getFeedbackList = async () => {
    try {
      await feedbackStore.fetchFeedbackList()
      return feedbackStore.feedbackList
    } catch (error) {
      console.error('获取反馈列表失败:', error)
      uni.showToast({
        title: error.message || '获取列表失败',
        icon: 'error'
      })
      throw error
    }
  }

  return {
    feedbackForm,
    submitFeedback,
    getFeedbackList,
    feedbackList: feedbackStore.feedbackList,
    loading: feedbackStore.loading,
    error: feedbackStore.error
  }
}
