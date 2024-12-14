// 日期格式化
export const formatDate = (date, fmt = 'YYYY-MM-DD HH:mm:ss') => {
  if (!date) return ''
  if (typeof date === 'string') {
    date = new Date(date)
    
    if (isNaN(date.getTime())) {
      date = new Date(date.replace(/-/g, '/'))
    }
  }
  if (typeof date === 'number') {
    date = new Date(date)
  }
  
  if (isNaN(date.getTime())) {
    console.error('Invalid date:', date)
    return ''
  }

  const now = new Date()
  const diff = now - date
  const seconds = Math.floor(diff / 1000)
  const minutes = Math.floor(seconds / 60)
  const hours = Math.floor(minutes / 60)
  const days = Math.floor(hours / 24)

  // GitHub 风格的时间显示
  if (seconds < 60) {
    return '1分钟内'
  }
  
  if (minutes < 60) {
    return `${minutes}分钟前`
  }
  
  if (hours < 24) {
    return `${hours}小时前`
  }
  
  // 获取日期的年月日
  const dateYear = date.getFullYear()
  const dateMonth = date.getMonth()
  const dateDay = date.getDate()
  
  // 获取当前的年月日
  const nowYear = now.getFullYear()
  const nowMonth = now.getMonth()
  const nowDay = now.getDate()
  
  // 如果是昨天
  if (days === 1) {
    return '昨天'
  }
  
  // 如果是前天
  if (days === 2) {
    return '前天'
  }
  
  // 如果是今年
  if (dateYear === nowYear) {
    // 显示月份和日期
    return `${dateMonth + 1}月${dateDay}日`
  }
  
  // 不是今年，显示完整年月日
  return `${dateYear}年${dateMonth + 1}月${dateDay}日`
}
