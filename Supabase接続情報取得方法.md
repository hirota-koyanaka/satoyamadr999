# Supabase接続情報の取得方法

## プロジェクト情報

- **プロジェクト名**: login-app
- **プロジェクトID**: skbvryjtjxmdslfwivqh
- **リージョン**: Northeast Asia (Tokyo)

## データベース接続情報の取得

### 方法1: Supabaseダッシュボードから取得（推奨）

1. **Supabaseダッシュボードにアクセス**
   - https://supabase.com/dashboard/project/skbvryjtjxmdslfwivqh/settings/database

2. **接続文字列を取得**
   - 「Connection string」セクションを探す
   - 「URI」を選択
   - 接続文字列をコピー（例: `postgresql://postgres:[YOUR-PASSWORD]@db.skbvryjtjxmdslfwivqh.supabase.co:5432/postgres`）

3. **パスワードを設定**
   - プロジェクト作成時に生成されたパスワードを使用
   - または、Settings → Database → Reset database password で新しいパスワードを設定

4. **接続文字列を完成させる**
   - `[YOUR-PASSWORD]` を実際のパスワードに置き換える

### 方法2: 環境変数で設定

接続文字列を取得したら、以下のように環境変数に設定します：

```bash
export DATABASE_URL="postgresql://postgres:your-password@db.skbvryjtjxmdslfwivqh.supabase.co:5432/postgres"
```

### 方法3: CLIで接続情報を確認

```bash
cd /Users/hirotakoyanaka/Desktop/ログインアプリ
supabase db remote get --linked
```

## 次のステップ

接続情報を取得したら：

1. **環境変数を設定**
   ```bash
   export DATABASE_URL="postgresql://postgres:your-password@db.skbvryjtjxmdslfwivqh.supabase.co:5432/postgres"
   ```

2. **Djangoマイグレーションを実行**
   ```bash
   source venv/bin/activate
   python manage.py migrate
   ```

3. **既存データの移行（オプション）**
   ```bash
   # SQLiteからデータをエクスポート
   python manage.py dumpdata > data.json
   
   # 環境変数を設定してSupabaseに接続
   export DATABASE_URL="postgresql://postgres:your-password@db.skbvryjtjxmdslfwivqh.supabase.co:5432/postgres"
   
   # マイグレーションとデータインポート
   python manage.py migrate
   python manage.py loaddata data.json
   ```

4. **サーバーを起動**
   ```bash
   export DATABASE_URL="postgresql://postgres:your-password@db.skbvryjtjxmdslfwivqh.supabase.co:5432/postgres"
   python manage.py runserver 0.0.0.0:8000
   ```

## 注意事項

- データベースパスワードは機密情報です。Gitにコミットしないでください
- 環境変数は `.env` ファイルに保存し、`.gitignore` に追加することを推奨します
- プロジェクト作成時に生成されたパスワードは、Supabaseダッシュボードで確認できます

