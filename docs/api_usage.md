# Todo 应用 API 使用文档

## 基础信息
- 基础URL: `http://localhost:8000/api/v1`
- 所有需要认证的 API 都需要在请求头中添加 Token：
  ```
  Authorization: Bearer your_jwt_token
  ```

## API 端点

### 1. 用户认证
#### 1.1 获取 JWT Token
```bash
POST /api/v1/accounts/users/login/
Content-Type: application/json

{
    "username": "your_username",
    "password": "your_password"
}

# 响应
{
    "refresh": "refresh_token",
    "access": "access_token"
}
```

#### 1.2 刷新 Token
```bash
POST /api/token/refresh/
Content-Type: application/json

{
    "refresh": "your_refresh_token"
}

# 响应
{
    "access": "new_access_token"
}
```

#### 1.3 用户注册
```bash
POST /api/v1/accounts/users/register/
Content-Type: application/json

{
    "username": "newuser",
    "email": "user@example.com",
    "password": "password123",
    "confirm_password": "password123"
}
```

#### 1.4 密码重置
```bash
# 请求重置
POST /api/v1/accounts/users/request_password_reset/
Content-Type: application/json

{
    "email": "your_email@example.com"
}

# 确认重置
POST /api/v1/accounts/users/confirm_password_reset/
Content-Type: application/json

{
    "token": "verification_code",
    "new_password": "new_password",
    "confirm_password": "new_password"
}
```

### 2. 任务分类管理
#### 2.1 获取分类列表
```bash
GET /api/v1/tasks/categories/
Authorization: Bearer your_token
```

#### 2.2 创建分类
```bash
POST /api/v1/tasks/categories/
Authorization: Bearer your_token
Content-Type: application/json

{
    "name": "工作",
    "color": "#FF5733",
    "icon": "work",
    "order": 1
}
```

#### 2.3 更新分类
```bash
PUT /api/v1/tasks/categories/{id}/
Authorization: Bearer your_token
Content-Type: application/json

{
    "name": "工作",
    "color": "#FF5733",
    "icon": "work",
    "order": 1
}
```

#### 2.4 删除分类
```bash
DELETE /api/v1/tasks/categories/{id}/
Authorization: Bearer your_token
```

### 3. 任务标签管理
#### 3.1 获取标签列表
```bash
GET /api/v1/tasks/tags/
Authorization: Bearer your_token
```

#### 3.2 创建标签
```bash
POST /api/v1/tasks/tags/
Authorization: Bearer your_token
Content-Type: application/json

{
    "name": "重要",
    "color": "#FF0000"
}
```

#### 3.3 更新标签
```bash
PUT /api/v1/tasks/tags/{id}/
Authorization: Bearer your_token
Content-Type: application/json

{
    "name": "重要",
    "color": "#FF0000"
}
```

#### 3.4 删除标签
```bash
DELETE /api/v1/tasks/tags/{id}/
Authorization: Bearer your_token
```

### 4. 任务管理
#### 4.1 获取任务列表
```bash
GET /api/v1/tasks/tasks/
Authorization: Bearer your_token

# 支持的过滤参数
?status=pending
?priority=high
?category=1
?search=关键词
?ordering=-created_at
```

#### 4.2 创建任务
```bash
POST /api/v1/tasks/tasks/
Authorization: Bearer your_token
Content-Type: application/json

{
    "title": "完成项目文档",
    "description": "编写项目技术文档",
    "category": 1,
    "tags": [1, 2],
    "priority": "high",
    "status": "pending",
    "due_date": "2024-12-31T23:59:59Z"
}
```

#### 4.3 更新任务
```bash
PUT /api/v1/tasks/tasks/{id}/
Authorization: Bearer your_token
Content-Type: application/json

{
    "title": "完成项目文档",
    "status": "completed"
}
```

#### 4.4 删除任务
```bash
DELETE /api/v1/tasks/tasks/{id}/
Authorization: Bearer your_token
```

### 5. 任务评论
#### 5.1 获取任务评论
```bash
GET /api/v1/tasks/comments/?task={task_id}
Authorization: Bearer your_token
```

#### 5.2 添加评论
```bash
POST /api/v1/tasks/comments/
Authorization: Bearer your_token
Content-Type: application/json

{
    "task": 1,
    "content": "这个任务需要尽快完成"
}
```

### 6. 用户反馈
#### 6.1 提交反馈
```bash
POST /api/v1/accounts/feedbacks/
Authorization: Bearer your_token
Content-Type: application/json

{
    "type": "bug",
    "title": "页面加载问题",
    "content": "任务列表页面加载速度较慢"
}
```

#### 6.2 获取反馈列表
```bash
GET /api/v1/accounts/feedbacks/
Authorization: Bearer your_token
```

## 错误处理
所有 API 在发生错误时会返回相应的 HTTP 状态码和错误信息：

- 400 Bad Request: 请求参数错误
- 401 Unauthorized: 未认证或 token 无效
- 403 Forbidden: 权限不足
- 404 Not Found: 资源不存在
- 500 Internal Server Error: 服务器内部错误

错误响应格式：
```json
{
    "error": "错误描述信息"
}
```

## 注意事项
1. 所有需要认证的接口都必须在请求头中包含有效的 JWT Token
2. Token 过期时需要使用 refresh token 获取新的 access token
3. 创建分类和标签时名称不能重复
4. 任务列表支持多种过滤和排序方式
5. 文件上传接口需要使用 multipart/form-data 格式
