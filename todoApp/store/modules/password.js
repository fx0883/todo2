import { defineStore } from 'pinia'
import passwordApi from '@/api/password'

export const usePasswordStore = defineStore('password', {
  state: () => ({
    loading: false,
    error: null
  }),

  actions: {
    async requestPasswordReset(email) {
      this.loading = true
      this.error = null
      try {
        const response = await passwordApi.requestPasswordReset(email)
        return response
      } catch (error) {
        this.error = error.message
        throw error
      } finally {
        this.loading = false
      }
    },

    async confirmPasswordReset(data) {
      this.loading = true
      this.error = null
      try {
        const response = await passwordApi.confirmPasswordReset(data)
        return response
      } catch (error) {
        this.error = error.message
        throw error
      } finally {
        this.loading = false
      }
    }
  }
})
