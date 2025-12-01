from rest_framework import status, generics, permissions
from rest_framework.decorators import api_view, permission_classes
from rest_framework.response import Response
from rest_framework_simplejwt.tokens import RefreshToken
from django.contrib.auth import authenticate
from .models import User
from .serializers import UserSerializer, RegisterSerializer, LoginSerializer


class RegisterView(generics.CreateAPIView):
    """新規登録API"""
    queryset = User.objects.all()
    serializer_class = RegisterSerializer
    permission_classes = [permissions.AllowAny]
    
    def create(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        user = serializer.save()
        
        return Response(
            {
                "success": True,
                "message": "登録申請を受け付けました。承認をお待ちください。",
                "user": UserSerializer(user).data,
            },
            status=status.HTTP_201_CREATED,
        )


@api_view(["POST"])
@permission_classes([permissions.AllowAny])
def login_view(request):
    """ログインAPI"""
    serializer = LoginSerializer(data=request.data)
    
    if not serializer.is_valid():
        return Response(
            serializer.errors,
            status=status.HTTP_400_BAD_REQUEST,
        )
    
    email = serializer.validated_data["email"]
    password = serializer.validated_data["password"]
    
    try:
        user = User.objects.get(email=email)
    except User.DoesNotExist:
        return Response(
            {"detail": "メールアドレスまたはパスワードが正しくありません。"},
            status=status.HTTP_401_UNAUTHORIZED,
        )
    
    # パスワードの確認
    if not user.check_password(password):
        return Response(
            {"detail": "メールアドレスまたはパスワードが正しくありません。"},
            status=status.HTTP_401_UNAUTHORIZED,
        )
    
    # 承認状態のチェック
    if user.status != "approved":
        return Response(
            {"detail": "アカウントがまだ承認されていません。管理者の承認をお待ちください。"},
            status=status.HTTP_403_FORBIDDEN,
        )
    
    # JWTトークンの生成
    refresh = RefreshToken.for_user(user)
    
    return Response(
        {
            "access": str(refresh.access_token),
            "refresh": str(refresh),
            "user": UserSerializer(user).data,
        },
        status=status.HTTP_200_OK,
    )


class UserView(generics.RetrieveAPIView):
    """現在のユーザー情報取得API"""
    serializer_class = UserSerializer
    permission_classes = [permissions.IsAuthenticated]
    
    def get_object(self):
        return self.request.user
