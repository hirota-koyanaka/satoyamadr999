import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/auth_response.dart';
import '../models/user.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';
import '../utils/constants.dart';

class AuthService {
  // 新規登録
  static Future<AuthResponse> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String passwordConfirm,
  }) async {
    try {
      final response = await ApiService.post(
        ApiConstants.registerEndpoint,
        body: {
          'first_name': firstName,
          'last_name': lastName,
          'email': email,
          'password': password,
          'password_confirm': passwordConfirm,
        },
      );

      // レスポンスボディをデコード
      Map<String, dynamic> data;
      try {
        data = jsonDecode(response.body) as Map<String, dynamic>;
      } catch (e) {
        return AuthResponse.error(
          'サーバーからの応答を解析できませんでした。ステータスコード: ${response.statusCode}',
        );
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        return AuthResponse.fromJson(data);
      } else {
        // エラーメッセージを構築
        String errorMessage = '登録に失敗しました';
        
        // フィールドごとのエラーメッセージを確認（例: {"email": ["エラーメッセージ"]}）
        if (data.isNotEmpty) {
          for (var key in data.keys) {
            final value = data[key];
            if (value is List && value.isNotEmpty) {
              errorMessage = value.first.toString();
              break;
            } else if (value is String) {
              errorMessage = value;
              break;
            }
          }
        }
        
        // 従来のエラーフィールドも確認
        if (data.containsKey('message')) {
          errorMessage = data['message'] as String;
        } else if (data.containsKey('detail')) {
          errorMessage = data['detail'] as String;
        } else if (data.containsKey('errors')) {
          final errors = data['errors'] as Map<String, dynamic>?;
          if (errors != null && errors.isNotEmpty) {
            final firstError = errors.values.first;
            if (firstError is List && firstError.isNotEmpty) {
              errorMessage = firstError.first.toString();
            } else {
              errorMessage = firstError.toString();
            }
          }
        }
        
        return AuthResponse.error(
          errorMessage,
          errors: data,
        );
      }
    } catch (e) {
      String errorMessage = 'ネットワークエラーが発生しました';
      if (e.toString().contains('Failed host lookup') || 
          e.toString().contains('Connection refused') ||
          e.toString().contains('SocketException')) {
        errorMessage = 'サーバーに接続できませんでした。\n'
            '以下の点を確認してください：\n'
            '1. Djangoサーバーが起動しているか\n'
            '2. MacとiPhoneが同じWi-Fiネットワークに接続されているか\n'
            '3. API URL: ${ApiConstants.baseUrl}${ApiConstants.registerEndpoint}';
      } else {
        errorMessage = 'エラー: $e';
      }
      return AuthResponse.error(errorMessage);
    }
  }

  // ログイン
  static Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await ApiService.post(
        ApiConstants.loginEndpoint,
        body: {
          'email': email,
          'password': password,
        },
      );

      // レスポンスボディをデコード
      Map<String, dynamic> data;
      try {
        data = jsonDecode(response.body) as Map<String, dynamic>;
      } catch (e) {
        return AuthResponse.error(
          'サーバーからの応答を解析できませんでした。ステータスコード: ${response.statusCode}',
        );
      }

      if (response.statusCode == 200) {
        // トークンを保存
        if (data['access'] != null) {
          await StorageService.saveAccessToken(data['access'] as String);
        }
        if (data['refresh'] != null) {
          await StorageService.saveRefreshToken(data['refresh'] as String);
        }
        // ユーザーデータを保存
        if (data['user'] != null) {
          await StorageService.saveUserData(jsonEncode(data['user']));
        }

        return AuthResponse.fromJson(data);
      } else if (response.statusCode == 401) {
        // 認証失敗（メールアドレスまたはパスワードが間違っている）
        return AuthResponse.error(
          data['detail'] as String? ?? 'メールアドレスまたはパスワードが正しくありません。',
        );
      } else if (response.statusCode == 403) {
        // 承認待ち
        return AuthResponse.error(
          data['detail'] as String? ?? 'アカウントがまだ承認されていません。管理者の承認をお待ちください。',
        );
      } else {
        // その他のエラー
        String errorMessage = 'ログインに失敗しました';
        
        if (data.containsKey('detail')) {
          errorMessage = data['detail'] as String;
        } else if (data.containsKey('message')) {
          errorMessage = data['message'] as String;
        } else if (data.containsKey('error')) {
          errorMessage = data['error'] as String;
        } else if (data.isNotEmpty) {
          // フィールドごとのエラーメッセージを確認
          for (var key in data.keys) {
            final value = data[key];
            if (value is List && value.isNotEmpty) {
              errorMessage = value.first.toString();
              break;
            } else if (value is String) {
              errorMessage = value;
              break;
            }
          }
        }
        
        return AuthResponse.error(errorMessage, errors: data);
      }
    } catch (e) {
      String errorMessage = 'ネットワークエラーが発生しました';
      if (e.toString().contains('Failed host lookup') || 
          e.toString().contains('Connection refused') ||
          e.toString().contains('SocketException')) {
        errorMessage = 'サーバーに接続できませんでした。\n'
            '以下の点を確認してください：\n'
            '1. Djangoサーバーが起動しているか\n'
            '2. MacとiPhoneが同じWi-Fiネットワークに接続されているか\n'
            '3. API URL: ${ApiConstants.baseUrl}${ApiConstants.loginEndpoint}';
      } else {
        errorMessage = 'エラー: $e';
      }
      return AuthResponse.error(errorMessage);
    }
  }

  // ユーザー情報取得
  static Future<User?> getCurrentUser() async {
    try {
      final response = await ApiService.get(ApiConstants.userEndpoint);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return User.fromJson(data);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // ログアウト
  static Future<void> logout() async {
    await StorageService.clearAll();
  }

  // トークンリフレッシュ
  static Future<bool> refreshToken() async {
    try {
      final refreshToken = await StorageService.getRefreshToken();
      if (refreshToken == null) return false;

      // リフレッシュトークンエンドポイントは直接HTTP呼び出し（再試行しない）
      final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.refreshTokenEndpoint}');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refresh': refreshToken}),
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('リクエストがタイムアウトしました');
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        if (data['access'] != null) {
          await StorageService.saveAccessToken(data['access'] as String);
          return true;
        }
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}

