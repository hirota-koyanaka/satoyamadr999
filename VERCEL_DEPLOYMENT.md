# Vercelデプロイ手順

## デプロイ構成

このプロジェクトは以下の2つのコンポーネントで構成されています：

1. **Flutter Webアプリ** → Vercelにデプロイ
2. **Djangoバックエンド** → Railway / Renderにデプロイ（推奨）

## 1. Flutter WebアプリのVercelデプロイ

### 前提条件

- Vercelアカウント（https://vercel.com）
- GitHubアカウント（リポジトリは既に作成済み）

### 手順

#### 方法1: Vercel CLIを使用

```bash
# Vercel CLIをインストール
npm i -g vercel

# プロジェクトルートで実行
cd /Users/hirotakoyanaka/Desktop/ログインアプリ

# Vercelにログイン
vercel login

# デプロイ（Flutter Webアプリ）
cd login_app
vercel --prod
```

#### 方法2: Vercelダッシュボードから

1. **Vercelダッシュボードにアクセス**
   - https://vercel.com/dashboard

2. **新しいプロジェクトを作成**
   - "Add New..." → "Project" をクリック
   - GitHubリポジトリ `hirota-koyanaka/satoyamadr999` を選択

3. **プロジェクト設定**
   - **Root Directory**: `login_app`
   - **Build Command**: `flutter build web --release`
   - **Output Directory**: `build/web`
   - **Install Command**: `flutter pub get`

4. **環境変数の設定**
   - 環境変数は不要（API URLは後で設定）

5. **デプロイ**
   - "Deploy" をクリック

### Flutter Webアプリのビルド確認

```bash
cd login_app
flutter pub get
flutter build web --release
```

## 2. Djangoバックエンドのデプロイ（Railway推奨）

VercelはDjangoバックエンドのデプロイには適していません。以下のプラットフォームを推奨します：

### Railway（推奨）

1. **Railwayアカウント作成**
   - https://railway.app
   - GitHubアカウントでログイン

2. **新しいプロジェクトを作成**
   - "New Project" → "Deploy from GitHub repo"
   - リポジトリを選択

3. **環境変数の設定**
   ```
   DATABASE_URL=postgresql://postgres:password@host:port/database
   SECRET_KEY=your-secret-key-here
   DEBUG=False
   ALLOWED_HOSTS=your-railway-domain.railway.app
   ```

4. **デプロイ設定**
   - Root Directory: `/` (プロジェクトルート)
   - Build Command: `pip install -r requirements.txt`
   - Start Command: `python manage.py migrate && gunicorn backend.wsgi:application`

### Render（代替案）

1. **Renderアカウント作成**
   - https://render.com

2. **新しいWebサービスを作成**
   - GitHubリポジトリを接続
   - 環境変数を設定
   - デプロイ

## 3. API URLの設定

Flutter Webアプリのデプロイ後、API URLを更新：

1. **DjangoバックエンドのURLを取得**
   - Railway / RenderのデプロイURL（例: `https://your-app.railway.app`）

2. **FlutterアプリのAPI URLを更新**
   - `login_app/lib/utils/constants.dart`を編集：
   ```dart
   static const String baseUrl = 'https://your-backend-url.com/api';
   ```

3. **再デプロイ**
   - 変更をコミット・プッシュ
   - Vercelが自動的に再デプロイ

## 4. CORS設定の確認

Djangoバックエンドの`settings.py`でCORS設定を確認：

```python
CORS_ALLOWED_ORIGINS = [
    "https://your-flutter-app.vercel.app",
]
```

## トラブルシューティング

### Flutter Webビルドエラー

```bash
# Flutter SDKのバージョンを確認
flutter --version

# Webサポートを有効化
flutter config --enable-web

# クリーンビルド
flutter clean
flutter pub get
flutter build web --release
```

### Vercelビルドエラー

- `vercel.json`の設定を確認
- Root Directoryが`login_app`に設定されているか確認
- Build Commandが正しいか確認

## 参考リンク

- [Vercel Documentation](https://vercel.com/docs)
- [Flutter Web Deployment](https://docs.flutter.dev/deployment/web)
- [Railway Documentation](https://docs.railway.app)
- [Render Documentation](https://render.com/docs)

