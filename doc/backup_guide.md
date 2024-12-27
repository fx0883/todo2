# TodoServer 备份指南

## 目录
1. [备份概述](#备份概述)
2. [自动备份配置](#自动备份配置)
3. [手动备份操作](#手动备份操作)
4. [远程备份配置](#远程备份配置)
5. [备份恢复](#备份恢复)
6. [注意事项](#注意事项)

## 备份概述

### 备份内容
- 数据库备份（MySQL）
- 媒体文件备份（用户上传的文件）
- 静态文件备份（系统静态文件）

### 备份策略
- 每日自动备份（凌晨3点）
- 保留最近30天的备份
- 本地备份 + 远程备份双保险

## 自动备份配置

### 1. 创建备份目录
```bash
# 创建备份根目录
mkdir -p /root/backups
mkdir -p /root/backups/database
mkdir -p /root/backups/media
mkdir -p /root/backups/static

# 设置目录权限
chmod -R 755 /root/backups
chown -R root:root /root/backups
```

### 2. 配置自动备份脚本
```bash
# 复制备份脚本到指定目录
cp /root/todoServer/scripts/backup.sh /root/todoServer/scripts/
chmod +x /root/todoServer/scripts/backup.sh

# 编辑 crontab
crontab -e

# 添加定时任务（每天凌晨3点执行）
0 3 * * * /root/todoServer/scripts/backup.sh >> /root/backups/backup.log 2>&1
```

### 3. 备份脚本说明
```bash
# backup.sh 主要功能：
- 创建必要的备份目录
- 设置正确的目录权限
- 备份数据库到 SQL 文件
- 压缩媒体文件和静态文件
- 自动清理30天前的旧备份
```

## 手动备份操作

### 1. 数据库备份
```bash
# 备份整个数据库
docker exec todo_db mysqldump -uroot -proot_password todo_db > /root/backups/database/manual_backup_$(date +%Y%m%d_%H%M%S).sql

# 备份特定表
docker exec todo_db mysqldump -uroot -proot_password todo_db table_name > /root/backups/database/table_backup_$(date +%Y%m%d_%H%M%S).sql
```

### 2. 文件备份
```bash
# 备份媒体文件
tar -czf /root/backups/media/manual_media_$(date +%Y%m%d_%H%M%S).tar.gz -C /root/todoServer/media .

# 备份静态文件
tar -czf /root/backups/static/manual_static_$(date +%Y%m%d_%H%M%S).tar.gz -C /root/todoServer/static .
```

## 远程备份配置

### Windows 环境配置

1. 安装 WinSCP：
```powershell
# 使用 Chocolatey 安装
choco install winscp
```

2. 配置远程备份脚本：
```powershell
# 编辑 remote_backup.ps1 中的配置
$REMOTE_HOST = "your-server-ip"        # 服务器 IP
$REMOTE_USER = "your-username"         # 用户名
$REMOTE_PASSWORD = "your-password"     # 密码
$REMOTE_DIR = "/backup/todoServer"     # 远程备份目录
$LOCAL_BACKUP = "D:\backups"           # 本地备份目录
```

3. 设置定时任务：
```powershell
# 打开任务计划程序
taskschd.msc

# 创建新任务：
# 触发器：每天凌晨 3:30
# 操作：运行 PowerShell 脚本
# 命令：powershell.exe -ExecutionPolicy Bypass -File "D:\path\to\remote_backup.ps1"
```

## 备份恢复

### 1. 恢复数据库
```bash
# 停止 web 服务
docker-compose stop web

# 恢复数据库
docker exec -i todo_db mysql -uroot -proot_password todo_db < /root/backups/database/backup_file.sql

# 启动 web 服务
docker-compose start web
```

### 2. 恢复文件
```bash
# 恢复媒体文件
tar -xzf /root/backups/media/media_backup.tar.gz -C /root/todoServer/media

# 恢复静态文件
tar -xzf /root/backups/static/static_backup.tar.gz -C /root/todoServer/static

# 设置正确的权限
chmod -R 755 /root/todoServer/media
chmod -R 755 /root/todoServer/static
```

## 注意事项

### 1. 备份检查
```bash
# 检查备份是否成功
ls -l /root/backups/database/
ls -l /root/backups/media/
ls -l /root/backups/static/

# 检查备份日志
tail -f /root/backups/backup.log
```

### 2. 磁盘空间管理
```bash
# 检查备份目录大小
du -sh /root/backups/*

# 检查可用磁盘空间
df -h
```

### 3. 安全建议
- 定期验证备份文件的完整性
- 确保备份文件的权限设置正确
- 考虑对备份文件进行加密
- 建议保留多个时间点的备份
- 定期测试备份恢复流程

### 4. 故障排查
```bash
# 检查 cron 服务状态
service cron status

# 检查 cron 日志
grep CRON /var/log/syslog

# 手动执行备份脚本测试
/root/todoServer/scripts/backup.sh
``` 