import { request } from './request'

export const taskApi = {
  // 获取任务列表
  getTasks: (params) => request({
    url: '/tasks/',
    method: 'GET',
    params
  }),

  // 获取任务详情
  getTaskDetail: (taskId) => request({
    url: `/tasks/${taskId}/`,
    method: 'GET'
  }),

  // 创建任务
  createTask: (data) => request({
    url: '/tasks/',
    method: 'POST',
    data
  }),

  // 更新任务
  updateTask: (taskId, data) => request({
    url: `/tasks/${taskId}/`,
    method: 'PUT',
    data
  }),

  // 删除任务
  deleteTask: (taskId) => request({
    url: `/tasks/${taskId}/`,
    method: 'DELETE'
  }),

  // 获取分类列表
  getCategories: () => request({
    url: '/categories/',
    method: 'GET'
  }),

  // 创建分类
  createCategory: (data) => request({
    url: '/categories/',
    method: 'POST',
    data
  }),

  // 更新分类
  updateCategory: (categoryId, data) => request({
    url: `/categories/${categoryId}/`,
    method: 'PUT',
    data
  }),

  // 删除分类
  deleteCategory: (categoryId) => request({
    url: `/categories/${categoryId}/`,
    method: 'DELETE'
  }),

  // 获取标签列表
  getTags: () => request({
    url: '/tags/',
    method: 'GET'
  }),

  // 创建标签
  createTag: (data) => request({
    url: '/tags/',
    method: 'POST',
    data
  }),

  // 更新标签
  updateTag: (tagId, data) => request({
    url: `/tags/${tagId}/`,
    method: 'PUT',
    data
  }),

  // 删除标签
  deleteTag: (tagId) => request({
    url: `/tags/${tagId}/`,
    method: 'DELETE'
  })
}
