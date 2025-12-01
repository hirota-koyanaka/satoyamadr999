#!/bin/bash
# Railway CLIデプロイスクリプト

set -e

echo "=========================================="
echo "Railway CLI デプロイスクリプト"
echo "=========================================="
echo ""

# Railway CLIがインストールされているか確認
if ! command -v railway &> /dev/null; then
    echo "❌ Railway CLIがインストールされていません"
    echo "インストール: npm install -g @railway/cli"
    exit 1
fi

echo "✅ Railway CLI: $(railway --version)"
echo ""

# ログイン状態を確認
echo "1. Railwayにログイン..."
if ! railway whoami &> /dev/null; then
    echo "⚠️  ログインが必要です。ブラウザが開きます..."
    railway login
else
    echo "✅ 既にログイン済み: $(railway whoami)"
fi

echo ""
echo "2. プロジェクトの初期化..."
read -p "プロジェクト名を入力してください（デフォルト: login-app-backend）: " PROJECT_NAME
PROJECT_NAME=${PROJECT_NAME:-login-app-backend}

railway init --name "$PROJECT_NAME"

echo ""
echo "3. PostgreSQLデータベースの追加..."
railway add postgresql

echo ""
echo "4. 環境変数の設定..."

# SECRET_KEYを生成
SECRET_KEY=$(openssl rand -hex 32)
railway variables set SECRET_KEY="$SECRET_KEY"
echo "✅ SECRET_KEYを設定しました"

# DEBUGをFalseに設定
railway variables set DEBUG=False
echo "✅ DEBUG=Falseを設定しました"

# ALLOWED_HOSTSを設定
railway variables set ALLOWED_HOSTS="*.railway.app"
echo "✅ ALLOWED_HOSTSを設定しました"

echo ""
echo "5. デプロイを開始..."
railway up

echo ""
echo "6. デプロイURLを取得..."
DOMAIN=$(railway domain 2>/dev/null || echo "取得中...")
echo "デプロイURL: $DOMAIN"

echo ""
echo "7. マイグレーションを実行..."
railway run python manage.py migrate

echo ""
echo "=========================================="
echo "✅ デプロイが完了しました！"
echo "=========================================="
echo ""
echo "次のステップ:"
echo "1. デプロイURLを確認: railway domain"
echo "2. スーパーユーザーを作成: railway run python manage.py createsuperuser"
echo "3. FlutterアプリのAPI URLを更新: login_app/lib/utils/constants.dart"
echo ""

