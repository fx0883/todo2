import { request } from './request'

export default {
  // 获取任务列表
  fetchTasks: async (params = {}) => {
    try {
		
	  const paramsTemp = {
	    page: params.page || 1,
	    page_size: params.pageSize || 10,
	    ...params
	  }
		
      const response = await request({
        url: `/tasks/tasks/?page=${paramsTemp.page}&pageSize=${paramsTemp.pageSize}`,
        method: 'GET',
        params: {
          page: params.page || 1,
          page_size: params.pageSize || 10,
          ...params
        }
      })
      return response
    } catch (error) {
      throw error
    }
  },

  // 获取任务详情
  getTaskDetail: (taskId) => request({
    url: `/tasks/tasks/${taskId}/`,
    method: 'GET'
  }),

  // 创建任务
  createTask: (data) => request({
    url: '/tasks/tasks/',
    method: 'POST',
    data
  }),

  // 更新任务
  updateTask: (taskId, data) => request({
    url: `/tasks/tasks/${taskId}/`,
    method: 'PUT',
    data
  }),

  // 删除任务
  deleteTask: (taskId) => request({
    url: `/tasks/tasks/${taskId}/`,
    method: 'DELETE'
  }),

  // 添加评论
  addComment: (taskId, data) => request({
    url: `/tasks/tasks/${taskId}/comments/`,
    method: 'POST',
    data: {
      task: taskId,
      ...data
    }
  }),

  // 添加评论相关的 API 方法
  getTaskComments: (taskId, params = {}) => request({
    url: `/tasks/tasks/${taskId}/comments/`,
    method: 'GET',
    params: {
      page: params.page || 1,
      page_size: params.pageSize || 10,
      ...params
    }
  }),

  // 获取日历视图任务
  getCalendarTasks: (params) => {
    const queryString = Object.entries(params)
      .map(([key, value]) => `${encodeURIComponent(key)}=${encodeURIComponent(value)}`)
      .join('&')
    return request({
      url: `/tasks/tasks/calendar/?${queryString}`,
      method: 'GET'
    })
  },

  // 更新任务日期
  updateTaskDate: (taskId, date) => request({
    url: `/tasks/tasks/${taskId}/update_date/`,
    method: 'PATCH',
    data: { due_date: date }
  }),

  // 快速创建任务
  quickCreateTask: (data) => request({
    url: '/tasks/tasks/quick_create/',
    method: 'POST',
    data
  }),

  // 获取月度统计数据
  getMonthStats: (month) => {
    return request({
      url: `/tasks/tasks/month_stats/${month}/`,
      method: 'GET'
    })
  },

  // 获取分类统计数据
  getCategoryStats: (month) => {
    return request({
      url: `/tasks/tasks/category_stats/${month}/`,
      method: 'GET'
    })
  },

  // 获取每日完成趋势
  getDailyTrend: (month) => {
    return request({
      url: `/tasks/tasks/daily_trend/${month}/`,
      method: 'GET'
    })
  },
}
