from django.shortcuts import render
from rest_framework import viewsets, status, permissions
from rest_framework.decorators import action
from rest_framework.response import Response
from django.contrib.auth import get_user_model, authenticate, login
from .models import UserProfile, UserDevice, VerificationCode, User, UserFeedback
from tasks.models import Task
from django.conf import settings
from notifications.models import Notification
from .serializers import (
    UserSerializer, UserProfileSerializer, UserDeviceSerializer,
    RegisterSerializer, LoginSerializer, PasswordResetRequestSerializer, PasswordResetConfirmSerializer,
    UserFeedbackSerializer
)
from rest_framework.authtoken.models import Token
from drf_spectacular.utils import extend_schema_view, extend_schema, OpenApiExample, OpenApiResponse
from django.views.decorators.csrf import csrf_exempt
from django.utils.decorators import method_decorator
from django.core.mail import send_mail
from django.utils import timezone
import random
import string
import os
import uuid
from rest_framework.parsers import MultiPartParser
from django.db.models import Count, Q
from rest_framework.exceptions import ValidationError
from rest_framework.views import exception_handler

User = get_user_model()

def custom_exception_handler(exc, context):
    response = exception_handler(exc, context)
    
    if response is not None:
        if isinstance(exc, ValidationError):
            # 如果是验证错误，获取第一个错误信息
            if isinstance(exc.detail, dict):
                first_error = next(iter(exc.detail.values()))[0]
            elif isinstance(exc.detail, list):
                first_error = exc.detail[0]
            else:
                first_error = str(exc.detail)
                
            response.data = {
                'error_message': first_error
            }
    
    return response

