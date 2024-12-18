from rest_framework_simplejwt.views import TokenObtainPairView, TokenRefreshView, TokenVerifyView
from drf_spectacular.utils import extend_schema_view, extend_schema

@extend_schema_view(
    post=extend_schema(
        summary="获取访问令牌和刷新令牌",
        tags=['用户认证']
    )
)
class CustomTokenObtainPairView(TokenObtainPairView):
    pass

@extend_schema_view(
    post=extend_schema(
        summary="使用刷新令牌获取新的访问令牌",
        tags=['用户认证']
    )
)
class CustomTokenRefreshView(TokenRefreshView):
    pass

@extend_schema_view(
    post=extend_schema(
        summary="验证令牌是否有效",
        tags=['用户认证']
    )
)
class CustomTokenVerifyView(TokenVerifyView):
    pass
