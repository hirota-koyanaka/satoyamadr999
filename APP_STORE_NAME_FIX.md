# App Store アプリ名エラー解決方法

## エラー内容

「App Record Creation failed due to request containing an attribute already in use. The App Name you entered is already being used.」

このエラーは、App Store Connectで使用しようとしたアプリ名が既に他の開発者によって使用されている場合に発生します。

## 解決方法

### 1. Info.plistのアプリ名を変更

`login_app/ios/Runner/Info.plist` の `CFBundleDisplayName` を変更しました：

```xml
<key>CFBundleDisplayName</key>
<string>Login Manager</string>
```

### 2. App Store Connectでの対応

#### 方法A: App Store Connectで直接別の名前を使用

1. App Store Connectでアプリを作成する際、以下のようなユニークな名前を使用してください：
   - **Login Manager**（推奨）
   - **My Login App**
   - **Secure Login App**
   - **Login Pro**
   - **認証アプリ**（日本語名）
   - **ログイン管理アプリ**（日本語名）

2. 名前の後ろに数字や記号を追加することもできます：
   - **Login App 2025**
   - **Login App Pro**

#### 方法B: 既存のアプリレコードを削除して再作成

もし既に「Login App」という名前でアプリレコードを作成してしまった場合：

1. App Store Connectにログイン
2. 「マイ App」で該当アプリを選択
3. 「App情報」タブを開く
4. アプリ名を変更するか、アプリを削除して再作成

**注意**: アプリを削除する場合は、審査中や公開済みのアプリは削除できません。

### 3. アプリ名の命名規則

App Storeでは以下の規則があります：

- **30文字以内**（日本語の場合は全角文字でカウント）
- **既存のアプリ名と重複しない**
- **商標権を侵害しない**
- **不適切な単語を含まない**

### 4. 推奨されるアプリ名の例

以下のような名前を検討してください：

- **Login Manager** ✅（変更済み）
- **Auth Manager**
- **Secure Login**
- **Login Helper**
- **認証マネージャー**
- **ログイン管理**

### 5. 次のステップ

1. Info.plistの変更を確認（既に変更済み）
2. Xcodeでプロジェクトを再ビルド
3. App Store Connectで新しいアプリ名でアプリを作成
4. アーカイブを再作成してアップロード

## トラブルシューティング

### 複数の名前が使用できない場合

複数の名前を試しても使用できない場合：

1. より具体的な名前を使用（例: 「MyCompany Login Manager」）
2. 会社名やブランド名を含める
3. 数字や記号を追加する

### 商標権について

もしあなたが「Login App」という名前の商標権を持っている場合：

1. App Store Connectのサポートに連絡
2. 商標権の証明書類を提出
3. 名前の解放を申請

---

**現在の設定**: `CFBundleDisplayName` = "Login Manager"

この名前でApp Store Connectにアプリを登録してください。