@method_decorator(csrf_exempt, name='dispatch')
@extend_schema_view(
    list=extend_schema(
        summary="获取用户列表",
        tags=['用户管理']
    ),
    retrieve=extend_schema(
        summary="获取用户详情",
        tags=['用户管理']
    ),
    create=extend_schema(
        summary="创建用户",
        tags=['用户管理']
    ),
    update=extend_schema(
        summary="更新用户",
        tags=['用户管理']
    ),
    partial_update=extend_schema(
        summary="部分更新用户",
        tags=['用户管理']
    ),
    destroy=extend_schema(
        summary="删除用户",
        tags=['用户管理']
    ),
    register=extend_schema(
        summary="用户注册",
        tags=['用户认证'],
        request=RegisterSerializer,
        responses={201: UserSerializer},
        examples=[
            OpenApiExample(
                'Register Example',
                value={
                    'username': 'johndoe',
                    'email': 'john@example.com',
                    'password': 'securepassword123',
                    'confirm_password': 'securepassword123',
                    'first_name': 'John',
                    'last_name': 'Doe'
                }
            )
        ]
    ),
    login=extend_schema(
        summary="用户登录",
        tags=['用户认证'],
        request=LoginSerializer,
        responses={
            200: OpenApiResponse(
                description="登录成功",
                examples=[
                    OpenApiExample(
                        'Login Response Example',
                        value={
                            'refresh': 'your-refresh-token-here',
                            'access': 'your-access-token-here',
                            'user': {
                                'id': 1,
                                'username': 'johndoe',
                                'email': 'john@example.com',
                                'first_name': 'John',
                                'last_name': 'Doe',
                                'is_active': True
                            }
                        }
                    )
                ]
            )
        },
        examples=[
            OpenApiExample(
                'Login Request Example',
                value={
                    'username': 'johndoe',
                    'password': 'securepassword123'
                }
            )
        ]
    ),
    me=extend_schema(
        summary="获取当前用户信息",
        tags=['用户管理']
    ),
    request_password_reset=extend_schema(
        summary="请求密码重置",
        tags=['用户认证'],
        request=PasswordResetRequestSerializer,
        responses={200: OpenApiResponse(description="重置邮件已发送")}
    ),
    confirm_password_reset=extend_schema(
        summary="确认密码重置",
        tags=['用户认证'],
        request=PasswordResetConfirmSerializer,
        responses={200: OpenApiResponse(description="密码已重置")}
    ),
    upload_avatar=extend_schema(
        summary="上传用户头像",
        tags=['用户管理'],
        request={
            'multipart/form-data': {
                'type': 'object',
                'properties': {
                    'avatar': {
                        'type': 'string',
                        'format': 'binary',
                        'description': '用户头像文件'
                    }
                },
                'required': ['avatar']
            }
        },
        responses={
            200: OpenApiResponse(
                description='头像上传成功',
                examples=[
                    OpenApiExample(
                        'Success Response',
                        value={
                            'message': '头像上传成功',
                            'avatar_url': 'http://example.com/media/images/avatar/username_12345678.jpg'
                        }
                    )
                ]
            ),
            400: OpenApiResponse(
                description='请求错误',
                examples=[
                    OpenApiExample(
                        'Error Response',
                        value={
                            'error': '没有提供头像文件'
                        }
                    )
                ]
            )
        }
    ),
    get_task_stats=extend_schema(
        summary="获取用户任务统计",
        tags=['任务管理'],
        responses={
            200: OpenApiResponse(
                description="任务统计信息",
                examples=[
                    OpenApiExample(
                        'Task Stats Example',
                        value={
                            'total': 10,
                            'completed': 5,
                            'pending': 5,
                            'overdue': 5,
                            'completion_rate': 50.0  # 完成率（百分比）
                        }
                    )
                ]
            )
        }
    )
)
class UserViewSet(viewsets.ModelViewSet):
    queryset = User.objects.all()
    serializer_class = UserSerializer
    permission_classes = [permissions.IsAuthenticated]
    tags = ['用户管理']

    def get_permissions(self):
        if self.action in ['register', 'login', 'request_password_reset', 'confirm_password_reset']:
            return [permissions.AllowAny()]
        return super().get_permissions()

    def get_queryset(self):
        if self.action in ['list', 'retrieve']:
            return self.queryset.filter(id=self.request.user.id)
        return self.queryset

    @extend_schema(
        summary="用户注册",
        tags=['用户认证'],
        request=RegisterSerializer,
        responses={201: UserSerializer},
        examples=[
            OpenApiExample(
                'Register Example',
                value={
                    'username': 'johndoe',
                    'email': 'john@example.com',
                    'password': 'securepassword123',
                    'confirm_password': 'securepassword123',
                    'first_name': 'John',
                    'last_name': 'Doe'
                }
            )
        ]
    )
    @method_decorator(csrf_exempt)
    @action(detail=False, methods=['post'], permission_classes=[permissions.AllowAny], authentication_classes=[])
    def register(self, request):
        serializer = RegisterSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        user = serializer.save()
        token, _ = Token.objects.get_or_create(user=user)
        return Response({
            'token': token.key,
            'user': UserSerializer(user).data
        }, status=status.HTTP_201_CREATED)

    @extend_schema(
        summary="用户登录",
        tags=['用户认证'],
        request=LoginSerializer,
        responses={
            200: OpenApiResponse(
                description="登录成功",
                examples=[
                    OpenApiExample(
                        'Login Response Example',
                        value={
                            'refresh': 'your-refresh-token-here',
                            'access': 'your-access-token-here',
                            'user': {
                                'id': 1,
                                'username': 'johndoe',
                                'email': 'john@example.com',
                                'first_name': 'John',
                                'last_name': 'Doe',
                                'is_active': True
                            }
                        }
                    )
                ]
            )
        },
        examples=[
            OpenApiExample(
                'Login Request Example',
                value={
                    'username': 'johndoe',
                    'password': 'securepassword123'
                }
            )
        ]
    )
    @method_decorator(csrf_exempt)
    @action(detail=False, methods=['post'], permission_classes=[permissions.AllowAny], authentication_classes=[])
    def login(self, request):
        serializer = LoginSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        
        user = authenticate(
            username=serializer.validated_data['username'],
            password=serializer.validated_data['password']
        )
        
        if user:
            if not user.is_active:
                return Response(
                    {'error': '用户已被禁用'},
                    status=status.HTTP_401_UNAUTHORIZED
                )
            
            login(request, user)
            
            # 使用 JWT Token
            from rest_framework_simplejwt.tokens import RefreshToken
            refresh = RefreshToken.for_user(user)
            
            return Response({
                'refresh': str(refresh),
                'access': str(refresh.access_token),
                'user': UserSerializer(user).data
            })
        else:
            return Response(
                {'error': '用户名或密码错误'},
                status=status.HTTP_401_UNAUTHORIZED
            )

    @extend_schema(
        summary="获取当前用户信息",
        tags=['用户管理']
    )
    @action(detail=False, methods=['get'])
    def me(self, request):
        serializer = UserSerializer(request.user, context={'request': request})
        return Response(serializer.data)

    @extend_schema(
        summary="请求密码重置",
        tags=['用户认证'],
        request=PasswordResetRequestSerializer,
        responses={200: OpenApiResponse(description="重置邮件已发送")}
    )
    @method_decorator(csrf_exempt)
    @action(detail=False, methods=['post'], permission_classes=[permissions.AllowAny])
    def request_password_reset(self, request):
        serializer = PasswordResetRequestSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        email = serializer.validated_data['email']
        
        try:
            user = User.objects.get(email=email)
            # 生成验证码
            code = ''.join(random.choices(string.digits, k=6))
            expiry = timezone.now() + timezone.timedelta(minutes=30)
            
            VerificationCode.objects.create(
                user=user,
                code=code,
                purpose='password_reset',
                expires_at=expiry
            )
            
            # 发送重置邮件
            send_mail(
                '密码重置',
                f'您的密码重置验证码是：{code}，30分钟内有效。',
                settings.EMAIL_HOST_USER,  # 使用配置的邮箱地址
                [email],
                fail_silently=False,
            )
            
            return Response({'message': '重置邮件已发送'})
        except User.DoesNotExist:
            # 为了安全，即使用户不存在也返回相同消息
            return Response({'message': '重置邮件已发送'})

    @extend_schema(
        summary="确认密码重置",
        tags=['用户认证'],
        request=PasswordResetConfirmSerializer,
        responses={200: OpenApiResponse(description="密码已重置")}
    )
    @method_decorator(csrf_exempt)
    @action(detail=False, methods=['post'], permission_classes=[permissions.AllowAny])
    def confirm_password_reset(self, request):
        serializer = PasswordResetConfirmSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        
        try:
            # 打印调试信息
            print(f"Attempting to verify code: {serializer.validated_data['token']}")
            
            # 获取所有未使用的验证码
            verifications = VerificationCode.objects.filter(
                purpose='password_reset',
                is_used=False,
                expires_at__gt=timezone.now()
            )
            
            verification = None
            # 遍历验证码进行比较
            for v in verifications:
                if v.code == serializer.validated_data['token']:
                    verification = v
                    break
            
            if not verification:
                return Response(
                    {'error': '无效或过期的验证码'},
                    status=status.HTTP_400_BAD_REQUEST
                )
            
            user = verification.user
            user.set_password(serializer.validated_data['new_password'])
            user.save()
            
            # 标记验证码为已使用
            verification.is_used = True
            verification.save()
            
            return Response({'message': '密码已重置'})
        except Exception as e:
            return Response(
                {'error': '验证码验证失败'},
                status=status.HTTP_400_BAD_REQUEST
            )

    @action(detail=False, methods=['POST'], parser_classes=[MultiPartParser])
    def upload_avatar(self, request):
        """
        上传用户头像
        """
        try:
            avatar_file = request.FILES.get('avatar')
            if not avatar_file:
                return Response({'error': '没有提供头像文件'}, status=status.HTTP_400_BAD_REQUEST)

            # 删除旧头像文件
            if request.user.avatar:
                request.user.avatar.delete(save=False)  # 删除文件但不保存模型

            # 生成文件名
            file_extension = os.path.splitext(avatar_file.name)[1]
            new_filename = f"{request.user.username}_{uuid.uuid4().hex[:8]}{file_extension}"
            
            # 直接使用 ImageField 保存文件
            request.user.avatar.save(
                new_filename,
                avatar_file,
                save=True  # 自动保存模型
            )

            # 构建完整的URL
            avatar_url = request.build_absolute_uri(request.user.avatar.url)

            return Response({
                'message': '头像上传成功',
                'avatar_url': avatar_url
            })

        except Exception as e:
            return Response(
                {'error': f'头像上传失败: {str(e)}'}, 
                status=status.HTTP_500_INTERNAL_SERVER_ERROR
            )

    @extend_schema(
        summary="获取用户任务统计",
        tags=['任务管理']
    )
    @action(detail=False, methods=['get'])
    def task_stats(self, request):
        """获取任务统计信息"""
        user = request.user
        
        # 获取所有任务总数
        total_tasks = Task.objects.filter(user=user).count()
        
        # 获取已完成任务数
        completed_tasks = Task.objects.filter(
            user=user,
            status='completed'
        ).count()
        
        # 获取待办任务数
        pending_tasks = Task.objects.filter(
            user=user,
            status='pending'
        ).count()
        
        # 获取已逾期任务数
        overdue_tasks = Task.objects.filter(
            user=user,
            status='pending',
            due_date__lt=timezone.now()
        ).count()
        
        return Response({
            'total': total_tasks,
            'completed': completed_tasks,
            'pending': pending_tasks,
            'overdue': overdue_tasks
        })

