# ログインアプリ

名前・メールアドレス・パスワードで新規登録し、承認後にログインできるFlutter + Djangoアプリケーションです。

## プロジェクト構成

```
ログインアプリ/
├── login_app/          # Flutterアプリ（フロントエンド）
├── backend/            # Djangoバックエンド
├── accounts/           # Django認証アプリ
├── venv/               # Python仮想環境
├── requirements.txt    # Python依存パッケージ
└── 実装計画.md         # 実装計画書
```

## セットアップ手順

### 1. Flutterアプリのセットアップ

```bash
cd login_app
flutter pub get
```

### 2. Djangoバックエンドのセットアップ

```bash
# 仮想環境のアクティベート
source venv/bin/activate

# データベースのマイグレーション
python manage.py migrate

# スーパーユーザーの作成
python manage.py createsuperuser
```

### 3. サーバーの起動

#### Djangoサーバー
```bash
source venv/bin/activate
python manage.py runserver
```
サーバーは `http://localhost:8000` で起動します。

#### Flutterアプリ
```bash
cd login_app
flutter run
```

## 使用方法

### 1. 新規登録
1. Flutterアプリを起動
2. 「新規登録はこちら」をタップ
3. 名前、メールアドレス、パスワードを入力
4. 「登録申請」をタップ
5. 「登録申請を受け付けました」というメッセージが表示されます

### 2. ユーザーの承認
1. Django Admin (`http://localhost:8000/admin`) にアクセス
2. スーパーユーザーでログイン
3. 「ユーザー」セクションを開く
4. 承認待ちのユーザーを選択
5. アクションで「選択したユーザーを承認する」を選択して実行
6. 承認されると、ユーザーにメール通知が送信されます（開発環境ではコンソールに出力）

### 3. ログイン
1. Flutterアプリでメールアドレスとパスワードを入力
2. 「ログイン」をタップ
3. 承認済みのユーザーのみログインできます
4. ログイン成功後、ホーム画面に登録した名前が表示されます

## APIエンドポイント

詳細は `backend/README.md` を参照してください。

- `POST /api/accounts/register/` - 新規登録
- `POST /api/accounts/login/` - ログイン
- `GET /api/accounts/user/` - ユーザー情報取得
- `POST /api/accounts/token/refresh/` - トークンリフレッシュ

## 技術スタック

### フロントエンド
- Flutter 3.24.5
- Provider (状態管理)
- http (HTTP通信)
- flutter_secure_storage (トークン保存)

### バックエンド
- Django 4.2.7
- Django REST Framework 3.14.0
- djangorestframework-simplejwt 5.3.0 (JWT認証)
- django-cors-headers 4.3.1 (CORS設定)

## 開発メモ

### APIエンドポイントの設定
Flutterアプリの `lib/utils/constants.dart` で、Django APIのベースURLを設定してください：

```dart
static const String baseUrl = 'http://localhost:8000/api';
```

### CORS設定
Djangoの `backend/settings.py` で、Flutterアプリからのアクセスを許可する必要があります。

### メール設定
開発環境では、メールはコンソールに出力されます。
本番環境では、`backend/settings.py` でSMTP設定を行ってください。

## 次のステップ

1. 本番環境用の設定（SECRET_KEY、DEBUG=False等）
2. データベースをPostgreSQLに変更（本番環境）
3. メール送信の設定（SMTP）
4. デプロイ準備

## ライセンス

このプロジェクトは個人利用・学習目的で作成されています。

