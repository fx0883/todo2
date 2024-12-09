from django.urls import path, include
from rest_framework.routers import DefaultRouter
from . import views

router = DefaultRouter()
router.register('templates', views.NotificationTemplateViewSet, basename='notification-template')
router.register('notifications', views.NotificationViewSet, basename='notification')
router.register('devices', views.NotificationDeviceViewSet, basename='notification-device')

urlpatterns = [
    path('', include(router.urls)),
]
