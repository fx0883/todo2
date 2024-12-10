import { ref, computed } from 'vue'

export function useValidation(rules = {}) {
  const errors = ref({})
  const touched = ref({})

  // 验证单个字段
  const validateField = (field, value) => {
    if (!rules[field]) return true

    const fieldRules = rules[field]
    const fieldErrors = []

    fieldRules.forEach(rule => {
      if (typeof rule === 'function') {
        const result = rule(value)
        if (result !== true) {
          fieldErrors.push(result)
        }
      }
    })

    if (fieldErrors.length > 0) {
      errors.value[field] = fieldErrors
      return false
    }

    delete errors.value[field]
    return true
  }

  // 验证所有字段
  const validate = (values) => {
    let isValid = true
    Object.keys(rules).forEach(field => {
      const fieldIsValid = validateField(field, values[field])
      if (!fieldIsValid) {
        isValid = false
      }
    })
    return isValid
  }

  // 标记字段为已触碰
  const touch = (field) => {
    touched.value[field] = true
  }

  // 重置验证状态
  const reset = () => {
    errors.value = {}
    touched.value = {}
  }

  // 检查是否有错误
  const hasErrors = computed(() => {
    return Object.keys(errors.value).length > 0
  })

  // 获取特定字段的错误
  const getFieldError = (field) => {
    return errors.value[field]?.[0]
  }

  // 常用验证规则
  const commonRules = {
    required: (message = '此字段是必填的') => (value) => {
      return (value !== null && value !== undefined && value !== '') || message
    },
    email: (message = '请输入有效的邮箱地址') => (value) => {
      const emailRegex = /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$/i
      return !value || emailRegex.test(value) || message
    },
    minLength: (min, message) => (value) => {
      return !value || value.length >= min || message || `最少需要 ${min} 个字符`
    },
    maxLength: (max, message) => (value) => {
      return !value || value.length <= max || message || `最多允许 ${max} 个字符`
    },
    pattern: (regex, message = '格式不正确') => (value) => {
      return !value || regex.test(value) || message
    },
    match: (field, message = '两个字段不匹配') => (value, formValues) => {
      return !value || value === formValues[field] || message
    }
  }

  return {
    // 状态
    errors,
    touched,
    hasErrors,

    // 方法
    validateField,
    validate,
    touch,
    reset,
    getFieldError,
    commonRules
  }
}
