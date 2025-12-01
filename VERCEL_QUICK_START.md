# Vercelデプロイ クイックスタート

## 🚀 デプロイ手順（5分で完了）

### 1. Vercelアカウントの作成

1. https://vercel.com にアクセス
2. GitHubアカウントでログイン

### 2. プロジェクトのインポート

1. Vercelダッシュボードで「Add New...」→「Project」をクリック
2. GitHubリポジトリ `hirota-koyanaka/satoyamadr999` を選択
3. **重要**: 「Root Directory」を `login_app` に設定
4. 以下の設定を確認：
   - **Framework Preset**: Other
   - **Root Directory**: `login_app`
   - **Build Command**: `flutter build web --release`
   - **Output Directory**: `build/web`
   - **Install Command**: `flutter pub get`

### 3. 環境変数の設定（オプション）

現在は不要ですが、後でDjangoバックエンドのURLを設定する場合：

- `VITE_API_URL` または環境変数として設定

### 4. デプロイ実行

「Deploy」ボタンをクリック

### 5. デプロイ完了後の確認

- Vercelが自動的にデプロイURLを生成（例: `https://your-app.vercel.app`）
- ブラウザでアクセスして動作確認

## ⚠️ 重要な注意事項

### Djangoバックエンドについて

**VercelはDjangoバックエンドのデプロイには適していません。**

Djangoバックエンドは以下のプラットフォームにデプロイすることを推奨します：

1. **Railway**（推奨）- https://railway.app
   - 簡単にデプロイ可能
   - 無料枠あり
   - PostgreSQLが利用可能

2. **Render** - https://render.com
   - 無料枠あり
   - 自動デプロイ

3. **Heroku** - https://heroku.com
   - 有料プランのみ（無料枠終了）

### デプロイ後の設定

1. **Djangoバックエンドをデプロイ**（Railway推奨）
2. **FlutterアプリのAPI URLを更新**
   - `login_app/lib/utils/constants.dart`を編集
   - デプロイしたDjangoバックエンドのURLに変更
3. **再デプロイ**
   - 変更をコミット・プッシュ
   - Vercelが自動的に再デプロイ

## 🔧 トラブルシューティング

### ビルドエラーが発生する場合

1. **Flutter SDKがインストールされているか確認**
   - Vercelのビルドログを確認
   - Flutter SDKのインストールが必要な場合があります

2. **Root Directoryの確認**
   - `login_app`に設定されているか確認

3. **Build Commandの確認**
   - `flutter build web --release`が正しく設定されているか確認

### ローカルでビルドテスト

```bash
cd login_app
flutter pub get
flutter build web --release
```

ビルドが成功すれば、Vercelでもビルドできるはずです。

## 📚 参考リンク

- [Vercel Documentation](https://vercel.com/docs)
- [Flutter Web Deployment](https://docs.flutter.dev/deployment/web)
- [Railway Documentation](https://docs.railway.app)

