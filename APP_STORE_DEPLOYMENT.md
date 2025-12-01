# App Store デプロイガイド

このガイドでは、FlutterアプリをApp Storeにデプロイする手順を説明します。

## 前提条件

1. **Apple Developer Programへの登録**
   - [Apple Developer Program](https://developer.apple.com/programs/)に登録している必要があります（年間$99）
   - 登録が完了していることを確認してください

2. **必要なツール**
   - macOS（Xcodeが必要）
   - Xcode（最新版推奨）
   - Flutter SDK
   - CocoaPods

3. **現在の設定確認**
   - Bundle Identifier: `com.example.loginApp`（変更が必要）
   - Development Team: `SZGH77A9X4`（設定済み）
   - バージョン: `1.0.0+1`

## ステップ1: Bundle Identifierの変更

現在のBundle Identifier (`com.example.loginApp`) はApp Storeで使用できません。実際のドメイン名を使用する必要があります。

### 1.1 新しいBundle Identifierを決定

例：
- `com.yourcompany.loginapp`
- `jp.co.yourcompany.loginapp`
- `com.yourdomain.loginapp`

**重要**: このBundle IdentifierはApp Store Connectで登録する際にも使用します。

### 1.2 Xcodeプロジェクトで変更

1. Xcodeで `login_app/ios/Runner.xcworkspace` を開く
2. 左側のプロジェクトナビゲーターで「Runner」を選択
3. 「TARGETS」から「Runner」を選択
4. 「Signing & Capabilities」タブを開く
5. 「Bundle Identifier」を新しいIDに変更（例: `com.yourcompany.loginapp`）

または、以下のコマンドで一括変更：

```bash
cd login_app/ios
# project.pbxprojファイル内のcom.example.loginAppを新しいIDに置換
sed -i '' 's/com\.example\.loginApp/com.yourcompany.loginapp/g' Runner.xcodeproj/project.pbxproj
```

## ステップ2: App Store Connectでのアプリ登録

1. [App Store Connect](https://appstoreconnect.apple.com/)にログイン
2. 「マイ App」をクリック
3. 「+」ボタンをクリックして「新しいApp」を選択
4. 以下の情報を入力：
   - **プラットフォーム**: iOS
   - **名前**: Login App（または希望する名前）
   - **プライマリ言語**: 日本語
   - **Bundle ID**: ステップ1で設定したBundle Identifierを選択（または新規作成）
   - **SKU**: 一意のSKU（例: `loginapp-001`）
   - **ユーザーアクセス**: フルアクセス（推奨）
5. 「作成」をクリック

## ステップ3: アプリ情報の設定

App Store Connectで以下の情報を設定します：

### 3.1 App情報
- **カテゴリ**: 適切なカテゴリを選択（例: ユーティリティ、ビジネス）
- **プライバシーポリシーURL**: 必要に応じて設定

### 3.2 価格と販売地域
- **価格**: 無料または有料を選択
- **販売地域**: 販売する国・地域を選択

### 3.3 App プライバシー
- アプリが収集するデータの種類を設定
- 認証情報、ユーザーIDなどを適切に設定

## ステップ4: Xcodeでの証明書とプロビジョニングプロファイルの設定

### 4.1 自動署名の設定（推奨）

1. Xcodeで `login_app/ios/Runner.xcworkspace` を開く
2. 「Runner」プロジェクトを選択
3. 「TARGETS」から「Runner」を選択
4. 「Signing & Capabilities」タブを開く
5. 「Automatically manage signing」にチェックを入れる
6. 「Team」で自分のApple Developerアカウントを選択
7. Bundle Identifierが正しく設定されていることを確認

Xcodeが自動的に証明書とプロビジョニングプロファイルを作成・管理します。

### 4.2 手動設定（必要な場合）

自動署名が機能しない場合は、Apple Developer Portalで手動設定：

1. [Apple Developer Portal](https://developer.apple.com/account/)にログイン
2. 「Certificates, Identifiers & Profiles」を選択
3. 「Identifiers」でBundle Identifierを確認・作成
4. 「Profiles」でApp Store用のプロビジョニングプロファイルを作成
5. Xcodeで手動でプロファイルを選択

## ステップ5: アプリのビルド設定

### 5.1 リリースビルドの準備

`pubspec.yaml`でバージョン番号を確認・更新：

```yaml
version: 1.0.0+1  # バージョン名+ビルド番号
```

### 5.2 Info.plistの確認

`login_app/ios/Runner/Info.plist`で以下を確認：

- `CFBundleDisplayName`: App Storeに表示される名前
- `CFBundleShortVersionString`: バージョン番号（pubspec.yamlの`version`の最初の部分）
- `CFBundleVersion`: ビルド番号（pubspec.yamlの`version`の`+`以降）

### 5.3 アプリアイコンの設定

1. `login_app/ios/Runner/Assets.xcassets/AppIcon.appiconset/` にアイコン画像を配置
2. 必要なサイズ：
   - 1024x1024（App Store用）
   - その他のサイズはXcodeが自動生成

## ステップ6: リリースビルドの作成

### 6.1 Flutterのクリーンビルド

```bash
cd login_app
flutter clean
flutter pub get
```

### 6.2 iOS用のリリースビルド

```bash
flutter build ios --release
```

### 6.3 Xcodeでアーカイブを作成

1. Xcodeで `login_app/ios/Runner.xcworkspace` を開く
2. メニューから「Product」→「Scheme」→「Runner」を選択
3. デバイス選択で「Any iOS Device (arm64)」を選択
4. メニューから「Product」→「Archive」を選択
5. ビルドが完了するまで待つ（数分かかる場合があります）

## ステップ7: App Store Connectへのアップロード

### 7.1 Xcode Organizerからアップロード

1. アーカイブが完了すると「Organizer」ウィンドウが開きます
2. 作成したアーカイブを選択
3. 「Distribute App」をクリック
4. 「App Store Connect」を選択
5. 「Upload」を選択
6. 配布オプションを確認（通常はデフォルトでOK）
7. 「Upload」をクリック
8. アップロードが完了するまで待つ（数分〜数十分）

### 7.2 コマンドラインからアップロード（代替方法）

```bash
# アーカイブのパスを確認
# Xcode Organizerでアーカイブを右クリック → "Show in Finder"

# xcodebuildでアップロード（例）
xcodebuild -exportArchive \
  -archivePath ~/Library/Developer/Xcode/Archives/YYYY-MM-DD/Runner.xcarchive \
  -exportOptionsPlist ExportOptions.plist \
  -exportPath ./build/ios/ipa
```

## ステップ8: App Store Connectでの審査提出

### 8.1 ビルドの確認

1. App Store Connectにログイン
2. 作成したアプリを選択
3. 「TestFlight」または「App Store」タブを開く
4. 「+」ボタンでビルドを追加
5. アップロードしたビルドが表示されるまで待つ（数分〜1時間）

### 8.2 バージョン情報の入力

1. 「App Store」タブを開く
2. 「+ バージョンまたはプラットフォーム」をクリック
3. バージョン番号を入力（例: `1.0.0`）
4. 以下の情報を入力：
   - **スクリーンショット**: 必須（iPhone 6.7インチ、6.5インチ、5.5インチなど）
   - **説明**: アプリの説明文
   - **キーワード**: 検索用キーワード（カンマ区切り）
   - **サポートURL**: サポートページのURL
   - **マーケティングURL**: オプション
   - **プライバシーポリシーURL**: 必要に応じて

### 8.3 審査情報

1. **連絡先情報**: 審査担当者が連絡できる情報
2. **デモアカウント**: 必要に応じてテスト用アカウントを提供
3. **メモ**: 審査担当者への追加情報

### 8.4 提出

1. すべての情報を入力・確認
2. 「審査に提出」をクリック
3. 確認ダイアログで「提出」をクリック

## ステップ9: 審査の待機と対応

### 9.1 審査プロセス

- **審査時間**: 通常24〜48時間（場合によっては数日）
- **ステータス**: App Store Connectで確認可能
  - 「審査待ち」
  - 「審査中」
  - 「承認済み」または「却下」

### 9.2 却下された場合

1. 却下理由を確認
2. 問題を修正
3. 新しいビルドをアップロード
4. 再提出

## ステップ10: リリース

### 10.1 自動リリース

審査が承認されると、自動的にApp Storeに公開されます。

### 10.2 手動リリース

1. App Store Connectで「承認済み」のビルドを選択
2. 「このバージョンをリリース」をクリック
3. リリース日時を設定（即座にリリースも可能）

## トラブルシューティング

### 問題1: Bundle Identifierの競合

**エラー**: "Bundle identifier already exists"

**解決策**:
- 別のBundle Identifierを使用
- 既存のApp IDを削除（可能な場合）

### 問題2: 証明書エラー

**エラー**: "No valid signing certificate found"

**解決策**:
1. Xcodeで「Preferences」→「Accounts」を開く
2. Apple IDを選択
3. 「Download Manual Profiles」をクリック
4. 「Signing & Capabilities」で「Automatically manage signing」を有効化

### 問題3: プロビジョニングプロファイルエラー

**エラー**: "No provisioning profile found"

**解決策**:
1. Apple Developer Portalでプロビジョニングプロファイルを作成
2. Xcodeで手動で選択
3. または自動署名を有効化

### 問題4: ビルドエラー

**エラー**: 各種ビルドエラー

**解決策**:
```bash
cd login_app/ios
pod deintegrate
pod install
flutter clean
flutter pub get
flutter build ios --release
```

### 問題5: アップロードエラー

**エラー**: "Invalid Bundle" など

**解決策**:
1. Bundle Identifierが正しいか確認
2. バージョン番号が正しいか確認
3. Info.plistの設定を確認
4. クリーンビルドを実行

## よくある質問

### Q: Bundle Identifierは後から変更できますか？

A: App Store Connectで一度登録したBundle Identifierは変更できません。新しいBundle Identifierを使用する場合は、新しいアプリとして登録する必要があります。

### Q: 無料アプリでもApple Developer Programへの登録は必要ですか？

A: はい、App Storeに公開するにはApple Developer Programへの登録（年間$99）が必須です。

### Q: TestFlightでテストできますか？

A: はい、App Store ConnectでTestFlightを有効化すると、ベータテスターに配布できます。

### Q: バージョン番号はどのように管理しますか？

A: `pubspec.yaml`の`version`フィールドで管理します。形式は `バージョン名+ビルド番号`（例: `1.0.0+1`）。App Storeに提出するたびにビルド番号を増やす必要があります。

## 参考リンク

- [Apple Developer Program](https://developer.apple.com/programs/)
- [App Store Connect](https://appstoreconnect.apple.com/)
- [Flutter iOS Deployment](https://docs.flutter.dev/deployment/ios)
- [App Store Review Guidelines](https://developer.apple.com/app-store/review/guidelines/)

## 次のステップ

1. Bundle Identifierを適切なものに変更
2. App Store Connectでアプリを登録
3. リリースビルドを作成
4. アップロードと審査提出
5. リリース後のモニタリングとアップデート

---

**注意**: このガイドは一般的な手順を説明しています。実際の手順はAppleの最新の要件やXcodeのバージョンによって異なる場合があります。

