#!/bin/bash

# App Storeデプロイ用スクリプト
# 使用方法: ./app_store_deploy.sh

set -e

echo "🚀 App Storeデプロイプロセスを開始します..."

# カラー出力用
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# プロジェクトのルートディレクトリ
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FLUTTER_DIR="$PROJECT_ROOT/login_app"
IOS_DIR="$FLUTTER_DIR/ios"

# Bundle Identifierの確認
echo -e "${YELLOW}📱 Bundle Identifierを確認中...${NC}"
BUNDLE_ID=$(grep -A 1 "PRODUCT_BUNDLE_IDENTIFIER" "$IOS_DIR/Runner.xcodeproj/project.pbxproj" | grep -v "RunnerTests" | head -1 | sed 's/.*= //' | sed 's/;//' | tr -d ' ')
echo "現在のBundle Identifier: $BUNDLE_ID"

if [[ "$BUNDLE_ID" == "com.example.loginApp" ]]; then
    echo -e "${RED}⚠️  警告: Bundle Identifierがデフォルトのままです。${NC}"
    echo -e "${YELLOW}App Storeに提出する前に、適切なBundle Identifierに変更してください。${NC}"
    echo ""
    read -p "続行しますか？ (y/n): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# Flutterのクリーンビルド
echo -e "${GREEN}🧹 Flutterクリーンビルドを実行中...${NC}"
cd "$FLUTTER_DIR"
flutter clean
flutter pub get

# iOS依存関係の更新
echo -e "${GREEN}📦 iOS依存関係を更新中...${NC}"
cd "$IOS_DIR"
pod install

# リリースビルド
echo -e "${GREEN}🔨 iOSリリースビルドを実行中...${NC}"
cd "$FLUTTER_DIR"
flutter build ios --release --no-codesign

echo -e "${GREEN}✅ ビルドが完了しました！${NC}"
echo ""
echo -e "${YELLOW}次のステップ:${NC}"
echo "1. Xcodeで $IOS_DIR/Runner.xcworkspace を開く"
echo "2. Product → Scheme → Runner を選択"
echo "3. デバイス選択で 'Any iOS Device (arm64)' を選択"
echo "4. Product → Archive を選択"
echo "5. アーカイブが完了したら、Organizerウィンドウで 'Distribute App' をクリック"
echo "6. 'App Store Connect' を選択してアップロード"
echo ""
echo -e "${GREEN}詳細は APP_STORE_DEPLOYMENT.md を参照してください。${NC}"

