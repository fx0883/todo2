import { uploadFile, request } from './request'

export default {
  // 用户登录
  login: (data) => {
    return request({
      url: '/accounts/users/login/',
      method: 'POST',
      data
    })
  },

  // 用户注册
  register: (data) => {
    return request({
      url: '/accounts/users/register/',
      method: 'POST',
      data
    })
  },

  // 重置密码请求
  requestPasswordReset: (data) => {
    return request({
      url: '/accounts/users/request_password_reset/',
      method: 'POST',
      data
    })
  },

  // 确认重置密码
  confirmPasswordReset: (data) => {
    return request({
      url: '/accounts/users/confirm_password_reset/',
      method: 'POST',
      data
    })
  },

  // 获取用户信息
  getUserInfo: () => {
    return request({
      url: '/accounts/users/me/',
      method: 'GET'
    })
  },

  // 刷新 token
  refreshToken: (refreshToken) => {
    return request({
      url: '/token/refresh/',
      method: 'POST',
      data: { refresh: refreshToken }
    })
  },

  // 修改头像上传方法
  uploadAvatar: (file) => {
    return uploadFile({
      url: '/accounts/users/upload_avatar/',
      filePath: file.path,
      name: 'avatar'
    })
  }
}
