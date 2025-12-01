# Railwayデプロイ完了報告書

## プロジェクト概要

**プロジェクト名**: ログインアプリ（Django + Flutter）  
**デプロイ日**: 2025年12月2日  
**デプロイ環境**: Railway（本番環境）  
**プロジェクトID**: `5499003b-5b63-4577-9774-b0ef6126c5c6`

## デプロイ環境情報

### Railwayプロジェクト
- **プロジェクト名**: `login-app-backend`
- **プロジェクトURL**: https://railway.com/project/5499003b-5b63-4577-9774-b0ef6126c5c6
- **環境**: `production`
- **サービス名**: `backend`

### デプロイURL
- **ベースURL**: `https://backend-production-876f.up.railway.app`
- **Django Admin**: `https://backend-production-876f.up.railway.app/admin/`
- **API ベースURL**: `https://backend-production-876f.up.railway.app/api/`
- **ヘルスチェック**: `https://backend-production-876f.up.railway.app/health/`

## 実施した作業の詳細

### 1. Railwayプロジェクトの初期化

**実施日時**: 2025年12月2日

**作業内容**:
- Railway CLIを使用してプロジェクトを初期化
- プロジェクト名: `login-app-backend`
- ワークスペース: `hirota-koyanaka's Projects`

**コマンド**:
```bash
railway init --name login-app-backend
```

**結果**: プロジェクトが正常に作成されました。

---

### 2. PostgreSQLデータベースの追加

**作業内容**:
- RailwayのPostgreSQLサービスを追加
- `DATABASE_URL`環境変数が自動的に設定されました

**コマンド**:
```bash
railway add --database postgres
```

**結果**: PostgreSQLデータベースが正常に追加されました。

---

### 3. バックエンドサービスの追加

**作業内容**:
- Djangoアプリケーション用のサービスを追加
- サービス名: `backend`

**コマンド**:
```bash
railway add --service backend
```

**結果**: バックエンドサービスが正常に追加されました。

---

### 4. 環境変数の設定

**設定した環境変数**:

| 変数名 | 値 | 説明 |
|--------|-----|------|
| `SECRET_KEY` | `7dbb5e406a0edf714fe93d858adeb15768afe8826c173b55d407ae574a93a345` | Djangoのシークレットキー（ランダム生成） |
| `DEBUG` | `True` | デバッグモード（本番環境では`False`推奨） |
| `ALLOWED_HOSTS` | `*` | 許可するホスト（すべて許可） |
| `CSRF_TRUSTED_ORIGINS` | `https://backend-production-876f.up.railway.app` | CSRF検証用の信頼できるオリジン |
| `ADMIN_EMAIL` | `admin@example.com` | スーパーユーザーのメールアドレス |
| `ADMIN_PASSWORD` | `admin123456` | スーパーユーザーのパスワード |
| `ADMIN_FIRST_NAME` | `Admin` | スーパーユーザーの名 |
| `ADMIN_LAST_NAME` | `User` | スーパーユーザーの姓 |

**コマンド**:
```bash
railway variables --set "SECRET_KEY=..." --set "DEBUG=True" --set "ALLOWED_HOSTS=*" --set "CSRF_TRUSTED_ORIGINS=https://backend-production-876f.up.railway.app"
railway variables --set "ADMIN_EMAIL=admin@example.com" --set "ADMIN_PASSWORD=admin123456" --set "ADMIN_FIRST_NAME=Admin" --set "ADMIN_LAST_NAME=User"
```

**結果**: すべての環境変数が正常に設定されました。

---

### 5. 静的ファイルの設定

**作業内容**:
- WhiteNoiseミドルウェアを追加
- `STATIC_ROOT`と`STATICFILES_STORAGE`を設定
- `collectstatic`コマンドをデプロイ時に実行

**変更ファイル**:
- `backend/settings.py`

**変更内容**:
```python
# MIDDLEWAREに追加
"whitenoise.middleware.WhiteNoiseMiddleware",

# 静的ファイル設定
STATIC_ROOT = BASE_DIR / "staticfiles"
STATICFILES_STORAGE = "whitenoise.storage.CompressedManifestStaticFilesStorage"
```

**railway.json**:
```json
{
  "deploy": {
    "startCommand": "python manage.py collectstatic --noinput && python manage.py migrate && python create_superuser.py && gunicorn backend.wsgi:application --bind 0.0.0.0:$PORT --workers 2 --timeout 120 --access-logfile - --error-logfile - --log-level info"
  }
}
```

**結果**: 160個の静的ファイルが収集され、462個が後処理されました。

---

### 6. CSRF設定の修正

**問題**: Django Adminにログインしようとすると「Origin checking failed」というCSRFエラーが発生

