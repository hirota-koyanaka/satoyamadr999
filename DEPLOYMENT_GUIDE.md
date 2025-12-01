# デプロイガイド（ネイティブアプリ版）

## デプロイ構成

このプロジェクトは以下の2つのコンポーネントで構成されています：

1. **Flutterネイティブアプリ**（iOS/Android）
   - App Store / Google Play Storeにデプロイ
   - Vercelは不要

2. **Djangoバックエンド**（REST API + Admin）
   - Railway / Render / Herokuなどにデプロイ

## 1. Flutterネイティブアプリのデプロイ

### iOS（App Store）

1. **Xcodeでプロジェクトを開く**
   ```bash
   cd login_app
   open ios/Runner.xcworkspace
   ```

2. **証明書とプロビジョニングプロファイルの設定**
   - Apple Developerアカウントが必要
   - Xcodeで自動設定可能

3. **ビルドとアップロード**
   - Xcodeで「Product」→「Archive」
   - 「Distribute App」を選択
   - App Store Connectにアップロード

### Android（Google Play Store）

1. **Android Studioでプロジェクトを開く**
   ```bash
   cd login_app
   flutter build appbundle --release
   ```

2. **Google Play Consoleでアップロード**
   - https://play.google.com/console
   - アプリバンドル（.aabファイル）をアップロード

## 2. Djangoバックエンドのデプロイ

### Railway（推奨）

#### 手順

1. **Railwayアカウント作成**
   - https://railway.app
   - GitHubアカウントでログイン

2. **新しいプロジェクトを作成**
   - 「New Project」→「Deploy from GitHub repo」
   - リポジトリ `hirota-koyanaka/satoyamadr999` を選択

3. **サービスを追加**
   - 「New」→「Service」→「GitHub Repo」
   - リポジトリを選択

4. **環境変数の設定**
   ```
   DATABASE_URL=postgresql://postgres:password@host:port/database
   SECRET_KEY=your-secret-key-here
   DEBUG=False
   ALLOWED_HOSTS=your-app.railway.app
   ```

5. **デプロイ設定**
   - Root Directory: `/`（プロジェクトルート）
   - Build Command: `pip install -r requirements.txt && python manage.py migrate`
   - Start Command: `gunicorn backend.wsgi:application --bind 0.0.0.0:$PORT`

6. **PostgreSQLデータベースの追加**
   - 「New」→「Database」→「Add PostgreSQL」
   - 自動的に`DATABASE_URL`環境変数が設定されます

7. **デプロイ**
   - Railwayが自動的にデプロイを開始
   - デプロイURLが生成されます（例: `https://your-app.railway.app`）

### Render（代替案）

1. **Renderアカウント作成**
   - https://render.com

2. **新しいWebサービスを作成**
   - 「New」→「Web Service」
   - GitHubリポジトリを接続

3. **設定**
   - Build Command: `pip install -r requirements.txt && python manage.py migrate`
   - Start Command: `gunicorn backend.wsgi:application`

4. **環境変数の設定**
   - 上記と同じ環境変数を設定

## 3. FlutterアプリのAPI URL設定

Djangoバックエンドをデプロイしたら、FlutterアプリのAPI URLを更新：

1. **デプロイされたDjangoバックエンドのURLを取得**
   - Railway / RenderのデプロイURL（例: `https://your-app.railway.app`）

2. **FlutterアプリのAPI URLを更新**
   - `login_app/lib/utils/constants.dart`を編集：
   ```dart
   static const String baseUrl = 'https://your-backend-url.com/api';
   ```

3. **ネイティブアプリを再ビルド**
   - iOS: Xcodeで再ビルド
   - Android: `flutter build appbundle --release`で再ビルド

## 4. CORS設定の確認

Djangoバックエンドの`settings.py`でCORS設定を確認：

```python
CORS_ALLOWED_ORIGINS = [
    # ネイティブアプリの場合は、すべてのオリジンを許可するか、
    # 特定のドメインを指定
]

# ネイティブアプリの場合は、すべてのオリジンを許可しても問題ありません
CORS_ALLOW_ALL_ORIGINS = True  # ネイティブアプリ用
```

## セキュリティチェックリスト

- [ ] `SECRET_KEY`が環境変数で設定されている
- [ ] `DEBUG=False`に設定されている
- [ ] `ALLOWED_HOSTS`が適切に設定されている
- [ ] データベースパスワードが安全に管理されている
- [ ] HTTPSが有効になっている（Railway/Renderは自動でHTTPS）

## 参考リンク

- [Flutter iOS Deployment](https://docs.flutter.dev/deployment/ios)
- [Flutter Android Deployment](https://docs.flutter.dev/deployment/android)
- [Railway Documentation](https://docs.railway.app)
- [Render Documentation](https://render.com/docs)

