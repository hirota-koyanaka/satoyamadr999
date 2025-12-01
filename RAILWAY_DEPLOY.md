# Railway CLIデプロイ手順

## 1. Railway CLIのログイン

まず、Railway CLIにログインします（ブラウザが開きます）：

```bash
railway login
```

ブラウザで認証を完了してください。

## 2. プロジェクトの初期化

プロジェクトルートで実行：

```bash
cd /Users/hirotakoyanaka/Desktop/ログインアプリ
railway init
```

以下の質問に答えます：
- **Project name**: `login-app-backend`（任意の名前）
- **Environment**: `production`（または`development`）

## 3. PostgreSQLデータベースの追加

```bash
railway add postgresql
```

これでPostgreSQLデータベースが追加され、`DATABASE_URL`環境変数が自動的に設定されます。

## 4. 環境変数の設定

必要な環境変数を設定：

```bash
# SECRET_KEYを生成（ランダムな文字列）
railway variables set SECRET_KEY="$(openssl rand -hex 32)"

# DEBUGをFalseに設定
railway variables set DEBUG=False

# ALLOWED_HOSTSを設定（Railwayのドメイン）
railway variables set ALLOWED_HOSTS="*.railway.app"

# SupabaseのDATABASE_URLを使用する場合（PostgreSQLを追加しない場合）
# railway variables set DATABASE_URL="postgresql://postgres:password@host:port/database"
```

## 5. デプロイ

```bash
railway up
```

これでデプロイが開始されます。

## 6. デプロイURLの確認

```bash
railway domain
```

または

```bash
railway status
```

デプロイURLが表示されます（例: `https://your-app.railway.app`）

## 7. マイグレーションの実行

初回デプロイ後、マイグレーションを実行：

```bash
railway run python manage.py migrate
```

## 8. スーパーユーザーの作成（オプション）

Django Adminにアクセスするためにスーパーユーザーを作成：

```bash
railway run python manage.py createsuperuser
```

## 便利なコマンド

### ログの確認
```bash
railway logs
```

### 環境変数の確認
```bash
railway variables
```

### サービスの状態確認
```bash
railway status
```

### シェルに接続
```bash
railway shell
```

## トラブルシューティング

### デプロイが失敗する場合

1. **ログを確認**
   ```bash
   railway logs
   ```

2. **環境変数を確認**
   ```bash
   railway variables
   ```

3. **ローカルでテスト**
   ```bash
   railway run python manage.py check
   ```

### データベース接続エラー

- `DATABASE_URL`が正しく設定されているか確認
- PostgreSQLサービスが起動しているか確認

## 次のステップ

デプロイが完了したら：

1. **DjangoバックエンドのURLを取得**
   - `railway domain`で確認

2. **FlutterアプリのAPI URLを更新**
   - `login_app/lib/utils/constants.dart`を編集
   - `baseUrl`をデプロイしたURLに変更

3. **CORS設定の確認**
   - Djangoの`settings.py`でCORS設定を確認