**原因**:
- `decouple`の`config()`関数が環境変数`CSRF_TRUSTED_ORIGINS`を正しく読み込めていない可能性
- 環境変数の読み込み方法が統一されていない

**解決方法**:
- `os.environ.get()`を直接使用して環境変数を読み込むように変更
- `RAILWAY_PUBLIC_DOMAIN`から動的にドメインを追加
- 環境変数`CSRF_TRUSTED_ORIGINS`も直接`os.environ.get()`で読み込む

**変更ファイル**:
- `backend/settings.py`（42-59行目）

**変更内容**:
```python
# CSRF設定（HTTPSを使用する場合に必要）
CSRF_TRUSTED_ORIGINS = []

# Railwayのドメインを確実に追加
if railway_domain:
    CSRF_TRUSTED_ORIGINS.append(f"https://{railway_domain}")

# 環境変数から直接読み込む（decoupleのconfig()に依存しない）
csrf_origins_env = os.environ.get("CSRF_TRUSTED_ORIGINS", "")
if csrf_origins_env:
    origins_list = [origin.strip() for origin in csrf_origins_env.split(",") if origin.strip()]
    CSRF_TRUSTED_ORIGINS.extend(origins_list)

# 重複を削除
CSRF_TRUSTED_ORIGINS = list(set(CSRF_TRUSTED_ORIGINS))
```

**結果**: CSRF設定が正しく動作し、Django Adminに正常にログインできるようになりました。

---

### 7. スーパーユーザーの作成

**作業内容**:
- デプロイ時に自動的にスーパーユーザーを作成するスクリプトを追加
- `create_superuser.py`スクリプトを作成

**作成ファイル**:
- `create_superuser.py`

**スクリプトの動作**:
- 環境変数からスーパーユーザーの情報を取得
- 既存のスーパーユーザーをチェック
- 存在しない場合のみ作成

**結果**: スーパーユーザーが正常に作成されました。
- メールアドレス: `admin@example.com`
- パスワード: `admin123456`

---

### 8. ヘルスチェックエンドポイントの追加

**作業内容**:
- Railway用のヘルスチェックエンドポイントを追加
- `/health/`と`/`にヘルスチェックエンドポイントを設定

**変更ファイル**:
- `backend/urls.py`

**結果**: ヘルスチェックエンドポイントが正常に動作しています。

---

### 9. デバッグエンドポイントの追加

**作業内容**:
- デバッグ用の設定確認エンドポイントを追加
- `/debug/settings/`で設定値を確認可能

**変更ファイル**:
- `backend/urls.py`

**用途**: CSRF設定などの設定値を確認するために使用

---

## 発生した問題と解決方法

### 問題1: プロジェクトURLが404エラーになる

**症状**: 最初に作成したプロジェクトのURLにアクセスすると404エラーが発生

**原因**: プロジェクトIDが正しくリンクされていない可能性

**解決方法**: 新しいプロジェクトを作成し直しました

**結果**: 新しいプロジェクトID `5499003b-5b63-4577-9774-b0ef6126c5c6` で正常にアクセスできるようになりました

---

### 問題2: コンテナが起動後すぐに停止する

**症状**: Gunicornは正常に起動するが、約2分後にコンテナが停止

**原因**: 
- Procfileとrailway.jsonの競合の可能性
- Railwayのヘルスチェックが失敗している可能性

**解決方法**:
1. Procfileを削除してrailway.jsonのみを使用
2. ヘルスチェックエンドポイントを追加
3. Gunicornの設定を改善（ワーカー数、タイムアウト設定）

**結果**: コンテナが継続的に実行されるようになりました

---

### 問題3: ALLOWED_HOSTSエラー

**症状**: `DisallowedHost`エラーが発生

**原因**: `*.railway.app`というワイルドカード形式がDjangoでサポートされていない

**解決方法**:
- `ALLOWED_HOSTS`を`*`に設定
- `RAILWAY_PUBLIC_DOMAIN`から動的にドメインを追加

**結果**: エラーが解消されました

---

### 問題4: 静的ファイルが読み込まれない

**症状**: Django Adminページのスタイルが適用されない

**原因**: WhiteNoiseの設定が不完全

**解決方法**:
- WhiteNoiseミドルウェアを追加
- `STATIC_ROOT`と`STATICFILES_STORAGE`を設定
- `collectstatic`コマンドをデプロイ時に実行

**結果**: 静的ファイルが正常に配信されるようになりました

---

### 問題5: CSRF検証エラー

**症状**: Django Adminにログインしようとすると「Origin checking failed」エラーが発生

**原因**: `decouple`の`config()`関数が環境変数を正しく読み込めていない

