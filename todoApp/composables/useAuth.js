import {
	ref,
	computed
} from 'vue'
import {
	useCategoryStore,
	useTaskStore,
	useUserStore
} from '@/store'
import userApi from '@/api/user'

export function useAuth() {
	const userStore = useUserStore()
	const loading = ref(false)
	const error = ref(null)
	const categoryStore = useCategoryStore()
	const taskStore = useTaskStore()
	// 计算属性
	const isAuthenticated = computed(() => userStore.isAuthenticated)
	const user = computed(() => userStore.user)
	const token = computed(() => userStore.token)

	// 清除错误
	const clearError = () => {
		error.value = null
	}

	// 登录方法
	const login = async (credentials) => {
		loading.value = true
		error.value = null
		try {
			console.log('Login credentials:', credentials)
			const response = await userStore.login(credentials)
			console.log('Login response:', response)

			
			await refreshData()
			await refreshUserData()
			return true
		} catch (err) {
			console.error('Login error:', err)
			error.value = err.message || '登录失败'
			return false
		} finally {
			loading.value = false
		}
	}
	
	// 刷新用户相关数据
	const refreshData = async () => {		
		loading.value = true
		error.value = null
		try {
			await categoryStore.fetchCategories(true),
			await taskStore.fetchTasks()
		} catch (e) {
			error.value = e.message || '获取数据信息失败'
			throw e
		} finally {
			loading.value = false
		}
	}

	// 刷新用户相关数据
	const refreshUserData = async () => {
		loading.value = true
		error.value = null
		try {
			await userStore.fetchUserInfo()
		} catch (e) {
			error.value = e.message || '获取用户信息失败'
			throw e
		} finally {
			loading.value = false
		}
	}

	// 注册方法
	const register = async (userData) => {
		loading.value = true
		error.value = null
		try {
			const response = await userApi.register(userData)
			return true
		} catch (err) {
			error.value = err.data.error_message
			return false
		} finally {
			loading.value = false
		}
	}

	// 登出
	const logout = async () => {
		try {
			loading.value = true
			clearError()
			await userStore.logout()
			return true
		} catch (e) {
			error.value = e.message || '登出失败'
			return false
		} finally {
			loading.value = false
		}
	}

	// 请求重置密码
	const requestReset = async (email) => {
		loading.value = true
		error.value = null
		try {
			await userApi.requestPasswordReset({
				email
			})
			return true
		} catch (err) {
			error.value = err.message || '请求重置密码失败'
			return false
		} finally {
			loading.value = false
		}
	}

	// 确认重置密码
	const confirmReset = async (data) => {
		loading.value = true
		error.value = null
		try {
			await userApi.confirmPasswordReset(data)
			return true
		} catch (err) {
			error.value = err.message || '重置密码失败'
			return false
		} finally {
			loading.value = false
		}
	}

	// 检查 token 是否过期
	const checkTokenExpiration = () => {
		if (!token.value) return false
		try {
			const tokenData = JSON.parse(atob(token.value.split('.')[1]))
			const expirationTime = tokenData.exp * 1000 // 转换为毫秒
			return Date.now() >= expirationTime
		} catch {
			return true // 如果解析失败，认为 token 已过期
		}
	}
	
	const wechatLogin = async () => {
	  loading.value = true
	  error.value = null
	
	  try {
	    // 获取微信登录 code
	    const { code, errMsg } = await uni.login({
	      provider: 'weixin'
	    })
	
	    if (errMsg !== 'login:ok') {
	      throw new Error('微信登录失败')
		  return false
	    }
		const response = await userStore.wechatLogin(code)
		console.log('Login response:', response)

		
		await refreshData()
		await refreshUserData()
		return true

	
	    // 显示成功提示
	    uni.showToast({
	      title: '登录成功',
	      icon: 'success'
	    })
	
	    // 延迟跳转到首页
	    setTimeout(() => {
	      uni.switchTab({
	        url: '/pages/index/index'
	      })
	    }, 1500)
	
	    return true
	  } catch (err) {
	    console.error('微信登录失败:', err)
	    error.value = err.message || '登录失败'
	    
	    uni.showToast({
	      title: error.value,
	      icon: 'error'
	    })
	    
	    return false
	  } finally {
	    loading.value = false
	  }
	}

	return {
		// 状态
		loading,
		error,
		isAuthenticated,
		user,
		token,
		wechatLogin,
		// 方法
		login,
		register,
		logout,
		requestReset,
		confirmReset,
		clearError,
		checkTokenExpiration,
		refreshUserData
	}
}