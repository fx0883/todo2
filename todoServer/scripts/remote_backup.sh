#!/bin/bash

# 远程服务器信息
REMOTE_HOST="your-backup-server"
REMOTE_USER="backup"
REMOTE_DIR="/backup/todoServer"

# 同步备份到远程服务器
rsync -avz --delete /root/backups/ $REMOTE_USER@$REMOTE_HOST:$REMOTE_DIR/ 