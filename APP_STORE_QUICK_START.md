# App Store デプロイ クイックスタート

このガイドは、App Storeへのデプロイを迅速に開始するための簡易版です。詳細は `APP_STORE_DEPLOYMENT.md` を参照してください。

## 前提条件チェックリスト

- [ ] Apple Developer Programに登録済み（年間$99）
- [ ] macOSとXcodeがインストール済み
- [ ] Flutter SDKがインストール済み

## 5分で始めるデプロイ手順

### ステップ1: Bundle Identifierの変更（必須）

現在のBundle Identifier (`com.example.loginApp`) はApp Storeで使用できません。

```bash
# スクリプトを使用して変更
./change_bundle_id.sh com.yourcompany.loginapp

# または手動で変更
# Xcodeで login_app/ios/Runner.xcworkspace を開く
# Runner → Signing & Capabilities → Bundle Identifier を変更
```

**重要**: `com.yourcompany.loginapp` の部分を、あなたの実際のドメイン名に置き換えてください。

### ステップ2: App Store Connectでアプリを登録

1. [App Store Connect](https://appstoreconnect.apple.com/)にログイン
2. 「マイ App」→「+」→「新しいApp」
3. 以下を入力：
   - プラットフォーム: **iOS**
   - 名前: **Login App**（任意）
   - プライマリ言語: **日本語**
   - Bundle ID: ステップ1で設定したIDを選択
   - SKU: **loginapp-001**（任意の一意の値）
4. 「作成」をクリック

### ステップ3: ビルドとアップロード

```bash
# デプロイスクリプトを実行
./app_store_deploy.sh
```

または手動で：

```bash
cd login_app
flutter clean
flutter pub get
flutter build ios --release
```

その後、Xcodeで：

1. `login_app/ios/Runner.xcworkspace` を開く
2. Product → Scheme → Runner
3. デバイス選択で「Any iOS Device (arm64)」
4. Product → Archive
5. アーカイブ完了後、「Distribute App」→「App Store Connect」→「Upload」

### ステップ4: App Store Connectで審査提出

1. App Store Connectでアプリを選択
2. 「App Store」タブを開く
3. 「+ バージョンまたはプラットフォーム」をクリック
4. 必須情報を入力：
   - スクリーンショット（必須）
   - 説明文
   - キーワード
   - サポートURL
5. 「審査に提出」をクリック

## よくある問題と解決方法

### Bundle Identifierエラー

**エラー**: "Bundle identifier already exists"

**解決**: 別のBundle Identifierを使用してください。

### 証明書エラー

**エラー**: "No valid signing certificate found"

**解決**: 
1. Xcode → Preferences → Accounts
2. Apple IDを選択
3. 「Download Manual Profiles」をクリック
4. Runner → Signing & Capabilities → 「Automatically manage signing」にチェック

### ビルドエラー

**解決**:
```bash
cd login_app/ios
pod deintegrate
pod install
flutter clean
flutter pub get
```

## 重要な注意事項

1. **Bundle Identifierは変更不可**: 一度App Store Connectで登録したBundle Identifierは変更できません
2. **バージョン番号**: `pubspec.yaml`の`version`フィールドで管理（例: `1.0.0+1`）
3. **スクリーンショット**: App Store提出には必須です
4. **審査時間**: 通常24〜48時間（場合によっては数日）

## 次のステップ

詳細な手順は `APP_STORE_DEPLOYMENT.md` を参照してください。

---

**トラブルが発生した場合**: `APP_STORE_DEPLOYMENT.md` の「トラブルシューティング」セクションを確認してください。

