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
  }),

  // 获取分类列表
  getCategories: () => request({
    url: '/tasks/tasks/categories/',
    method: 'GET'
  }),

  // 创建分类
  createCategory: (data) => request({
    url: '/tasks/tasks/categories/',
    method: 'POST',
    data
  }),

  // 更新分类
  updateCategory: (categoryId, data) => request({
    url: `/tasks/tasks/categories/${categoryId}/`,
    method: 'PUT',
    data
  }),

  // 删除分类
  deleteCategory: (categoryId) => request({
    url: `/tasks/tasks/categories/${categoryId}/`,
    method: 'DELETE'
  }),

  // 获取标签列表
  getTags: () => request({
    url: '/tasks/tasks/tags/',
    method: 'GET'
  }),

  // 创建标签
  createTag: (data) => request({
    url: '/tasks/tasks/tags/',
    method: 'POST',
    data
  }),

  // 更新标签
  updateTag: (tagId, data) => request({
    url: `/tasks/tasks/tags/${tagId}/`,
    method: 'PUT',
    data
  }),

  // 删除标签
  deleteTag: (tagId) => request({
    url: `/tasks/tasks/tags/${tagId}/`,
    method: 'DELETE'
  })
}
