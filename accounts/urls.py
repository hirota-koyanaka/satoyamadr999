from django.urls import path
from rest_framework_simplejwt.views import TokenRefreshView
from .views import RegisterView, login_view, UserView

app_name = "accounts"

urlpatterns = [
    path("register/", RegisterView.as_view(), name="register"),
    path("login/", login_view, name="login"),
    path("user/", UserView.as_view(), name="user"),
    path("token/refresh/", TokenRefreshView.as_view(), name="token_refresh"),
]

