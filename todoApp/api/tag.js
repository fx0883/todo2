import { request } from './request'

export default {
  // 获取标签列表
  getTags: () => request({
    url: '/tasks/tags/',
    method: 'GET'
  }),

  // 创建标签
  createTag: (data) => request({
    url: '/tasks/tags/',
    method: 'POST',
    data
  }),

  // 更新标签
  updateTag: (id, data) => request({
    url: `/tasks/tags/${id}/`,
    method: 'PUT',
    data
  }),

  // 删除标签
  deleteTag: (id) => request({
    url: `/tasks/tags/${id}/`,
    method: 'DELETE'
  }),

  // 获取标签详情
  getTagDetail: (id) => request({
    url: `/tasks/tags/${id}/`,
    method: 'GET'
  }),

  // 批量操作标签
  batchUpdateTags: (data) => request({
    url: '/tasks/tags/batch/',
    method: 'POST',
    data
  }),

  // 根据任务ID获取相关标签
  getTagsByTask: (taskId) => request({
    url: `/tasks/${taskId}/tags/`,
    method: 'GET'
  })
}
