import { ref } from 'vue'
import { useUserStore } from '@/stores/user'
import { wechatLogin } from '@/api/user'

export function useWechatLogin() {
  const loading = ref(false)
  const error = ref('')
  const userStore = useUserStore()

  const handleWechatLogin = async () => {
    loading.value = true
    error.value = ''
    
    // try {
    //   // #ifdef MP-WEIXIN
    //   const { code } = await uni.login({ provider: 'weixin' })
    //   const res = await wechatLogin(code)
      
    //   if (res.data) {
    //     await userStore.setUserInfo(res.data.user)
    //     await userStore.setToken(res.data.token)
    //     uni.switchTab({ url: '/pages/index/index' })
    //   }
    //   // #endif
    // } catch (e) {
    //   error.value = e.message || '微信登录失败'
    // } finally {
    //   loading.value = false
    // }
	
	// 1. 获得微信 code
	const codeResult = await uni.login();
	if (codeResult.errMsg !== 'login:ok') {
		return resolve(false);
	}
	
	console.log(`codeResult.code = ${codeResult.code}`)
	// 2. 一键登录
	// const loginResult = await AuthUtil.weixinMiniAppLogin(e.code, codeResult.code, 'default');
	// if (loginResult.code === 0) {
	// 	setOpenid(loginResult.data.openid);
	// 	return resolve(true);
	// } else {
	// 	return resolve(false);
	// }
  }

  return {
    loading,
    error,
    handleWechatLogin
  }
}
