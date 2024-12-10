<script>
import { useUserStore } from '@/store/modules/user'

export default {
	onLaunch: async function() {
		console.log('App Launch')
		const userStore = useUserStore()
		
		// 从本地存储初始化用户数据
		userStore.initFromStorage()
		
		// 如果有token，验证token有效性
		if (userStore.token) {
			try {
				// 尝试获取用户信息，如果token无效会失败
				const res = await uni.request({
					url: '/api/v1/accounts/users/me/',
					header: {
						'Authorization': `Bearer ${userStore.token}`
					}
				})
				
				if (res.statusCode === 200) {
					userStore.setUserInfo(res.data)
				} else {
					// token无效，清除登录状态
					userStore.logout()
					uni.redirectTo({
						url: '/pages/login/index'
					})
				}
			} catch (error) {
				console.error('验证token失败:', error)
				userStore.logout()
				uni.redirectTo({
					url: '/pages/login/index'
				})
			}
		} else {
			// 没有token，跳转到登录页
			uni.redirectTo({
				url: '/pages/login/index'
			})
		}
	},
	onShow: function() {
		console.log('App Show')
	},
	onHide: function() {
		console.log('App Hide')
	}
}
</script>

<style>
	/*每个页面公共css */
</style>
