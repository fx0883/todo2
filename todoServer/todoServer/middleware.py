import logging
import traceback
from django.http import JsonResponse
from rest_framework import status

logger = logging.getLogger('django')

class ErrorLoggingMiddleware:
    def __init__(self, get_response):
        self.get_response = get_response

    def __call__(self, request):
        response = self.get_response(request)
        return response

    def process_exception(self, request, exception):
        """处理视图中的异常并记录日志"""
        # 获取完整的错误堆栈
        error_stack = traceback.format_exc()
        
        # 记录错误信息
        logger.error(f"""
API Error Details:
URL: {request.path}
Method: {request.method}
User: {request.user}
Error: {str(exception)}
Stack Trace:
{error_stack}
        """)
        
        # 返回错误响应
        return JsonResponse({
            'error': str(exception),
            'detail': 'An error occurred while processing your request.',
            'path': request.path,
        }, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
