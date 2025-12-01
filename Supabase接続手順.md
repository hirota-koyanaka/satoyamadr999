# Supabase接続手順

## プロジェクト情報
- **プロジェクトID**: `skbvryjtjxmdslfwivqh`
- **接続文字列のテンプレート**: 
  ```
  postgresql://postgres:[PASSWORD]@db.skbvryjtjxmdslfwivqh.supabase.co:5432/postgres
  ```

## 手順

### 1. Supabaseダッシュボードから接続文字列を取得

1. **Supabaseダッシュボードにアクセス**
   - https://supabase.com/dashboard/project/skbvryjtjxmdslfwivqh/settings/database

2. **接続文字列を取得**
   - 「Connection string」セクションを探す
   - 「URI」を選択
   - 接続文字列をコピー（`[YOUR-PASSWORD]` を実際のパスワードに置き換えたもの）

### 2. .envファイルを作成

プロジェクトルートに `.env` ファイルを作成し、以下の内容を記述：

```bash
DATABASE_URL=postgresql://postgres:your-password@db.skbvryjtjxmdslfwivqh.supabase.co:5432/postgres
```

**重要**: `your-password` を実際のパスワードに置き換えてください。

### 3. マイグレーションを実行

```bash
source venv/bin/activate
python manage.py migrate
```

### 4. 接続を確認

```bash
python manage.py shell -c "from django.db import connection; connection.ensure_connection(); print('接続成功！')"
```

## 注意事項

- `.env` ファイルは `.gitignore` に追加されているため、Gitにコミットされません
- パスワードに特殊文字（`@`、`:`など）が含まれる場合は、URLエンコードが必要です
- 接続できない場合は、パスワードと接続文字列を再確認してください

