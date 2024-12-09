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

User = get_user_model()

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
    @action(detail=False, methods=['post'], permission_classes=[permissions.AllowAny])
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
    @action(detail=False, methods=['post'], permission_classes=[permissions.AllowAny])
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
        serializer = UserSerializer(request.user)
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

@extend_schema_view(
    list=extend_schema(tags=['用户配置']),
    create=extend_schema(tags=['用户配置']),
    retrieve=extend_schema(tags=['用户配置']),
    update=extend_schema(tags=['用户配置']),
    partial_update=extend_schema(tags=['用户配置']),
    destroy=extend_schema(tags=['用户配置']),
)
class UserProfileViewSet(viewsets.ModelViewSet):
    queryset = UserProfile.objects.all()
    serializer_class = UserProfileSerializer
    permission_classes = [permissions.IsAuthenticated]
    tags = ['用户管理']

    def get_queryset(self):
        return self.queryset.filter(user=self.request.user)

    def perform_create(self, serializer):
        serializer.save(user=self.request.user)

@extend_schema_view(
    list=extend_schema(tags=['用户设备']),
    create=extend_schema(tags=['用户设备']),
    retrieve=extend_schema(tags=['用户设备']),
    update=extend_schema(tags=['用户设备']),
    partial_update=extend_schema(tags=['用户设备']),
    destroy=extend_schema(tags=['用户设备']),
)
class UserDeviceViewSet(viewsets.ModelViewSet):
    queryset = UserDevice.objects.all()
    serializer_class = UserDeviceSerializer
    permission_classes = [permissions.IsAuthenticated]
    
    def get_queryset(self):
        return self.queryset.filter(user=self.request.user)
    
    def perform_create(self, serializer):
        # 检查是否已存在相同设备
        device_id = serializer.validated_data.get('device_id')
        existing_device = UserDevice.objects.filter(
            user=self.request.user,
            device_id=device_id
        ).first()
        
        if existing_device:
            # 更新现有设备
            existing_device.device_name = serializer.validated_data.get('device_name')
            existing_device.device_type = serializer.validated_data.get('device_type')
            existing_device.last_sync_time = timezone.now()
            existing_device.is_active = True
            existing_device.save()
        else:
            # 创建新设备
            serializer.save(
                user=self.request.user,
                last_sync_time=timezone.now()
            )
    
    @action(detail=True, methods=['post'])
    def sync(self, request, pk=None):
        """
        同步设备数据
        """
        device = self.get_object()
        device.last_sync_time = timezone.now()
        device.save()
        
        # 获取上次同步后的数据
        last_sync = device.last_sync_time
        updates = {
            'tasks': Task.objects.filter(user=request.user, updated_at__gt=last_sync),
            'notifications': Notification.objects.filter(user=request.user, created_at__gt=last_sync)
        }
        
        return Response({
            'message': '同步成功',
            'last_sync_time': device.last_sync_time,
            'updates': {
                'tasks_count': updates['tasks'].count(),
                'notifications_count': updates['notifications'].count()
            }
        })
    
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
        summary="获取用户反馈列表",
        tags=['用户反馈']
    ),
    create=extend_schema(
        summary="创建用户反馈",
        tags=['用户反馈']
    ),
    retrieve=extend_schema(
        summary="获取用户反馈详情",
        tags=['用户反馈']
    )
)
class UserFeedbackViewSet(viewsets.ModelViewSet):
    serializer_class = UserFeedbackSerializer
    permission_classes = [permissions.IsAuthenticated]
    
    def get_queryset(self):
        return UserFeedback.objects.filter(user=self.request.user)
    
    def perform_create(self, serializer):
        serializer.save(user=self.request.user)
