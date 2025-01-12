# JWT 认证使用说明

## 概述
本项目使用 JWT (JSON Web Token) 进行用户认证。JWT 提供了一种无状态的认证机制，相比传统的 Token 认证有以下优势：
- 无需数据库查询，性能更好
- Token 中包含用户信息
- 支持 token 自动刷新
- 更适合分布式系统

## Token 类型
系统提供两种类型的 token：
1. **Access Token**: 用于访问 API，有效期为 1 小时
2. **Refresh Token**: 用于刷新 Access Token，有效期为 7 天

## API 端点

### 1. 获取 Token
```bash
# 请求
curl -X POST http://localhost:8000/api/token/ \
  -H "Content-Type: application/json" \
  -d '{"username": "your_username", "password": "your_password"}'

# 响应
{
    "refresh": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9...",
    "access": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9..."
}
```

### 2. 使用 Token 访问 API
```bash
curl -X GET http://localhost:8000/api/v1/your_endpoint \
  -H "Authorization: Bearer your_access_token"
```

### 3. 刷新 Token
当 access token 过期时，使用 refresh token 获取新的 access token：
```bash
# 请求
curl -X POST http://localhost:8000/api/token/refresh/ \
  -H "Content-Type: application/json" \
  -d '{"refresh": "your_refresh_token"}'

# 响应
{
    "access": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9..."
}
```

### 4. 验证 Token
```bash
# 请求
curl -X POST http://localhost:8000/api/token/verify/ \
  -H "Content-Type: application/json" \
  -d '{"token": "your_token"}'

# 响应
{} # 如果 token 有效
# 如果 token 无效会返回错误信息
```

## 前端使用示例

### 1. 登录并保存 Token
```javascript
async function login(username, password) {
    const response = await fetch('http://localhost:8000/api/token/', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify({
            username,
            password,
        }),
    });
    
    const data = await response.json();
    
    // 保存 token 到 localStorage
    localStorage.setItem('access_token', data.access);
    localStorage.setItem('refresh_token', data.refresh);
}
```

### 2. 发送带认证的请求
```javascript
async function authenticatedRequest(url, options = {}) {
    const token = localStorage.getItem('access_token');
    
    const response = await fetch(url, {
        ...options,
        headers: {
            ...options.headers,
            'Authorization': `Bearer ${token}`,
        },
    });
    
    if (response.status === 401) {
        // Token 过期，尝试刷新
        const newToken = await refreshToken();
        if (newToken) {
            // 使用新 token 重试请求
            return authenticatedRequest(url, options);
        }
    }
    
    return response;
}
```

### 3. 刷新 Token
```javascript
async function refreshToken() {
    const refresh_token = localStorage.getItem('refresh_token');
    
    try {
        const response = await fetch('http://localhost:8000/api/token/refresh/', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({
                refresh: refresh_token,
            }),
        });
        
        if (response.ok) {
            const data = await response.json();
            localStorage.setItem('access_token', data.access);
            return data.access;
        }
    } catch (error) {
        // 刷新失败，需要重新登录
        localStorage.removeItem('access_token');
        localStorage.removeItem('refresh_token');
        window.location.href = '/login';
    }
    
    return null;
}
```

## 注意事项
1. 始终使用 HTTPS 传输 token
2. 不要在 URL 参数中传递 token
3. 注意 token 的有效期，及时刷新
4. 如果 refresh token 也过期，需要用户重新登录
5. 在登出时清除所有存储的 token
