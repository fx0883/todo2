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
  })
}
