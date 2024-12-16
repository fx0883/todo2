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

# 创建统计相关的路由
stats_router = routers.NestedDefaultRouter(router, 'tasks', lookup='task')

urlpatterns = [
    path('', include(router.urls)),
    path('', include(tasks_router.urls)),
    path('tasks/month_stats/<str:month>/', views.MonthStatsView.as_view(), name='month-stats'),
    path('tasks/category_stats/<str:month>/', views.CategoryStatsView.as_view(), name='category-stats'),
    path('tasks/daily_trend/<str:month>/', views.DailyTrendView.as_view(), name='daily-trend'),
    path('tasks/priority_stats/<str:month>/', views.PriorityStatsView.as_view(), name='priority-stats'),
]
