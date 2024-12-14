"""
URL configuration for todoServer project.

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/5.1/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.contrib import admin
from django.urls import path, include
from rest_framework.documentation import include_docs_urls
from django.conf import settings
from django.conf.urls.static import static
from drf_spectacular.views import SpectacularAPIView, SpectacularSwaggerView, SpectacularRedocView
from rest_framework_simplejwt.views import (
    TokenObtainPairView,
    TokenRefreshView,
    TokenVerifyView,
)

urlpatterns = [
    path('admin/', admin.site.urls),
    
    # API 文档
    path('api/schema/', SpectacularAPIView.as_view(), name='schema'),
    path('api/docs/', SpectacularSwaggerView.as_view(url_name='schema'), name='swagger-ui'),
    path('api/redoc/', SpectacularRedocView.as_view(url_name='schema'), name='redoc'),
    
    # API endpoints
    path('api/v1/accounts/', include('accounts.urls')),
    path('api/v1/tasks/', include('tasks.urls')),
    path('api/v1/notifications/', include('notifications.urls')),
    
    # JWT Token URLs
    path('api/v1/token/', TokenObtainPairView.as_view(), name='token_obtain_pair'),
    path('api/v1/token/refresh/', TokenRefreshView.as_view(), name='token_refresh'),
    path('api/v1/token/verify/', TokenVerifyView.as_view(), name='token_verify'),
    
    # Authentication
    path('api/v1/auth/', include('rest_framework.urls')),
    path('api/v1/oauth/', include('oauth2_provider.urls', namespace='oauth2_provider')),
    path('api/v1/social/', include('social_django.urls', namespace='social')),
    
    # API documentation
    # path('api/docs-old/', include_docs_urls(title='Todo API')),
] + static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)

# from django.contrib.auth.hashers import make_password
#
# new_password = make_password('Fengxuan_0027337')
# print(new_password)

if settings.DEBUG:
    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)