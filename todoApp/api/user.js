import {
	uploadFile,
	request
} from './request'

// 用户登录
const login = (data) => {
	return request({
		url: '/accounts/users/login/',
		method: 'POST',
		data
	})
};

// 用户注册
const register = (data) => {
	return request({
		url: '/accounts/users/register/',
		method: 'POST',
		data
	})
};

// 重置密码请求
const requestPasswordReset = (data) => {
	return request({
		url: '/accounts/users/request_password_reset/',
		method: 'POST',
		data
	})
};

// 确认重置密码
const confirmPasswordReset = (data) => {
	return request({
		url: '/accounts/users/confirm_password_reset/',
		method: 'POST',
		data
	})
};

// 获取用户信息
const getUserInfo = () => {
	return request({
		url: '/accounts/users/me/',
		method: 'GET'
	})
};

// 刷新 token
const refreshToken = (refreshToken) => {
	return request({
		url: '/token/refresh/',
		method: 'POST',
		data: {
			refresh: refreshToken
		}
	})
};

// 修改头像上传方法
const uploadAvatar = (file) => {
	return uploadFile({
		url: '/accounts/users/upload_avatar/',
		filePath: file.path,
		name: 'avatar'
	})
};

// 获取任务统计
const getTaskStats = () => {
	return request({
		url: '/accounts/users/task_stats/',
		method: 'GET'
	})
};

// 更新用户信息
const updateUser = async (userData) => {
	return request({
		url: `/accounts/users/${userData.id}/`,
		method: 'PUT',
		data: userData
	})
};

// 微信登录
const wechatLogin = (js_code) => {
	return request({
		url: '/accounts/users/wechat_login/',
		method: 'POST',
		data: {
			js_code
		}
	})
}

export {
	wechatLogin
}

export default {
	login,
	register,
	requestPasswordReset,
	confirmPasswordReset,
	getUserInfo,
	refreshToken,
	uploadAvatar,
	getTaskStats,
	updateUser,
	wechatLogin
}