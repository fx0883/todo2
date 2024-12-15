/**
 * 格式化日期时间
 * @param {Date} date 日期对象
 * @param {string} format 格式化字符串，支持：
 *  - YYYY: 年份
 *  - MM: 月份（补零）
 *  - DD: 日期（补零）
 *  - HH: 小时（补零）
 *  - mm: 分钟（补零）
 *  - ss: 秒钟（补零）
 * @returns {string} 格式化后的字符串
 */
export function formatDateTime(date, format = 'YYYY-MM-DD HH:mm:ss') {
  const year = date.getFullYear()
  const month = date.getMonth() + 1
  const day = date.getDate()
  const hours = date.getHours()
  const minutes = date.getMinutes()
  const seconds = date.getSeconds()

  const padZero = (num) => String(num).padStart(2, '0')

  return format
    .replace('YYYY', year)
    .replace('MM', padZero(month))
    .replace('DD', padZero(day))
    .replace('HH', padZero(hours))
    .replace('mm', padZero(minutes))
    .replace('ss', padZero(seconds))
}

/**
 * 获取相对时间描述
 * @param {Date|string} date 日期对象或日期字符串
 * @returns {string} 相对时间描述
 */
export function getRelativeTime(date) {
  const now = new Date()
  const target = new Date(date)
  const diff = now - target
  const diffDays = Math.floor(diff / (1000 * 60 * 60 * 24))
  const diffHours = Math.floor(diff / (1000 * 60 * 60))
  const diffMinutes = Math.floor(diff / (1000 * 60))

  if (diffDays > 0) {
    if (diffDays === 1) return '昨天'
    if (diffDays === 2) return '前天'
    if (diffDays <= 7) return `${diffDays}天前`
    return formatDateTime(target, 'MM-DD')
  }

  if (diffHours > 0) {
    return `${diffHours}小时前`
  }

  if (diffMinutes > 0) {
    return `${diffMinutes}分钟前`
  }

  return '刚刚'
}

/**
 * 判断是否是同一天
 * @param {Date} date1 日期1
 * @param {Date} date2 日期2
 * @returns {boolean}
 */
export function isSameDay(date1, date2) {
  return (
    date1.getFullYear() === date2.getFullYear() &&
    date1.getMonth() === date2.getMonth() &&
    date1.getDate() === date2.getDate()
  )
}

/**
 * 获取日期范围
 * @param {Date} date 日期
 * @param {string} type 类型：'day' | 'week' | 'month'
 * @returns {{start: Date, end: Date}} 日期范围
 */
export function getDateRange(date, type = 'day') {
  const start = new Date(date)
  const end = new Date(date)

  switch (type) {
    case 'day':
      start.setHours(0, 0, 0, 0)
      end.setHours(23, 59, 59, 999)
      break
    case 'week':
      start.setDate(start.getDate() - start.getDay())
      end.setDate(start.getDate() + 6)
      end.setHours(23, 59, 59, 999)
      break
    case 'month':
      start.setDate(1)
      end.setMonth(end.getMonth() + 1, 0)
      end.setHours(23, 59, 59, 999)
      break
  }

  return { start, end }
}
