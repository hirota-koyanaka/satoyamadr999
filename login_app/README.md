# ログインアプリ

名前・メールアドレス・パスワードで新規登録し、承認後にログインできるFlutterアプリケーションです。

## 機能

- ✅ 新規登録（名前、メールアドレス、パスワード）
- ✅ ログイン（メールアドレス、パスワード）
- ✅ 承認状態の確認
- ✅ ホーム画面での名前表示
- ✅ ログアウト機能

## 技術スタック

- **Flutter**: 3.24.5
- **状態管理**: Provider
- **HTTP通信**: http
- **ローカルストレージ**: shared_preferences, flutter_secure_storage
- **フォームバリデーション**: flutter_form_builder

## セットアップ

### 1. 依存パッケージのインストール

```bash
flutter pub get
```

### 2. APIエンドポイントの設定

`lib/utils/constants.dart` ファイルで、Django APIのベースURLを設定してください：

```dart
static const String baseUrl = 'http://localhost:8000/api';
```

本番環境の場合は、実際のAPI URLに変更してください。

### 3. アプリの実行

```bash
flutter run
```

## プロジェクト構造

```
lib/
├── main.dart                 # アプリのエントリーポイント
├── models/                   # データモデル
│   ├── user.dart
│   └── auth_response.dart
├── services/                 # API通信・ストレージサービス
│   ├── api_service.dart
│   ├── auth_service.dart
│   └── storage_service.dart
├── providers/                # 状態管理
│   └── auth_provider.dart
├── screens/                  # 画面
│   ├── login_screen.dart
│   ├── register_screen.dart
│   └── home_screen.dart
├── widgets/                  # 再利用可能なウィジェット
│   ├── custom_text_field.dart
│   └── loading_indicator.dart
└── utils/                    # ユーティリティ
    ├── constants.dart
    └── validators.dart
```

## API仕様

このアプリは以下のDjango REST APIエンドポイントと連携します：

- `POST /api/accounts/register/` - 新規登録
- `POST /api/accounts/login/` - ログイン
- `GET /api/accounts/user/` - ユーザー情報取得
- `POST /api/accounts/token/refresh/` - トークンリフレッシュ

詳細は `実装計画.md` を参照してください。

## 次のステップ

1. Djangoバックエンドの実装
2. APIエンドポイントの設定
3. テストとデバッグ
