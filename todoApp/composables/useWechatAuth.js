import { ref } from 'vue'
import { useAuthStore } from '../store/modules/auth'

export function useWechatAuth() {
  const loading = ref(false)
  const error = ref('')
  const authStore = useAuthStore()

  const wechatLogin = async () => {
    loading.value = true
    error.value = ''

    try {
      // 调用微信登录
   //    const loginRes = await new Promise((resolve, reject) => {
   //      uni.login({
   //        provider: 'weixin',
   //        success: (res) => {
			//   console.log(res)
			//   resolve(res)
			// },
   //        fail: (err) => reject(err)
   //      })
   //    })
   
   // 1. 获得微信 code
   const codeResult = await uni.login({provider: 'weixin'});
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

      // 调用 store 的微信登录方法
      const success = await authStore.wechatLogin(loginRes.code)
      
      if (!success) {
        throw new Error('登录失败')
      }

      return true
    } catch (err) {
      console.error('微信登录失败:', err)
      error.value = err.message || '登录失败，请重试'
      return false
    } finally {
      loading.value = false
    }
  }

  return {
    loading,
    error,
    wechatLogin
  }
}
