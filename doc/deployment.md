# TodoServer 部署文档

## 目录
1. [环境要求](#环境要求)
2. [目录结构](#目录结构)
3. [部署步骤](#部署步骤)
4. [配置说明](#配置说明)
5. [故障排查](#故障排查)

## 环境要求

### 服务器环境
- Ubuntu 20.04 LTS
- Docker 27.4.1+
- 开放端口：80, 443, 8000

### 域名和证书
- 域名：playstudy.asia
- SSL证书：已配置在 nginx/playstudy.asia_nginx/ 目录

## 目录结构

```bash
todoServer/
├── media/
│   └── website/
│       └── index/              # 静态网站文件
│           ├── index.html
│           ├── checkin2.png
│           └── icon.png
├── nginx/
│   ├── conf.d/
│   │   └── default.conf       # Nginx 配置
│   └── playstudy.asia_nginx/  # SSL 证书目录
│       ├── playstudy.asia.key
│       └── playstudy.asia_bundle.crt
├── sql/
│   └── todo_db_1223.sql      # 数据库初始化脚本
├── .env                      # 环境变量配置
├── docker-compose.yml        # Docker 编排文件
├── Dockerfile               # Django 应用构建文件
└── requirements.txt         # Python 依赖
```

## 部署步骤

### 1. 准备工作
```bash
# SSH 登录到服务器
ssh root@your-server-ip

# 创建项目目录
mkdir -p /root/todoServer

# 上传项目文件（在本地执行）
scp -r todoServer/* root@your-server-ip:/root/todoServer/

# 设置文件权限
cd /root/todoServer
chmod -R 755 .
```

### 2. 配置环境变量
```bash
# 检查并修改 .env 文件
vim .env

# 确保包含以下配置
DEBUG=True
SECRET_KEY=your-secret-key
MYSQL_DATABASE=todo_db
MYSQL_ROOT_PASSWORD=root_password
MYSQL_USER=root
MYSQL_PASSWORD=root_password
MYSQL_HOST=db
```

### 3. 启动服务
```bash
# 停止现有服务（如果有）
docker-compose down -v

# 构建并启动服务
docker-compose up -d --build

# 查看服务状态
docker-compose ps

# 查看日志
docker-compose logs -f
```

### 4. 初始化数据库
```bash
# 等待数据库完全启动
docker-compose logs db

# 执行数据库迁移
docker exec todo_web python manage.py migrate

# 收集静态文件
docker exec todo_web python manage.py collectstatic --noinput
```

## 配置说明

### Nginx 配置
```nginx
# nginx/conf.d/default.conf
server {
    listen 443 ssl;
    server_name playstudy.asia www.playstudy.asia;

    # SSL 配置
    ssl_certificate /etc/nginx/ssl/playstudy.asia_bundle.crt;
    ssl_certificate_key /etc/nginx/ssl/playstudy.asia.key;

    # 静态网站配置
    location / {
        root /usr/share/nginx/html;
        index index.html;
    }

    # Django 服务
    location ~ ^/(api|admin)/ {
        proxy_pass http://web:8000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
```

### Docker 配置
```yaml
# docker-compose.yml 关键配置
services:
  web:
    build: .
    volumes:
      - .:/app
    environment:
      - MYSQL_HOST=db
      
  db:
    image: mysql:8.0
    volumes:
      - mysql_data:/var/lib/mysql
      - ./sql:/docker-entrypoint-initdb.d

  nginx:
    image: nginx:alpine
    volumes:
      - ./nginx/conf.d:/etc/nginx/conf.d
      - ./nginx/playstudy.asia_nginx:/etc/nginx/ssl
      - ./media/website/index:/usr/share/nginx/html
```

## 故障排查

### 1. 检查服务状态
```bash
# 查看所有容器状态
docker-compose ps

# 查看各服务日志
docker-compose logs web
docker-compose logs db
docker-compose logs nginx
```

### 2. 常见问题解决

#### 数据库连接问题
```bash
# 检查数据库连接
docker exec todo_db mysql -uroot -proot_password -e "show databases;"

# 检查数据库日志
docker-compose logs db
```

#### 静态文件问题
```bash
# 重新收集静态文件
docker exec todo_web python manage.py collectstatic --noinput

# 检查 Nginx 配置
docker exec todo_nginx nginx -t
```

#### SSL 证书问题
```bash
# 检查证书文件权限
ls -l nginx/playstudy.asia_nginx/

# 检查 Nginx SSL 配置
docker exec todo_nginx nginx -t
```

### 3. 重启服务
```bash
# 重启所有服务
docker-compose restart

# 重启单个服务
docker-compose restart web
docker-compose restart nginx
```

## 维护命令

### 备份数据
```bash
# 备份数据库
docker exec todo_db mysqldump -uroot -proot_password todo_db > backup.sql
```

### 更新部署
```bash
# 更新代码后重新部署
git pull
docker-compose down
docker-compose up -d --build
```

### 查看日志
```bash
# 查看实时日志
docker-compose logs -f

# 查看特定服务日志
docker-compose logs -f web
``` 