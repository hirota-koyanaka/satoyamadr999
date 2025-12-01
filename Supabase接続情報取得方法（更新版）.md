# Supabase接続情報の取得方法（更新版）

## プロジェクト情報
- **プロジェクトID**: `skbvryjtjxmdslfwivqh`
- **プロジェクト名**: `login-app`
- **リージョン**: Northeast Asia (Tokyo)

## 接続情報の取得方法

### 方法1: Supabaseダッシュボードから取得

1. **Supabaseダッシュボードにアクセス**
   - https://supabase.com/dashboard/project/skbvryjtjxmdslfwivqh

2. **Settings → Database に移動**
   - 左側のメニューから「Settings」（⚙️アイコン）をクリック
   - 「Database」を選択

3. **接続情報を確認**
   - 「Database password」セクションでパスワードを確認またはリセット
   - 「Connection string」セクションがない場合は、以下の情報を確認：
     - **Host**: `db.skbvryjtjxmdslfwivqh.supabase.co`
     - **Port**: `5432`
     - **Database name**: `postgres`
     - **User**: `postgres`
     - **Password**: （Database passwordセクションで確認）

4. **接続文字列を手動で構築**
   ```
   postgresql://postgres:[PASSWORD]@db.skbvryjtjxmdslfwivqh.supabase.co:5432/postgres
   ```
   `[PASSWORD]` を実際のパスワードに置き換えてください。

### 方法2: パスワードをリセットして新しい接続文字列を作成

1. **Supabaseダッシュボードでパスワードをリセット**
   - Settings → Database → Database password
   - 「Reset database password」をクリック
   - 新しいパスワードを設定（**必ずメモしておく**）

2. **接続文字列を作成**
   ```
   postgresql://postgres:新しいパスワード@db.skbvryjtjxmdslfwivqh.supabase.co:5432/postgres
   ```

### 方法3: Connection Poolingを使用（推奨）

Supabaseでは、通常の接続の代わりにConnection Poolingを使用することが推奨されています。

1. **Settings → Database → Connection pooling** に移動
2. **Connection string** をコピー
3. ポート番号が `6543` または `5432` のものを選択

## .envファイルの設定

接続文字列を取得したら、プロジェクトルートに `.env` ファイルを作成：

```bash
DATABASE_URL=postgresql://postgres:your-password@db.skbvryjtjxmdslfwivqh.supabase.co:5432/postgres
```

## 接続テスト

```bash
source venv/bin/activate
python 接続テスト.py
```

## トラブルシューティング

- **接続できない場合**:
  - パスワードが正しいか確認
  - パスワードに特殊文字（`@`、`:`など）が含まれる場合は、URLエンコードが必要
  - ファイアウォール設定を確認

- **Connection stringセクションが見つからない場合**:
  - Settings → Database → Database password でパスワードを確認
  - 上記の方法で手動で接続文字列を構築

