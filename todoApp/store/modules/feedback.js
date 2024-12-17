import { defineStore } from 'pinia'
import feedbackApi from '@/api/feedback'

export const useFeedbackStore = defineStore('feedback', {
  state: () => ({
    feedbackList: [],
    currentFeedback: null,
    loading: false,
    error: null
  }),

  actions: {
    // 获取反馈列表
    async fetchFeedbackList() {
      this.loading = true
      try {
        const response = await feedbackApi.getFeedbackList()
        // 确保 response 是数组
        this.feedbackList = Array.isArray(response) ? response : (response.results || [])
        this.error = null
      } catch (error) {
        this.error = error.message || '获取反馈列表失败'
        throw error
      } finally {
        this.loading = false
      }
    },

    // 创建反馈
    async createFeedback(feedbackData) {
      this.loading = true
      try {
        const response = await feedbackApi.createFeedback(feedbackData)
        // 确保 feedbackList 是数组
        if (!Array.isArray(this.feedbackList)) {
          this.feedbackList = []
        }
        this.feedbackList = [response, ...this.feedbackList]
        this.error = null
        return response
      } catch (error) {
        this.error = error.message || '创建反馈失败'
        throw error
      } finally {
        this.loading = false
      }
    },

    // 获取反馈详情
    async fetchFeedbackDetail(id) {
      this.loading = true
      try {
        const response = await feedbackApi.getFeedbackDetail(id)
        this.currentFeedback = response
        this.error = null
        return response
      } catch (error) {
        this.error = error.message || '获取反馈详情失败'
        throw error
      } finally {
        this.loading = false
      }
    },

    // 更新反馈状态
    async updateFeedbackStatus(id, status) {
      try {
        const response = await feedbackApi.updateFeedbackStatus(id, status)
        // 更新列表中的状态
        const index = this.feedbackList.findIndex(f => f.id === id)
        if (index !== -1) {
          this.feedbackList[index] = response
        }
        if (this.currentFeedback?.id === id) {
          this.currentFeedback = response
        }
        return response
      } catch (error) {
        this.error = error.message || '更新反馈状态失败'
        throw error
      }
    },

    // 添加回复
    async addFeedbackResponse(id, response) {
      try {
        const result = await feedbackApi.addFeedbackResponse(id, response)
        // 更新列表中的回复
        const index = this.feedbackList.findIndex(f => f.id === id)
        if (index !== -1) {
          this.feedbackList[index] = result
        }
        if (this.currentFeedback?.id === id) {
          this.currentFeedback = result
        }
        return result
      } catch (error) {
        this.error = error.message || '添加回复失败'
        throw error
      }
    }
  }
})
