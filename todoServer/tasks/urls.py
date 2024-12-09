from django.urls import path, include
from rest_framework.routers import DefaultRouter
from rest_framework_nested import routers
from . import views

router = DefaultRouter()
router.register('categories', views.CategoryViewSet, basename='category')
router.register('tags', views.TagViewSet, basename='tag')
router.register('tasks', views.TaskViewSet, basename='task')

# Nested router for task comments
tasks_router = routers.NestedDefaultRouter(router, 'tasks', lookup='task')
tasks_router.register('comments', views.TaskCommentViewSet, basename='task-comments')

urlpatterns = [
    path('', include(router.urls)),
    path('', include(tasks_router.urls)),
]
