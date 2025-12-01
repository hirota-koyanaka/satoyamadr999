# Django バックエンド API

ログインアプリのDjango REST APIバックエンドです。

## セットアップ

### 1. 仮想環境のアクティベート

```bash
source venv/bin/activate
```

### 2. データベースのマイグレーション

```bash
python manage.py migrate
```

### 3. スーパーユーザーの作成

```bash
python manage.py createsuperuser
```

以下の情報を入力してください：
- メールアドレス: admin@example.com（任意）
- 名前（姓）: Admin
- 名前（名）: User
- パスワード: （任意のパスワード）

### 4. サーバーの起動

```bash
python manage.py runserver
```

サーバーは `http://localhost:8000` で起動します。

## APIエンドポイント

### 新規登録
- **POST** `/api/accounts/register/`
- リクエストボディ:
  ```json
  {
    "email": "user@example.com",
    "first_name": "太郎",
    "last_name": "山田",
    "password": "password123",
    "password_confirm": "password123"
  }
  ```

### ログイン
- **POST** `/api/accounts/login/`
- リクエストボディ:
  ```json
  {
    "email": "user@example.com",
    "password": "password123"
  }
  ```
- レスポンス:
  ```json
  {
    "access": "jwt_access_token",
    "refresh": "jwt_refresh_token",
    "user": {
      "id": 1,
      "email": "user@example.com",
      "first_name": "太郎",
      "last_name": "山田",
      "full_name": "山田 太郎",
      "status": "approved"
    }
  }
  ```

### ユーザー情報取得
- **GET** `/api/accounts/user/`
- ヘッダー: `Authorization: Bearer {access_token}`

### トークンリフレッシュ
- **POST** `/api/accounts/token/refresh/`
- リクエストボディ:
  ```json
  {
    "refresh": "jwt_refresh_token"
  }
  ```

## Django Admin

管理画面でユーザーの承認ができます：

1. `http://localhost:8000/admin` にアクセス
2. スーパーユーザーでログイン
3. 「ユーザー」セクションで承認待ちのユーザーを確認
4. ユーザーを選択して「選択したユーザーを承認する」アクションを実行

承認されると、自動的にメール通知が送信されます（開発環境ではコンソールに出力されます）。

## メール設定

開発環境では、メールはコンソールに出力されます。

本番環境では、`backend/settings.py` のメール設定を変更してください：

```python
EMAIL_BACKEND = "django.core.mail.backends.smtp.EmailBackend"
EMAIL_HOST = "smtp.gmail.com"
EMAIL_PORT = 587
EMAIL_USE_TLS = True
EMAIL_HOST_USER = "your-email@gmail.com"
EMAIL_HOST_PASSWORD = "your-app-password"
DEFAULT_FROM_EMAIL = "your-email@gmail.com"
```

## CORS設定

Flutterアプリからのアクセスを許可するため、`backend/settings.py` の `CORS_ALLOWED_ORIGINS` にFlutterアプリのURLを追加してください。

## プロジェクト構造

```
backend/
├── manage.py
├── backend/
│   ├── settings.py      # 設定ファイル
│   ├── urls.py          # URLルーティング
│   └── wsgi.py
└── accounts/
    ├── models.py        # Userモデル
    ├── serializers.py   # DRFシリアライザー
    ├── views.py         # APIビュー
    ├── admin.py         # Admin画面のカスタマイズ
    ├── urls.py          # アプリのURLルーティング
    └── signals.py       # シグナル（現在は未使用）
```