**解決方法**:
- `os.environ.get()`を直接使用して環境変数を読み込む
- `RAILWAY_PUBLIC_DOMAIN`から動的にドメインを追加
- 環境変数`CSRF_TRUSTED_ORIGINS`も直接読み込む

**結果**: CSRF設定が正しく動作し、ログインできるようになりました

---

## 最終的な設定内容

### ファイル構成

**主要ファイル**:
- `railway.json`: Railwayのデプロイ設定
- `backend/settings.py`: Django設定ファイル
- `backend/urls.py`: URL設定（ヘルスチェック、デバッグエンドポイント追加）
- `create_superuser.py`: スーパーユーザー自動作成スクリプト
- `requirements.txt`: Python依存パッケージ

**削除したファイル**:
- `Procfile`: railway.jsonと競合するため削除

### Django設定の主要項目

**ALLOWED_HOSTS**:
```python
ALLOWED_HOSTS = ["*", "backend-production-876f.up.railway.app"]
```

**CSRF_TRUSTED_ORIGINS**:
```python
CSRF_TRUSTED_ORIGINS = ["https://backend-production-876f.up.railway.app"]
```

**静的ファイル設定**:
```python
STATIC_ROOT = BASE_DIR / "staticfiles"
STATICFILES_STORAGE = "whitenoise.storage.CompressedManifestStaticFilesStorage"
```

**ミドルウェア**:
```python
MIDDLEWARE = [
    "django.middleware.security.SecurityMiddleware",
    "whitenoise.middleware.WhiteNoiseMiddleware",  # 静的ファイル用
    "django.contrib.sessions.middleware.SessionMiddleware",
    "corsheaders.middleware.CorsMiddleware",
    "django.middleware.common.CommonMiddleware",
    "django.middleware.csrf.CsrfViewMiddleware",
    "django.contrib.auth.middleware.AuthenticationMiddleware",
    "django.contrib.messages.middleware.MessageMiddleware",
    "django.middleware.clickjacking.XFrameOptionsMiddleware",
]
```

### Railway設定

**railway.json**:
```json
{
  "$schema": "https://railway.app/railway.schema.json",
  "build": {
    "builder": "NIXPACKS",
    "buildCommand": "pip install -r requirements.txt"
  },
  "deploy": {
    "startCommand": "python manage.py collectstatic --noinput && python manage.py migrate && python create_superuser.py && gunicorn backend.wsgi:application --bind 0.0.0.0:$PORT --workers 2 --timeout 120 --access-logfile - --error-logfile - --log-level info",
    "restartPolicyType": "ON_FAILURE",
    "restartPolicyMaxRetries": 10
  }
}
```

---

## デプロイ後の確認事項

### ✅ 確認済み項目

1. **デプロイの成功**: Gunicornが正常に起動し、継続的に実行されている
2. **マイグレーション**: すべてのマイグレーションが正常に適用された
3. **静的ファイル**: 160個の静的ファイルが収集され、正常に配信されている
4. **スーパーユーザー**: 正常に作成された
5. **CSRF設定**: 正しく設定され、Django Adminにログインできる
6. **API動作**: 登録APIが正常に動作している
7. **ヘルスチェック**: `/health/`エンドポイントが正常に動作している

### 動作確認済みエンドポイント

| エンドポイント | メソッド | ステータス | 説明 |
|---------------|---------|-----------|------|
| `/health/` | GET | ✅ 200 | ヘルスチェック |
| `/` | GET | ✅ 200 | ルート（ヘルスチェック） |
| `/admin/` | GET | ✅ 200 | Django Admin |
| `/admin/login/` | GET | ✅ 200 | ログイン画面 |
| `/api/accounts/register/` | POST | ✅ 201 | ユーザー登録API |
| `/debug/settings/` | GET | ✅ 200 | デバッグ用設定確認 |

---

## Flutterアプリの設定

### API URLの更新

**ファイル**: `login_app/lib/utils/constants.dart`

**変更内容**:
```dart
class ApiConstants {
  // RailwayデプロイURL
  static const String baseUrl = 'https://backend-production-876f.up.railway.app/api';
  
  static const String registerEndpoint = '/accounts/register/';
  static const String loginEndpoint = '/accounts/login/';
  static const String userEndpoint = '/accounts/user/';
  static const String refreshTokenEndpoint = '/accounts/token/refresh/';
}
```

**結果**: FlutterアプリのAPI URLがRailwayのデプロイURLに更新されました

---

## アクセス情報

### Django Admin

**URL**: https://backend-production-876f.up.railway.app/admin/

**ログイン情報**:
- **メールアドレス**: `admin@example.com`
- **パスワード**: `admin123456`

### API エンドポイント

