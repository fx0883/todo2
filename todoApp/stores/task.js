import { defineStore } from 'pinia'
import axios from 'axios'
import { formatDate } from '@/utils/dateTime'

export const useTaskStore = defineStore('task', {
  state: () => ({
    tasks: [],
    loading: false,
    error: null
  }),

  actions: {
    async fetchCalendarTasks({ startDate, endDate, viewType, status = 'all' }) {
      this.loading = true
      try {
        const response = await axios.get('/api/tasks/calendar/', {
          params: {
            start_date: startDate,
            end_date: endDate,
            view_type: viewType,
            status
          }
        })
        this.tasks = response.data
        return response.data
      } catch (error) {
        this.error = error.message
        throw error
      } finally {
        this.loading = false
      }
    },

    async toggleTaskStatus(taskId, completed) {
      try {
        const response = await axios.patch(`/api/tasks/${taskId}/toggle_status/`, {
          completed
        })
        // 更新本地任务状态
        const taskIndex = this.tasks.findIndex(t => t.id === taskId)
        if (taskIndex !== -1) {
          this.tasks[taskIndex] = response.data
        }
        return response.data
      } catch (error) {
        this.error = error.message
        throw error
      }
    },

    async fetchTaskStatistics() {
      try {
        const response = await axios.get('/api/tasks/statistics/')
        return response.data
      } catch (error) {
        this.error = error.message
        throw error
      }
    },

    async updateTaskDate(taskId, newDate) {
      try {
        const response = await axios.patch(`/api/tasks/${taskId}/update_date/`, {
          due_date: formatDate(newDate, 'YYYY-MM-DD')
        })
        // 更新本地任务状态
        const taskIndex = this.tasks.findIndex(t => t.id === taskId)
        if (taskIndex !== -1) {
          this.tasks[taskIndex] = response.data
        }
        return response.data
      } catch (error) {
        this.error = error.message
        throw error
      }
    },

    async quickAddTask(taskData) {
      try {
        const response = await axios.post('/api/tasks/quick_create/', taskData)
        this.tasks.push(response.data)
        return response.data
      } catch (error) {
        this.error = error.message
        throw error
      }
    }
  }
})
