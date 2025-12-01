#!/usr/bin/env python
"""
Railway用のスーパーユーザー作成スクリプト
"""
import os
import django

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'backend.settings')
django.setup()

from accounts.models import User

# スーパーユーザーの情報
EMAIL = os.environ.get('ADMIN_EMAIL', 'admin@example.com')
PASSWORD = os.environ.get('ADMIN_PASSWORD', 'admin123456')
FIRST_NAME = os.environ.get('ADMIN_FIRST_NAME', 'Admin')
LAST_NAME = os.environ.get('ADMIN_LAST_NAME', 'User')

# 既存のスーパーユーザーをチェック
if User.objects.filter(email=EMAIL, is_superuser=True).exists():
    print(f"スーパーユーザー {EMAIL} は既に存在します。")
else:
    # スーパーユーザーを作成
    User.objects.create_superuser(
        email=EMAIL,
        password=PASSWORD,
        first_name=FIRST_NAME,
        last_name=LAST_NAME,
    )
    print(f"スーパーユーザー {EMAIL} を作成しました。")
    print(f"パスワード: {PASSWORD}")

