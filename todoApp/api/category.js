import request from './request'

export default {
  // 获取分类列表
  getCategories: () => request({
    url: '/tasks/categories/',
    method: 'GET'
  }),

  // 创建分类
  createCategory: (data) => request({
    url: '/tasks/categories/',
    method: 'POST',
    data
  }),

  // 更新分类
  updateCategory: (id, data) => request({
    url: `/tasks/categories/${id}/`,
    method: 'PUT',
    data
  }),

  // 删除分类
  deleteCategory: (id) => request({
    url: `/tasks/categories/${id}/`,
    method: 'DELETE'
  }),

  // 批量更新分类
  batchUpdateCategories: (data) => request({
    url: '/tasks/categories/batch/',
    method: 'POST',
    data
  })
}
