# Supabase CLIログイン - アクセストークン取得方法

## 方法1: 確認コードを使用（推奨）

1. **ターミナルで確認コードを確認**
   - 確認コード: `0abf789a`

2. **ブラウザでSupabaseにアクセス**
   - https://supabase.com/dashboard にアクセス
   - ログイン（まだの場合）

3. **確認コードを入力**
   - ログイン後、確認コード入力画面が表示される場合があります
   - または、以下のURLに直接アクセス：
     - https://supabase.com/dashboard/account/tokens
   - 確認コード `0abf789a` を入力

## 方法2: アクセストークンを直接取得（簡単）

1. **Supabaseダッシュボードにログイン**
   - https://supabase.com/dashboard にアクセス
   - ログイン

2. **アクセストークンページにアクセス**
   - https://supabase.com/dashboard/account/tokens にアクセス
   - または、Settings → Access Tokens

3. **新しいアクセストークンを生成**
   - 「Generate new token」をクリック
   - トークン名を入力（例: `cli-token`）
   - トークンをコピー（**重要：このトークンは一度しか表示されません**）

4. **CLIでログイン**
   ```bash
   cd /Users/hirotakoyanaka/Desktop/ログインアプリ
   supabase login --token YOUR_ACCESS_TOKEN
   ```
   `YOUR_ACCESS_TOKEN` を実際のトークンに置き換えてください。

## 方法3: 環境変数で設定

アクセストークンを取得したら、環境変数として設定することもできます：

```bash
export SUPABASE_ACCESS_TOKEN="your-access-token"
```

その後、CLIコマンドを実行すると自動的に認証されます。

## ログイン確認

ログインが完了したら、以下のコマンドで確認できます：

```bash
supabase projects list
```

プロジェクトの一覧が表示されれば、ログイン成功です。

