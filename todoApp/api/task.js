import request from './request'

export default {
  // 获取任务列表
  getTasks: (params) => request({
    url: '/tasks/tasks/',
    method: 'GET',
    params
  }),

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
