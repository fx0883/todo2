from rest_framework import serializers
from drf_spectacular.utils import extend_schema_serializer, OpenApiExample
from .models import User, UserProfile, UserDevice, VerificationCode, UserFeedback
from django.conf import settings

@extend_schema_serializer(
    examples=[
        OpenApiExample(
            'User Example',
            value={
                'id': 1,
                'username': 'johndoe',
                'email': 'john@example.com',
                'first_name': 'John',
                'last_name': 'Doe',
                'is_active': True,
                'avatar': 'http://example.com/media/avatars/user.jpg'
            }
        )
    ]
)
class UserSerializer(serializers.ModelSerializer):
    avatar = serializers.SerializerMethodField()

    class Meta:
        model = User
        fields = ('id', 'username', 'email', 'first_name', 'last_name', 'is_active', 'avatar')
        read_only_fields = ('id', 'is_active')

    def get_avatar(self, obj):
        if obj.avatar:
            request = self.context.get('request')
            if request:
                return request.build_absolute_uri(obj.avatar.url)
        return None

@extend_schema_serializer(
    examples=[
        OpenApiExample(
            'UserProfile Example',
            value={
                'id': 1,
                'user': 1,
                'theme': 'light',
                'notification_preferences': {
                    'email': True,
                    'push': True,
                    'sms': False
                },
                'timezone': 'Asia/Shanghai',
                'language': 'zh-hans'
            }
        )
    ]
)
class UserProfileSerializer(serializers.ModelSerializer):
    class Meta:
        model = UserProfile
        fields = ('id', 'user', 'theme', 'notification_preferences', 'timezone', 'language')
        read_only_fields = ('id', 'user')

@extend_schema_serializer(
    examples=[
        OpenApiExample(
            'UserDevice Example',
            value={
                'id': 1,
                'user': 1,
                'device_id': 1,
                'device_name': 'device_name',
                'device_type': 'device_type',
                'last_sync_time': '2024-12-09T12:00:00Z',
                'is_active': True
            }
        )
    ]
)
class UserDeviceSerializer(serializers.ModelSerializer):
    class Meta:
        model = UserDevice
        fields = ('id', 'user', 'device_id', 'device_name', 'device_type', 'last_sync_time', 'is_active')
        read_only_fields = ('id',)

@extend_schema_serializer(
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
class RegisterSerializer(serializers.ModelSerializer):
    password = serializers.CharField(write_only=True)
    confirm_password = serializers.CharField(write_only=True)

    class Meta:
        model = User
        fields = ('username', 'email', 'password', 'confirm_password', 'first_name', 'last_name')

    def validate(self, data):
        if data['password'] != data['confirm_password']:
            raise serializers.ValidationError("Passwords don't match")
        return data

    def create(self, validated_data):
        validated_data.pop('confirm_password')
        user = User.objects.create_user(**validated_data)
        UserProfile.objects.create(user=user)
        return user

@extend_schema_serializer(
    examples=[
        OpenApiExample(
            'Login Example',
            value={
                'username': 'johndoe',
                'password': 'securepassword123'
            }
        )
    ]
)
class LoginSerializer(serializers.Serializer):
    username = serializers.CharField()
    password = serializers.CharField(write_only=True)

    def validate(self, data):
        username = data.get('username')
        password = data.get('password')
        if not username or not password:
            raise serializers.ValidationError('请提供用户名和密码')
        return data

class PasswordResetRequestSerializer(serializers.Serializer):
    """密码重置请求序列化器"""
    email = serializers.EmailField()

class PasswordResetConfirmSerializer(serializers.Serializer):
    """密码重置确认序列化器"""
    token = serializers.CharField()
    new_password = serializers.CharField(write_only=True)
    confirm_password = serializers.CharField(write_only=True)

    def validate(self, data):
        if data['new_password'] != data['confirm_password']:
            raise serializers.ValidationError("密码不匹配")
        return data

class UserFeedbackSerializer(serializers.ModelSerializer):
    """用户反馈序列化器"""
    class Meta:
        model = UserFeedback
        fields = ('id', 'type', 'title', 'content', 'status', 'response', 'created_at', 'updated_at')
        read_only_fields = ('id', 'status', 'response', 'created_at', 'updated_at')
