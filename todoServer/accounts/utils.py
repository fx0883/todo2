import requests
from django.conf import settings

def get_wechat_session(code):
    """
    调用微信登录凭证校验接口
    """
    url = 'https://api.weixin.qq.com/sns/jscode2session'
    params = {
        'appid': settings.SOCIAL_AUTH_WEIXIN_KEY,
        'secret': settings.SOCIAL_AUTH_WEIXIN_SECRET,
        'js_code': code,
        'grant_type': 'authorization_code'
    }
    
    response = requests.get(url, params=params)
    result = response.json()
    
    if 'errcode' in result and result['errcode'] != 0:
        raise ValueError(f"微信登录失败: {result['errmsg']}")
        
    return result 