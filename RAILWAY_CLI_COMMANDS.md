# Railway CLI デプロイコマンド（手動実行用）

## ステップ1: Railway CLIにログイン

ターミナルで以下のコマンドを実行してください（ブラウザが開きます）：

```bash
cd /Users/hirotakoyanaka/Desktop/ログインアプリ
railway login
```

ブラウザで認証を完了してください。

## ステップ2: プロジェクトの初期化

ログイン後、以下のコマンドを実行：

```bash
railway init --name login-app-backend
```

## ステップ3: PostgreSQLデータベースの追加

```bash
railway add postgresql
```

これでPostgreSQLデータベースが追加され、`DATABASE_URL`環境変数が自動的に設定されます。

## ステップ4: 環境変数の設定

```bash
# SECRET_KEYを生成して設定
railway variables set SECRET_KEY="$(openssl rand -hex 32)"

# DEBUGをFalseに設定
railway variables set DEBUG=False

# ALLOWED_HOSTSを設定
railway variables set ALLOWED_HOSTS="*.railway.app"
```

## ステップ5: デプロイ

```bash
railway up
```

デプロイが開始されます。数分かかります。

## ステップ6: デプロイURLの確認

```bash
railway domain
```

デプロイURLが表示されます（例: `https://your-app.railway.app`）

## ステップ7: マイグレーションの実行

```bash
railway run python manage.py migrate
```

## ステップ8: スーパーユーザーの作成（オプション）

Django Adminにアクセスするために：

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

## 次のステップ

デプロイが完了したら：

1. **DjangoバックエンドのURLを取得**
   - `railway domain`で確認

2. **FlutterアプリのAPI URLを更新**
   - `login_app/lib/utils/constants.dart`を編集
   - `baseUrl`をデプロイしたURLに変更（例: `https://your-app.railway.app/api`）

3. **CORS設定の確認**
   - Djangoの`settings.py`でCORS設定を確認（既に`CORS_ALLOW_ALL_ORIGINS = True`が設定されているので問題ありません）

