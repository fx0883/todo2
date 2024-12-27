# 远程服务器信息
$REMOTE_HOST = "your-backup-server"
$REMOTE_USER = "backup"
$REMOTE_PASSWORD = "your-password"  # 远程服务器密码
$REMOTE_DIR = "/backup/todoServer"
$LOCAL_BACKUP = "D:\backups"  # 本地备份目录

# 确保本地备份目录存在
New-Item -ItemType Directory -Force -Path $LOCAL_BACKUP

# 使用 WinSCP 进行同步（需要先安装 WinSCP）
$WinSCPScript = @"
option batch abort
option confirm off
open sftp://${REMOTE_USER}:${REMOTE_PASSWORD}@${REMOTE_HOST}/
synchronize remote "${LOCAL_BACKUP}" "${REMOTE_DIR}"
exit
"@

# 保存 WinSCP 脚本
$WinSCPScript | Out-File -Encoding ASCII "sync_script.txt"

# 执行 WinSCP 同步
& 'C:\Program Files (x86)\WinSCP\WinSCP.com' /script=sync_script.txt /log=sync.log

# 清理临时文件
Remove-Item "sync_script.txt"

# 输出完成信息
Write-Host "Backup sync completed at $(Get-Date)" 