@extend_schema_view(
    list=extend_schema(
        summary="获取用户配置列表",
        tags=['用户配置']
    ),
    create=extend_schema(
        summary="创建用户配置",
        tags=['用户配置']
    ),
    retrieve=extend_schema(
        summary="获取用户配置详情",
        tags=['用户配置']
    ),
    update=extend_schema(
        summary="更新用户配置",
        tags=['用户配置']
    ),
    partial_update=extend_schema(
        summary="部分更新用户配置",
        tags=['用户配置']
    ),
    destroy=extend_schema(
        summary="删除用户配置",
        tags=['用户配置']
    )
)
class UserProfileViewSet(viewsets.ModelViewSet):
    queryset = UserProfile.objects.all()
    serializer_class = UserProfileSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        return self.queryset.filter(user=self.request.user)

    def perform_create(self, serializer):
        serializer.save(user=self.request.user)

@extend_schema_view(
    list=extend_schema(
        summary="获取设备列表",
        tags=['用户设备']
    ),
    create=extend_schema(
        summary="创建设备",
        tags=['用户设备']
    ),
    retrieve=extend_schema(
        summary="获取设备详情",
        tags=['用户设备']
    ),
    update=extend_schema(
        summary="更新设备",
        tags=['用户设备']
    ),
    partial_update=extend_schema(
        summary="部分更新设备",
        tags=['用户设备']
    ),
    destroy=extend_schema(
        summary="删除设备",
        tags=['用户设备']
    )
)
class UserDeviceViewSet(viewsets.ModelViewSet):
    queryset = UserDevice.objects.all()
    serializer_class = UserDeviceSerializer
    permission_classes = [permissions.IsAuthenticated]
    tags = ['用户管理']

    def get_queryset(self):
        return self.queryset.filter(user=self.request.user)

    def perform_create(self, serializer):
        serializer.save(user=self.request.user)

    @extend_schema(
        summary="同步设备数据",
        tags=['用户设备']
    )
    @action(detail=True, methods=['post'])
    def sync(self, request, pk=None):
        """
        同步设备数据
        """
        device = self.get_object()
        
        # 获取最后同步时间之后的更新
        last_sync = device.last_sync_time or device.created_at
        updates = {
            'tasks': Task.objects.filter(
                user=request.user,
                updated_at__gt=last_sync
            ),
            'notifications': Notification.objects.filter(
                user=request.user,
                created_at__gt=last_sync
            )
        }
        
        # 更新设备的最后同步时间
        device.last_sync_time = timezone.now()
        device.save()
        
        return Response({
            'message': '同步成功',
            'updates': {
                'tasks_count': updates['tasks'].count(),
                'notifications_count': updates['notifications'].count()
            }
        })

    @extend_schema(
        summary="停用设备",
        tags=['用户设备']
    )
    @action(detail=True, methods=['post'])
    def deactivate(self, request, pk=None):
        """
        停用设备
        """
        device = self.get_object()
        device.is_active = False
        device.save()
        return Response({'message': '设备已停用'})

