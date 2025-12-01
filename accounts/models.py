from django.contrib.auth.models import AbstractUser, BaseUserManager
from django.db import models
from django.utils import timezone


class UserManager(BaseUserManager):
    """カスタムUserManager - emailをユーザー名として使用"""
    
    def create_user(self, email, password=None, **extra_fields):
        if not email:
            raise ValueError('メールアドレスは必須です')
        email = self.normalize_email(email)
        user = self.model(email=email, **extra_fields)
        user.set_password(password)
        user.save(using=self._db)
        return user
    
    def create_superuser(self, email, password=None, **extra_fields):
        extra_fields.setdefault('is_staff', True)
        extra_fields.setdefault('is_superuser', True)
        extra_fields.setdefault('status', 'approved')
        
        if extra_fields.get('is_staff') is not True:
            raise ValueError('Superuser must have is_staff=True.')
        if extra_fields.get('is_superuser') is not True:
            raise ValueError('Superuser must have is_superuser=True.')
        
        return self.create_user(email, password, **extra_fields)


class User(AbstractUser):
    """カスタムユーザーモデル"""
    
    STATUS_CHOICES = [
        ("pending", "承認待ち"),
        ("approved", "承認済み"),
        ("rejected", "拒否"),
    ]
    
    # emailをユーザー名として使用するため、usernameは使用しない
    # emailフィールドをユニークにする
    email = models.EmailField(
        unique=True,
        verbose_name="メールアドレス",
    )
    
    # usernameフィールドをnull許容にする（使用しないため）
    username = models.CharField(
        max_length=150,
        null=True,
        blank=True,
        verbose_name="ユーザー名",
    )
    
    status = models.CharField(
        max_length=20,
        choices=STATUS_CHOICES,
        default="pending",
        verbose_name="承認状態",
    )
    
    created_at = models.DateTimeField(
        auto_now_add=True,
        verbose_name="作成日時",
    )
    
    approved_at = models.DateTimeField(
        null=True,
        blank=True,
        verbose_name="承認日時",
    )
    
    approved_by = models.ForeignKey(
        "self",
        null=True,
        blank=True,
        on_delete=models.SET_NULL,
        related_name="approved_users",
        verbose_name="承認者",
    )
    
    # emailをユーザー名として使用
    USERNAME_FIELD = "email"
    REQUIRED_FIELDS = ["first_name", "last_name"]
    
    # カスタムUserManagerを使用
    objects = UserManager()
    
    class Meta:
        verbose_name = "ユーザー"
        verbose_name_plural = "ユーザー"
        ordering = ["-created_at"]
    
    def __str__(self):
        return f"{self.get_full_name()} ({self.email})"
    
    def get_full_name(self):
        """フルネームを取得"""
        full_name = f"{self.last_name} {self.first_name}".strip()
        return full_name if full_name else self.email
    
    def approve(self, approver, send_email=True):
        """ユーザーを承認"""
        was_approved = self.status == "approved"
        self.status = "approved"
        self.approved_at = timezone.now()
        self.approved_by = approver
        self.save()
        
        # メール送信（承認されたばかりの場合のみ）
        if send_email and not was_approved:
            from django.core.mail import send_mail
            from django.conf import settings
            
            subject = "アカウント承認のお知らせ"
            message = f"""
{self.get_full_name()}様

アカウントが承認されました。
以下の情報でログインできます。

メールアドレス: {self.email}

ログインしてアプリをご利用ください。

よろしくお願いいたします。
"""
            from_email = getattr(settings, "DEFAULT_FROM_EMAIL", None) or getattr(settings, "EMAIL_HOST_USER", "noreply@example.com")
            
            try:
                send_mail(
                    subject=subject,
                    message=message,
                    from_email=from_email,
                    recipient_list=[self.email],
                    fail_silently=False,
                )
            except Exception as e:
                # メール送信エラーはログに記録
                import logging
                logger = logging.getLogger(__name__)
                logger.error(f"メール送信エラー: {e}")
    
    def reject(self):
        """ユーザーを拒否"""
        self.status = "rejected"
        self.save()
