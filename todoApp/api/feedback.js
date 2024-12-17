import { request } from './request'

export default {
  // 获取反馈列表
  getFeedbackList: () => request({
    url: '/accounts/feedback/',
    method: 'GET'
  }),

  // 获取反馈详情
  getFeedbackDetail: (id) => request({
    url: `/accounts/feedback/${id}/`,
    method: 'GET'
  }),

  // 创建反馈
  createFeedback: (data) => request({
    url: '/accounts/feedback/',
    method: 'POST',
    data: {
      type: data.type,
      title: data.title,
      content: data.content,
      contact_info: data.contact_info || ''
    }
  }),

  // 更新反馈状态
  updateFeedbackStatus: (id, status) => request({
    url: `/accounts/feedback/${id}/update_status/`,
    method: 'PATCH',
    data: { status }
  }),

  // 添加回复
  addFeedbackResponse: (id, response) => request({
    url: `/accounts/feedback/${id}/add_response/`,
    method: 'POST',
    data: { response }
  })
}