@extend_schema_view(
    list=extend_schema(
        summary="获取反馈列表",
        tags=['用户反馈']
    ),
    create=extend_schema(
        summary="创建反馈",
        tags=['用户反馈']
    ),
    retrieve=extend_schema(
        summary="获取反馈详情",
        tags=['用户反馈']
    ),
    update=extend_schema(
        summary="更新反馈",
        tags=['用户反馈']
    ),
    partial_update=extend_schema(
        summary="部分更新反馈",
        tags=['用户反馈']
    ),
    destroy=extend_schema(
        summary="删除反馈",
        tags=['用户反馈']
    )
)
class UserFeedbackViewSet(viewsets.ModelViewSet):
    """用户反馈视图集"""
    serializer_class = UserFeedbackSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        """获取当前用户的反馈列表"""
        return UserFeedback.objects.filter(user=self.request.user).order_by('-created_at')

    def perform_create(self, serializer):
        """创建反馈时自动关联当前用户"""
        serializer.save(user=self.request.user)

    @extend_schema(
        request={"type": "object", "properties": {"status": {"type": "string", "enum": ["pending", "resolved", "closed"]}}},
        responses={200: {"type": "object", "properties": {"message": {"type": "string"}}}},
        summary="更新反馈状态",
        tags=['用户反馈']
    )
    @action(detail=True, methods=['POST'])
    def update_status(self, request, pk=None):
        """更新反馈状态"""
        feedback = self.get_object()
        status = request.data.get('status')

        if not status or status not in ['pending', 'resolved', 'closed']:
            return Response(
                {'error': '无效的状态值'},
                status=status.HTTP_400_BAD_REQUEST
            )

        feedback.status = status
        feedback.save()

        return Response({'message': '状态已更新'})

    @extend_schema(
        summary="添加回复",
        tags=['用户反馈'],
        request={"type": "object", "properties": {"response": {"type": "string"}}},
        responses={200: UserFeedbackSerializer}
    )
    @action(detail=True, methods=['post'])
    def add_response(self, request, pk=None):
        """添加回复"""
        feedback = self.get_object()
        response = request.data.get('response')

        if not response:
            return Response(
                {'error': '回复内容不能为空'},
                status=status.HTTP_400_BAD_REQUEST
            )

        feedback.response = response
        feedback.status = 'resolved'  # 添加回复时自动将状态设为已解决
        feedback.save()

        serializer = self.get_serializer(feedback)
        return Response(serializer.data)
