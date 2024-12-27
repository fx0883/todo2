# TodoServer 备份指南

## 1. 手动备份

### 1.1 数据库备份
```bash
# 备份整个数据库
docker exec todo_db mysqldump -uroot -proot_password todo_db > backup.sql

# 备份特定表
docker exec todo_db mysqldump -uroot -proot_password todo_db table_name > table_backup.sql
```

### 1.2 媒体文件备份
```bash
# 备份整个媒体目录
tar -czf media_backup.tar.gz -C /root/todoServer/media .

# 备份特定目录
tar -czf avatars_backup.tar.gz -C /root/todoServer/media/images/avatar .
```

### 1.3 静态文件备份
```bash
# 备份静态文件
tar -czf static_backup.tar.gz -C /root/todoServer/static .
```

## 2. 自动备份

### 2.1 配置自动备份
1. 确保备份脚本可执行：
```bash
chmod +x /root/todoServer/scripts/backup.sh
```

2. 设置定时任务：
```bash
crontab -e

# 添加以下内容（每天凌晨3点执行）
0 3 * * * /root/todoServer/scripts/backup.sh
```

### 2.2 查看备份状态
```bash
# 查看备份日志
tail -f /root/backups/backup.log

# 查看备份文件
ls -l /root/backups/database/
ls -l /root/backups/media/
ls -l /root/backups/static/
```

## 3. 恢复备份

### 3.1 恢复数据库
```bash
# 停止 web 服务
docker-compose stop web

# 恢复数据库
docker exec -i todo_db mysql -uroot -proot_password todo_db < backup.sql

# 启动 web 服务
docker-compose start web
```

### 3.2 恢复文件
```bash
# 恢复媒体文件
tar -xzf media_backup.tar.gz -C /root/todoServer/media

# 恢复静态文件
tar -xzf static_backup.tar.gz -C /root/todoServer/static
```

## 4. 备份策略

- 数据库每天备份一次
- 媒体文件每天备份一次
- 静态文件每天备份一次
- 保留最近30天的备份
- 备份文件存储在 /root/backups 目录下
- 按日期命名备份文件

## 5. 注意事项

1. 定期检查备份是否成功
2. 确保备份目录有足够空间
3. 建议将备份文件同步到远程存储
4. 定期测试备份恢复流程 