import { request } from './request'

export default {
  // 请求密码重置
  requestPasswordReset: (email) => request({
    url: '/accounts/users/request_password_reset/',
    method: 'POST',
    data: { email }
  }),

  // 确认密码重置
  confirmPasswordReset: (data) => request({
    url: '/accounts/users/confirm_password_reset/',
    method: 'POST',
    data: {
      token: data.token,
      new_password: data.new_password,
      confirm_password: data.confirm_password
    }
  })
}
