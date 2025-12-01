#!/usr/bin/env python
"""
Supabase接続テストスクリプト
.envファイルにDATABASE_URLが設定されている場合、接続をテストします
"""
import os
import sys
from pathlib import Path

# Djangoの設定を読み込む
BASE_DIR = Path(__file__).resolve().parent
sys.path.insert(0, str(BASE_DIR))

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'backend.settings')

import django
django.setup()

from django.db import connection

def test_connection():
    """データベース接続をテスト"""
    try:
        connection.ensure_connection()
        db_info = connection.get_connection_params()
        print("✅ 接続成功！")
        print(f"データベースエンジン: {db_info.get('engine', 'N/A')}")
        print(f"データベース名: {db_info.get('database', 'N/A')}")
        print(f"ホスト: {db_info.get('host', 'N/A')}")
        print(f"ポート: {db_info.get('port', 'N/A')}")
        return True
    except Exception as e:
        print(f"❌ 接続失敗: {e}")
        print("\n接続文字列を確認してください：")
        print("1. Supabaseダッシュボードから接続文字列を取得")
        print("2. .envファイルにDATABASE_URLを設定")
        return False

if __name__ == "__main__":
    test_connection()

