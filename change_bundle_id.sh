#!/bin/bash

# Bundle Identifier変更スクリプト
# 使用方法: ./change_bundle_id.sh <新しいBundleID>
# 例: ./change_bundle_id.sh com.yourcompany.loginapp

set -e

if [ -z "$1" ]; then
    echo "❌ エラー: Bundle Identifierを指定してください"
    echo "使用方法: ./change_bundle_id.sh <新しいBundleID>"
    echo "例: ./change_bundle_id.sh com.yourcompany.loginapp"
    exit 1
fi

NEW_BUNDLE_ID="$1"
OLD_BUNDLE_ID="com.example.loginApp"

# プロジェクトのルートディレクトリ
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
IOS_DIR="$PROJECT_ROOT/login_app/ios"
PBXPROJ="$IOS_DIR/Runner.xcodeproj/project.pbxproj"

echo "🔄 Bundle Identifierを変更中..."
echo "古いID: $OLD_BUNDLE_ID"
echo "新しいID: $NEW_BUNDLE_ID"
echo ""

# project.pbxprojファイル内のBundle Identifierを変更
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    sed -i '' "s/$OLD_BUNDLE_ID/$NEW_BUNDLE_ID/g" "$PBXPROJ"
else
    # Linux
    sed -i "s/$OLD_BUNDLE_ID/$NEW_BUNDLE_ID/g" "$PBXPROJ"
fi

echo "✅ Bundle Identifierを変更しました: $NEW_BUNDLE_ID"
echo ""
echo "📝 次のステップ:"
echo "1. Xcodeで $IOS_DIR/Runner.xcworkspace を開く"
echo "2. Runnerプロジェクト → Signing & Capabilities でBundle Identifierを確認"
echo "3. Apple Developer Portalで同じBundle IdentifierのApp IDを作成（必要に応じて）"
echo "4. App Store Connectでアプリを登録する際に、このBundle Identifierを使用"

