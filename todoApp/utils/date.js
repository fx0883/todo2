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
  
  const o = {
    'M+': date.getMonth() + 1,
    'D+': date.getDate(),
    'H+': date.getHours(),
    'm+': date.getMinutes(),
    's+': date.getSeconds(),
    'q+': Math.floor((date.getMonth() + 3) / 3),
    S: date.getMilliseconds()
  }
  
  if (/(Y+)/.test(fmt)) {
    fmt = fmt.replace(RegExp.$1, (date.getFullYear() + '').substr(4 - RegExp.$1.length))
  }
  
  for (let k in o) {
    if (new RegExp('(' + k + ')').test(fmt)) {
      fmt = fmt.replace(
        RegExp.$1,
        RegExp.$1.length === 1 ? o[k] : ('00' + o[k]).substr(('' + o[k]).length)
      )
    }
  }
  
  return fmt
}

// 获取相对时间
export const getRelativeTime = (timeStamp) => {
  const minute = 1000 * 60
  const hour = minute * 60
  const day = hour * 24
  const week = day * 7
  const month = day * 30
  const year = month * 12

  const now = new Date().getTime()
  const diffValue = now - new Date(timeStamp).getTime()

  if (diffValue < 0) return '未来'

  const yearC = diffValue / year
  const monthC = diffValue / month
  const weekC = diffValue / week
  const dayC = diffValue / day
  const hourC = diffValue / hour
  const minC = diffValue / minute

  if (yearC >= 1) return parseInt(yearC) + '年前'
  if (monthC >= 1) return parseInt(monthC) + '月前'
  if (weekC >= 1) return parseInt(weekC) + '周前'
  if (dayC >= 1) return parseInt(dayC) + '天前'
  if (hourC >= 1) return parseInt(hourC) + '小时前'
  if (minC >= 1) return parseInt(minC) + '分钟前'
  return '刚刚'
}
