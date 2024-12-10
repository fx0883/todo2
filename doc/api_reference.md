# API 参考文档

## 目录
1. [Composables API](#composables-api)
2. [Store API](#store-api)
3. [HTTP API](#http-api)
4. [工具函数](#工具函数)

## Composables API

### useAuth
认证相关的功能

#### 方法
```typescript
interface AuthComposable {
  // 状态
  loading: Ref<boolean>
  error: Ref<string | null>
  user: ComputedRef<User | null>
  
  // 方法
  login(credentials: Credentials): Promise<boolean>
  register(userData: UserData): Promise<boolean>
  logout(): Promise<void>
  requestReset(email: string): Promise<boolean>
  confirmReset(token: string, password: string): Promise<boolean>
}

interface Credentials {
  username: string
  password: string
}

interface UserData {
  username: string
  email: string
  password: string
}
```

#### 使用示例
```javascript
const { login, loading, error } = useAuth()

const handleLogin = async () => {
  const success = await login({
    username: 'user',
    password: 'pass'
  })
  
  if (success) {
    // 登录成功处理
  }
}
```

### useTask
任务管理功能

#### 方法
```typescript
interface TaskComposable {
  // 状态
  loading: Ref<boolean>
  error: Ref<string | null>
  tasks: ComputedRef<Task[]>
  
  // 任务操作
  fetchTasks(filters?: TaskFilters): Promise<void>
  createTask(task: TaskData): Promise<Task>
  updateTask(id: string, data: Partial<TaskData>): Promise<Task>
  deleteTask(id: string): Promise<void>
  
  // 分类操作
  fetchCategories(): Promise<void>
  createCategory(data: CategoryData): Promise<Category>
  
  // 标签操作
  fetchTags(): Promise<void>
  createTag(data: TagData): Promise<Tag>
}

interface TaskFilters {
  category?: string
  tag?: string
  status?: 'all' | 'completed' | 'pending'
  priority?: number
}
```

#### 使用示例
```javascript
const { createTask, tasks, loading } = useTask()

const handleCreate = async (taskData) => {
  const task = await createTask({
    title: '新任务',
    description: '描述',
    dueDate: new Date()
  })
}
```

### useCache
缓存管理功能

#### 方法
```typescript
interface CacheComposable {
  get<T>(key: string): T | null
  set<T>(key: string, value: T, ttl?: number): void
  remove(key: string): void
  clear(): void
  has(key: string): boolean
}
```

#### 使用示例
```javascript
const cache = useCache()

// 设置缓存
cache.set('user-123', userData, 3600 * 1000) // 1小时过期

// 获取缓存
const user = cache.get('user-123')
```

## Store API

### TaskStore
任务状态管理

#### 状态和方法
```typescript
interface TaskStore {
  // 状态
  tasks: Task[]
  categories: Category[]
  tags: Tag[]
  loading: boolean
  
  // Getters
  completedTasks: Task[]
  pendingTasks: Task[]
  tasksByCategory: Record<string, Task[]>
  
  // Actions
  fetchTasks(filters?: TaskFilters): Promise<void>
  createTask(task: TaskData): Promise<Task>
  updateTask(id: string, data: Partial<TaskData>): Promise<Task>
  deleteTask(id: string): Promise<void>
  reset(): void
}
```

#### 使用示例
```javascript
const taskStore = useTaskStore()

// 获取状态
const { tasks, loading } = storeToRefs(taskStore)

// 调用 action
await taskStore.fetchTasks()
```

## HTTP API

### 任务相关接口

#### 获取任务列表
```
GET /api/tasks
Query 参数:
  - category: string
  - tag: string
  - status: 'all' | 'completed' | 'pending'
  - priority: number
```

#### 创建任务
```
POST /api/tasks
Body:
{
  title: string
  description?: string
  dueDate?: string
  priority?: number
  categoryId?: string
  tags?: string[]
}
```

#### 更新任务
```
PUT /api/tasks/:id
Body: Partial<TaskData>
```

#### 删除任务
```
DELETE /api/tasks/:id
```

### 认证相关接口

#### 登录
```
POST /api/auth/login
Body:
{
  username: string
  password: string
}
```

#### 注册
```
POST /api/auth/register
Body:
{
  username: string
  email: string
  password: string
}
```

## 工具函数

### 日期处理
```typescript
interface DateUtils {
  formatDate(date: Date): string
  parseDate(dateString: string): Date
  isOverdue(date: Date): boolean
}
```

### 验证工具
```typescript
interface ValidationUtils {
  validateEmail(email: string): boolean
  validatePassword(password: string): boolean
  validateUsername(username: string): boolean
}
```

### 错误处理
```typescript
interface ErrorUtils {
  handleApiError(error: any): string
  isNetworkError(error: any): boolean
  formatErrorMessage(error: any): string
}
```
