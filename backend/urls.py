"""
URL configuration for backend project.

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/4.2/topics/http/urls/
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
from django.http import JsonResponse
from django.conf import settings

def health_check(request):
    """Railway用のヘルスチェックエンドポイント"""
    return JsonResponse({"status": "ok"})

def debug_settings(request):
    """デバッグ用の設定確認エンドポイント（DEBUG=Trueの場合のみ）"""
    if not settings.DEBUG:
        return JsonResponse({"error": "Debug mode is disabled"}, status=403)
    
    return JsonResponse({
        "ALLOWED_HOSTS": settings.ALLOWED_HOSTS,
        "CSRF_TRUSTED_ORIGINS": getattr(settings, "CSRF_TRUSTED_ORIGINS", []),
        "RAILWAY_PUBLIC_DOMAIN": settings.ALLOWED_HOSTS if hasattr(settings, "RAILWAY_PUBLIC_DOMAIN") else None,
    })

urlpatterns = [
    path("admin/", admin.site.urls),
    path("api/accounts/", include("accounts.urls")),
    path("health/", health_check, name="health_check"),
    path("debug/settings/", debug_settings, name="debug_settings"),
    path("", health_check, name="root_health_check"),
]
