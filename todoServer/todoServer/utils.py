import logging
import traceback
from rest_framework.views import exception_handler
from rest_framework.response import Response
from rest_framework import status
from django.core.exceptions import ValidationError
from django.db import IntegrityError

logger = logging.getLogger('django')

def custom_exception_handler(exc, context):
    """
    自定义异常处理器
    """
    # 首先调用 REST framework 的默认异常处理
    response = exception_handler(exc, context)
    
    # 获取详细的错误信息
    error_stack = traceback.format_exc()
    
    # 获取请求信息
    request = context.get('request', None)
    view = context.get('view', None)
    view_name = view.__class__.__name__ if view else 'Unknown View'
    
    # 记录错误日志
    logger.error(f"""
API Error Details:
View: {view_name}
URL: {request.path if request else 'Unknown'}
Method: {request.method if request else 'Unknown'}
User: {request.user if request else 'Anonymous'}
Error Type: {exc.__class__.__name__}
Error Message: {str(exc)}
Stack Trace:
{error_stack}
    """)
    
    # 如果是已知异常类型，返回自定义响应
    if isinstance(exc, ValidationError):
        return Response({
            'error': 'Validation Error',
            'detail': str(exc),
        }, status=status.HTTP_400_BAD_REQUEST)
        
    elif isinstance(exc, IntegrityError):
        return Response({
            'error': 'Database Error',
            'detail': '数据完整性错误，可能是唯一性约束被违反',
        }, status=status.HTTP_400_BAD_REQUEST)
        
    # 如果是未处理的异常，返回500错误
    if response is None:
        return Response({
            'error': 'Internal Server Error',
            'detail': str(exc) if str(exc) else '服务器内部错误',
        }, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
    
    return response
