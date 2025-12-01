# Supabaseセットアップ手順

## 1. Supabaseアカウントの作成とプロジェクト作成

1. **Supabaseにアクセス**
   - https://supabase.com にアクセス
   - 「Start your project」をクリック

2. **GitHubアカウントでサインアップ**
   - GitHubアカウントでログイン（推奨）
   - またはメールアドレスでサインアップ

3. **新しいプロジェクトを作成**
   - 「New Project」をクリック
   - 以下の情報を入力：
     - **Organization**: 新規作成または既存の組織を選択
     - **Name**: `login-app`（任意の名前）
     - **Database Password**: 強力なパスワードを設定（**重要：メモしておく**）
     - **Region**: 最寄りのリージョンを選択（例: Northeast Asia (Tokyo)）
   - 「Create new project」をクリック
   - プロジェクトの作成には2-3分かかります

## 2. データベース接続情報の取得

1. **プロジェクトダッシュボードに移動**
   - プロジェクトが作成されたら、自動的にダッシュボードが表示されます

2. **接続情報を取得**
   - 左側のメニューから「Settings」（⚙️アイコン）をクリック
   - 「Project Settings」→「Database」を選択
   - 「Connection string」セクションで「URI」を選択
   - 接続文字列をコピー（例: `postgresql://postgres:[YOUR-PASSWORD]@db.xxxxx.supabase.co:5432/postgres`）

3. **接続文字列を編集**
   - コピーした接続文字列の `[YOUR-PASSWORD]` を、プロジェクト作成時に設定したパスワードに置き換えます
   - 例: `postgresql://postgres:your-actual-password@db.xxxxx.supabase.co:5432/postgres`

## 3. 環境変数の設定

ターミナルで以下のコマンドを実行して、接続文字列を環境変数に設定します：

```bash
export DATABASE_URL="postgresql://postgres:your-password@db.xxxxx.supabase.co:5432/postgres"
```

**注意**: `your-password` と `db.xxxxx.supabase.co` を実際の値に置き換えてください。

## 4. データベースのマイグレーション

環境変数を設定した後、Djangoサーバーを停止して、マイグレーションを実行します：

```bash
# サーバーを停止（実行中の場合）
pkill -f "manage.py runserver"

# 仮想環境をアクティベート
source venv/bin/activate

# 環境変数を設定（上記のDATABASE_URL）
export DATABASE_URL="postgresql://postgres:your-password@db.xxxxx.supabase.co:5432/postgres"

# マイグレーションを実行
python manage.py migrate
```

## 5. 既存データの移行（オプション）

SQLiteからSupabaseに既存のデータを移行する場合：

```bash
# 1. SQLiteからデータをエクスポート
python manage.py dumpdata > data.json

# 2. 環境変数を設定してSupabaseに接続
export DATABASE_URL="postgresql://postgres:your-password@db.xxxxx.supabase.co:5432/postgres"

# 3. マイグレーションを実行
python manage.py migrate

# 4. データをインポート
python manage.py loaddata data.json
```

## 6. Djangoサーバーの起動

```bash
# 環境変数を設定
export DATABASE_URL="postgresql://postgres:your-password@db.xxxxx.supabase.co:5432/postgres"

# サーバーを起動
source venv/bin/activate
python manage.py runserver 0.0.0.0:8000
```

## 7. 動作確認

1. **Django Adminにアクセス**
   - http://localhost:8000/admin
   - スーパーユーザーでログイン

2. **ユーザー一覧を確認**
   - 既存のユーザーが表示されることを確認

3. **Flutterアプリから新規登録**
   - 新しいユーザーを登録
   - Supabaseダッシュボードでデータが保存されていることを確認

## トラブルシューティング

### 接続エラーが発生する場合

1. **パスワードを確認**
   - 接続文字列のパスワードが正しいか確認

2. **ファイアウォール設定**
   - Supabaseダッシュボード → Settings → Database → Connection pooling
   - 「Allow connections from anywhere」が有効になっているか確認

3. **接続文字列の形式を確認**
   - `postgresql://` で始まっているか
   - ポート番号が `5432` か

### マイグレーションエラーが発生する場合

1. **既存のテーブルを確認**
   - Supabaseダッシュボード → Table Editor
   - 既存のテーブルがある場合は削除してから再マイグレーション

2. **マイグレーションファイルを確認**
   - `python manage.py showmigrations` で状態を確認

## セキュリティ注意事項

- **パスワードは絶対にGitにコミットしないでください**
- 環境変数は `.env` ファイルに保存し、`.gitignore` に追加することを推奨
- 本番環境では、環境変数管理サービス（例: Heroku Config Vars）を使用

## 次のステップ

Supabaseのセットアップが完了したら：
1. メール送信設定を有効化（`メール設定方法.md`を参照）
2. 本番環境のデプロイを検討

