from django.urls import path, include
from rest_framework.routers import DefaultRouter
from . import views

router = DefaultRouter()
router.register('users', views.UserViewSet)
router.register('profiles', views.UserProfileViewSet)
router.register('devices', views.UserDeviceViewSet)
router.register('feedback', views.UserFeedbackViewSet, basename='feedback')

urlpatterns = [
    path('', include(router.urls)),
]
