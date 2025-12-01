#!/bin/bash
# Railway CLI デプロイステップバイステップスクリプト

set -e

echo "=========================================="
echo "Railway CLI デプロイ"
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
echo "ステップ1: Railwayにログイン..."
if railway whoami &> /dev/null; then
    echo "✅ 既にログイン済み: $(railway whoami)"
else
    echo "⚠️  ログインが必要です"
    echo "以下のコマンドを手動で実行してください:"
    echo "  railway login"
    echo ""
    echo "ログイン後、このスクリプトを再実行してください"
    exit 1
fi

echo ""
echo "ステップ2: プロジェクトの初期化..."
read -p "プロジェクト名を入力してください（デフォルト: login-app-backend）: " PROJECT_NAME
PROJECT_NAME=${PROJECT_NAME:-login-app-backend}

if [ -f ".railway" ]; then
    echo "⚠️  既にRailwayプロジェクトが初期化されています"
    read -p "既存のプロジェクトを使用しますか？ (y/n): " USE_EXISTING
    if [ "$USE_EXISTING" != "y" ]; then
        echo "既存のプロジェクトを使用します"
    else
        railway init --name "$PROJECT_NAME"
    fi
else
    railway init --name "$PROJECT_NAME"
fi

echo ""
echo "ステップ3: PostgreSQLデータベースの追加..."
if railway service list 2>/dev/null | grep -q postgresql; then
    echo "⚠️  PostgreSQLは既に追加されています"
else
    railway add postgresql
    echo "✅ PostgreSQLデータベースを追加しました"
fi

echo ""
echo "ステップ4: 環境変数の設定..."

# SECRET_KEYを確認
if railway variables get SECRET_KEY &>/dev/null; then
    echo "⚠️  SECRET_KEYは既に設定されています"
else
    SECRET_KEY=$(openssl rand -hex 32)
    railway variables set SECRET_KEY="$SECRET_KEY"
    echo "✅ SECRET_KEYを設定しました"
fi

# DEBUGを設定
railway variables set DEBUG=False
echo "✅ DEBUG=Falseを設定しました"

# ALLOWED_HOSTSを設定
railway variables set ALLOWED_HOSTS="*.railway.app"
echo "✅ ALLOWED_HOSTSを設定しました"

echo ""
echo "ステップ5: デプロイを開始..."
railway up

echo ""
echo "ステップ6: デプロイURLを取得..."
sleep 3
DOMAIN=$(railway domain 2>/dev/null || echo "取得中...")
echo "デプロイURL: $DOMAIN"

echo ""
echo "ステップ7: マイグレーションを実行..."
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

