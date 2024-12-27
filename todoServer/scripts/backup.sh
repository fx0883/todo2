#!/bin/bash

# 设置备份目录
BACKUP_ROOT="/root/backups"
BACKUP_DIR="$BACKUP_ROOT"
DATE=$(date +%Y%m%d_%H%M%S)
MYSQL_USER="root"
MYSQL_PASSWORD="root_password"
MYSQL_DATABASE="todo_db"

# 创建所需的所有目录并设置权限
echo "Creating directories and setting permissions..."
mkdir -p "$BACKUP_ROOT"
mkdir -p "$BACKUP_DIR/database"
mkdir -p "$BACKUP_DIR/media"
mkdir -p "$BACKUP_DIR/static"
mkdir -p "/root/todoServer/media"
mkdir -p "/root/todoServer/static"

# 设置目录权限
chown -R root:root "$BACKUP_ROOT"
chmod -R 755 "$BACKUP_ROOT"
chown -R root:root "/root/todoServer/media"
chmod -R 755 "/root/todoServer/media"
chown -R root:root "/root/todoServer/static"
chmod -R 755 "/root/todoServer/static"

echo "Starting backup process at $(date)"

# 数据库备份
echo "Backing up database..."
docker exec todo_db mysqldump -u$MYSQL_USER -p$MYSQL_PASSWORD $MYSQL_DATABASE > "$BACKUP_DIR/database/todo_db_$DATE.sql"
chmod 644 "$BACKUP_DIR/database/todo_db_$DATE.sql"

# 压缩媒体文件
echo "Backing up media files..."
tar -czf "$BACKUP_DIR/media/media_$DATE.tar.gz" -C /root/todoServer/media .
chmod 644 "$BACKUP_DIR/media/media_$DATE.tar.gz"

# 压缩静态文件
echo "Backing up static files..."
tar -czf "$BACKUP_DIR/static/static_$DATE.tar.gz" -C /root/todoServer/static .
chmod 644 "$BACKUP_DIR/static/static_$DATE.tar.gz"

# 保留最近30天的备份，删除旧备份
echo "Cleaning up old backups..."
find "$BACKUP_DIR/database" -name "*.sql" -mtime +30 -delete
find "$BACKUP_DIR/media" -name "*.tar.gz" -mtime +30 -delete
find "$BACKUP_DIR/static" -name "*.tar.gz" -mtime +30 -delete

echo "Backup completed at $(date)" 