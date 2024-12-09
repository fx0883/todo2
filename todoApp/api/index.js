import request from './request'

// 用户相关接口
export const userApi = {
  // 登录
  login: (data) => request({
    url: '/accounts/users/login/',
    method: 'POST',
    data
  }),
  
  // 注册
  register: (data) => request({
    url: '/accounts/users/register/',
    method: 'POST',
    data
  }),
  
  // 重置密码请求
  requestPasswordReset: (data) => request({
    url: '/accounts/users/request_password_reset/',
    method: 'POST',
    data
  }),
  
  // 确认重置密码
  confirmPasswordReset: (data) => request({
    url: '/accounts/users/confirm_password_reset/',
    method: 'POST',
    data
  })
}

// 任务相关接口
export const taskApi = {
  // 获取任务列表
  getTasks: (params) => request({
    url: '/tasks/tasks/',
    method: 'GET',
    data: params
  }),
  
  // 创建任务
  createTask: (data) => request({
    url: '/tasks/tasks/',
    method: 'POST',
    data
  }),
  
  // 更新任务
  updateTask: (id, data) => request({
    url: `/tasks/tasks/${id}/`,
    method: 'PUT',
    data
  }),
  
  // 删除任务
  deleteTask: (id) => request({
    url: `/tasks/tasks/${id}/`,
    method: 'DELETE'
  })
}

// 分类相关接口
export const categoryApi = {
  // 获取分类列表
  getCategories: () => request({
    url: '/tasks/categories/'
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
  })
}

// 标签相关接口
export const tagApi = {
  // 获取标签列表
  getTags: () => request({
    url: '/tasks/tags/'
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
  })
}
