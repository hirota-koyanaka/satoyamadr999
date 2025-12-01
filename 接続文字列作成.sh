#!/bin/bash
# Supabase接続文字列作成スクリプト

echo "=========================================="
echo "Supabase接続文字列の作成"
echo "=========================================="
echo ""
echo "プロジェクトID: skbvryjtjxmdslfwivqh"
echo "接続文字列のテンプレート:"
echo "postgresql://postgres:[PASSWORD]@db.skbvryjtjxmdslfwivqh.supabase.co:5432/postgres"
echo ""
echo "Supabaseダッシュボードで以下を確認してください："
echo "1. Settings → Database → Database password"
echo "2. パスワードをコピー（またはリセットして新しいパスワードを設定）"
echo ""
read -p "データベースパスワードを入力してください: " PASSWORD

if [ -z "$PASSWORD" ]; then
    echo "パスワードが入力されていません。"
    exit 1
fi

# URLエンコード（基本的な特殊文字のみ）
ENCODED_PASSWORD=$(echo "$PASSWORD" | sed 's/@/%40/g' | sed 's/:/%3A/g' | sed 's/#/%23/g' | sed 's/ /%20/g')

DATABASE_URL="postgresql://postgres:${ENCODED_PASSWORD}@db.skbvryjtjxmdslfwivqh.supabase.co:5432/postgres"

echo ""
echo "=========================================="
echo "接続文字列:"
echo "$DATABASE_URL"
echo "=========================================="
echo ""

# .envファイルに書き込む
read -p ".envファイルに書き込みますか？ (y/n): " CONFIRM
if [ "$CONFIRM" = "y" ] || [ "$CONFIRM" = "Y" ]; then
    echo "DATABASE_URL=$DATABASE_URL" > .env
    echo ".envファイルを作成しました！"
    echo ""
    echo "次のコマンドで接続をテストできます："
    echo "  source venv/bin/activate"
    echo "  python 接続テスト.py"
else
    echo ".envファイルには書き込みませんでした。"
    echo "手動で.envファイルを作成して、以下の内容を記述してください："
    echo "DATABASE_URL=$DATABASE_URL"
fi
