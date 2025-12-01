# Supabase CLIセットアップ手順

## 前提条件

- Supabase CLIがインストール済み（確認済み）
- Supabaseアカウントが必要

## 手順

### 1. Supabaseにログイン（CLI）

```bash
cd /Users/hirotakoyanaka/Desktop/ログインアプリ
supabase login
```

ブラウザが開いて認証が完了します。

### 2. Supabaseプロジェクトの作成（Web UI）

**注意**: プロジェクトの作成はWeb UIで行う必要があります。

1. https://supabase.com にアクセス
2. 「Start your project」をクリック
3. GitHubアカウントでサインアップ（推奨）
4. 新しいプロジェクトを作成：
   - **Name**: `login-app`（任意の名前）
   - **Database Password**: 強力なパスワードを設定（**重要：メモしておく**）
   - **Region**: 最寄りのリージョン（例: Northeast Asia (Tokyo)）
5. 「Create new project」をクリック
6. プロジェクトの作成完了を待つ（2-3分）

### 3. プロジェクトIDの取得

1. Supabaseダッシュボードでプロジェクトを開く
2. Settings → General → Reference ID をコピー

### 4. プロジェクトをリンク（CLI）

```bash
cd /Users/hirotakoyanaka/Desktop/ログインアプリ
supabase link --project-ref YOUR_PROJECT_REF
```

`YOUR_PROJECT_REF` を実際のプロジェクトIDに置き換えてください。

### 5. データベース接続情報の取得（CLI）

```bash
supabase db remote get
```

または、Supabaseダッシュボードから：
- Settings → Database → Connection string → URI

### 6. 環境変数の設定

接続文字列を環境変数に設定：

```bash
export DATABASE_URL="postgresql://postgres:your-password@db.xxxxx.supabase.co:5432/postgres"
```

### 7. Djangoマイグレーションの実行

```bash
source venv/bin/activate
python manage.py migrate
```

### 8. 既存データの移行（オプション）

```bash
# SQLiteからデータをエクスポート
python manage.py dumpdata > data.json

# 環境変数を設定
export DATABASE_URL="postgresql://postgres:your-password@db.xxxxx.supabase.co:5432/postgres"

# マイグレーションとデータインポート
python manage.py migrate
python manage.py loaddata data.json
```

## 便利なCLIコマンド

```bash
# プロジェクトの状態確認
supabase status

# データベースの接続確認
supabase db remote get

# マイグレーションの確認
supabase migration list

# ローカル開発環境の起動（オプション）
supabase start
```

