# Railway CLI ログインガイド

## ログイン方法

Railway CLIのログインは対話的な操作が必要です。以下のいずれかの方法でログインしてください。

### 方法1: 通常のログイン（ブラウザが開く）

```bash
railway login
```

ブラウザが自動的に開き、認証を完了してください。

### 方法2: ブラウザレスログイン

```bash
railway login --browserless
```

認証URLが表示されるので、ブラウザで開いて認証を完了し、表示されたトークンをコピーして貼り付けてください。

### 方法3: 認証トークンを直接設定

1. Railwayダッシュボード（https://railway.app）にアクセス
2. Settings → Tokens で新しいトークンを作成
3. 以下のコマンドで設定：

```bash
railway link --token YOUR_TOKEN
```

## ログイン確認

ログインが成功したか確認：

```bash
railway whoami
```

ユーザー名が表示されればログイン成功です。

## ログイン後のデプロイ

ログインが完了したら、以下のいずれかの方法でデプロイを進めます：

### 方法1: 自動スクリプトを使用

```bash
./railway_deploy_step_by_step.sh
```

### 方法2: 手動でコマンドを実行

`RAILWAY_CLI_COMMANDS.md`を参照して、コマンドを順番に実行してください。

## トラブルシューティング

### ログインエラーが発生する場合

1. **Railway CLIのバージョンを確認**
   ```bash
   railway --version
   ```

2. **最新版にアップデート**
   ```bash
   npm install -g @railway/cli@latest
   ```

3. **認証情報をクリア**
   ```bash
   rm -rf ~/.railway
   railway login
   ```

### ブラウザが開かない場合

- `--browserless`オプションを使用
- または、認証トークンを直接設定