**ベースURL**: `https://backend-production-876f.up.railway.app/api`

**利用可能なエンドポイント**:
- `POST /api/accounts/register/` - ユーザー登録
- `POST /api/accounts/login/` - ログイン
- `GET /api/accounts/user/` - ユーザー情報取得（認証必要）
- `POST /api/accounts/token/refresh/` - トークンリフレッシュ

### Railwayダッシュボード

**プロジェクトURL**: https://railway.com/project/5499003b-5b63-4577-9774-b0ef6126c5c6

**確認できる情報**:
- デプロイ履歴
- ログ
- 環境変数
- メトリクス
- 設定

---

## 技術スタック

### バックエンド
- **フレームワーク**: Django 4.2.7
- **API**: Django REST Framework 3.14.0
- **認証**: djangorestframework-simplejwt 5.3.0
- **CORS**: django-cors-headers 4.3.1
- **静的ファイル**: whitenoise 6.6.0
- **データベース**: PostgreSQL（Railway提供）
- **WSGIサーバー**: Gunicorn 21.2.0

### デプロイ環境
- **プラットフォーム**: Railway
- **ビルダー**: NIXPACKS
- **Pythonバージョン**: 3.11.10（runtime.txtで指定）

---

## 次のステップ（推奨）

### 1. 本番環境のセキュリティ設定

**推奨事項**:
- `DEBUG`を`False`に設定
- `SECRET_KEY`をより強力なものに変更（既に設定済み）
- `ALLOWED_HOSTS`を具体的なドメインに制限（現在は`*`）

**コマンド**:
```bash
railway variables --set "DEBUG=False"
```

### 2. メール設定（オプション）

**用途**: ユーザー承認通知メールの送信

**設定方法**:
- Railwayダッシュボードの「Variables」タブで以下を設定：
  - `EMAIL_HOST`
  - `EMAIL_PORT`
  - `EMAIL_HOST_USER`
  - `EMAIL_HOST_PASSWORD`
  - `EMAIL_USE_TLS`

### 3. カスタムドメインの設定（オプション）

**用途**: Railwayのデフォルトドメインではなく、独自ドメインを使用

**設定方法**:
- Railwayダッシュボードの「Settings」→「Domains」から設定

### 4. モニタリングとログ

**推奨事項**:
- Railwayダッシュボードでログを定期的に確認
- エラーが発生した場合はログを確認して対応

### 5. バックアップ

**推奨事項**:
- データベースのバックアップを定期的に取得
- RailwayのPostgreSQLサービスでバックアップ設定を確認

---

## トラブルシューティング

### よくある問題と解決方法

#### 1. デプロイが失敗する場合

**確認事項**:
- Railwayダッシュボードの「View Logs」でエラーログを確認
- 環境変数が正しく設定されているか確認
- `requirements.txt`に必要なパッケージが含まれているか確認

**コマンド**:
```bash
railway logs --tail 100
railway variables
```

#### 2. APIが動作しない場合

**確認事項**:
- デプロイが完了しているか確認
- ヘルスチェックエンドポイント（`/health/`）にアクセスして確認
- CORS設定を確認

#### 3. データベース接続エラー

**確認事項**:
- `DATABASE_URL`環境変数が設定されているか確認
- PostgreSQLサービスが起動しているか確認

**コマンド**:
```bash
railway variables | grep DATABASE_URL
```

#### 4. 静的ファイルが読み込まれない場合

**確認事項**:
- `collectstatic`が実行されているかログで確認
- WhiteNoiseの設定が正しいか確認

---

## 参考資料

### Railway関連ドキュメント
- Railwayダッシュボード: https://railway.com/project/5499003b-5b63-4577-9774-b0ef6126c5c6
- Railway CLIドキュメント: https://docs.railway.app/develop/cli

### プロジェクト内ドキュメント
- `RAILWAY_DEPLOY.md`: Railway CLIデプロイ手順
- `RAILWAY_CLI_COMMANDS.md`: Railway CLIコマンド一覧
- `RAILWAY_LOGIN_GUIDE.md`: Railway CLIログインガイド

---

## まとめ

Railwayへのデプロイが正常に完了し、Django Adminにアクセスできることを確認しました。以下の項目が正常に動作しています：

✅ DjangoバックエンドAPI  
✅ Django Admin管理画面  
✅ PostgreSQLデータベース  
✅ 静的ファイルの配信  
✅ CSRF保護  
✅ スーパーユーザーアカウント  

FlutterアプリのAPI URLも更新済みのため、アプリからRailwayにデプロイされたバックエンドに接続できます。

---

**報告書作成日**: 2025年12月2日  
**作成者**: AI Assistant  
**プロジェクト**: ログインアプリ（Django + Flutter）

