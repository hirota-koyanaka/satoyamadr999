class Validators {
  // メールアドレスのバリデーション
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'メールアドレスを入力してください';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return '有効なメールアドレスを入力してください';
    }
    return null;
  }

  // パスワードのバリデーション
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'パスワードを入力してください';
    }
    if (value.length < 8) {
      return 'パスワードは8文字以上で入力してください';
    }
    return null;
  }

  // パスワード確認のバリデーション
  static String? passwordConfirm(String? value, String? password) {
    if (value == null || value.isEmpty) {
      return 'パスワード確認を入力してください';
    }
    if (value != password) {
      return 'パスワードが一致しません';
    }
    return null;
  }

  // 名前のバリデーション
  static String? name(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldNameを入力してください';
    }
    return null;
  }
}

