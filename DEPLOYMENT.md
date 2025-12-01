# デプロイ手順

## プロジェクト構成

このプロジェクトは**モノリポ（Monorepo）**構成で、以下の2つのコンポーネントが含まれています：

- **Flutterアプリ** (`login_app/`): モバイルアプリケーション
- **Djangoバックエンド** (`backend/`, `accounts/`): REST APIと管理画面

## GitHubへのプッシュ

### 1. リポジトリの作成

GitHubで新しいリポジトリを作成します。

### 2. 初回プッシュ

```bash
# Gitリポジトリの初期化（まだの場合）
git init

# リモートリポジトリの追加
git remote add origin https://github.com/your-username/your-repo-name.git

# ファイルの追加
git add .

# コミット
git commit -m "Initial commit: Flutter app and Django backend"

# プッシュ
git branch -M main
git push -u origin main
```

## デプロイ先の選択

### Flutterアプリのデプロイ

#### iOS (App Store)
- Xcodeでビルド
- App Store Connectにアップロード

#### Android (Google Play Store)
- Android Studioでビルド
- Google Play Consoleにアップロード

#### Web
- Firebase Hosting
- Vercel
- Netlify

### Djangoバックエンドのデプロイ

#### 推奨プラットフォーム
- **Heroku**: 簡単にデプロイ可能
- **Railway**: モダンで使いやすい
- **Render**: 無料枠あり
- **AWS Elastic Beanstalk**: スケーラブル
- **DigitalOcean App Platform**: シンプル

## 環境変数の設定

### Djangoバックエンド

デプロイ先のプラットフォームで以下の環境変数を設定：

```bash
DATABASE_URL=postgresql://postgres:password@host:port/database
SECRET_KEY=your-secret-key-here
DEBUG=False
ALLOWED_HOSTS=your-domain.com,www.your-domain.com
```

### Flutterアプリ

`login_app/lib/utils/constants.dart`のAPI URLを本番環境のURLに変更：

```dart
static const String baseUrl = 'https://your-api-domain.com/api';
```

## セキュリティチェックリスト

- [ ] `.env`ファイルが`.gitignore`に含まれている
- [ ] `SECRET_KEY`が環境変数で設定されている
- [ ] `DEBUG=False`に設定されている
- [ ] `ALLOWED_HOSTS`が適切に設定されている
- [ ] データベースパスワードが安全に管理されている
- [ ] CORS設定が適切に設定されている

## デプロイ後の確認事項

1. Django Adminがアクセス可能か確認
2. APIエンドポイントが正常に動作するか確認
3. FlutterアプリからAPIに接続できるか確認
4. データベース接続が正常か確認

