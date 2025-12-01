import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../services/auth_service.dart';
import '../services/storage_service.dart';
import 'dart:convert';

class AuthProvider with ChangeNotifier {
  User? _user;
  bool _isLoading = false;
  bool _isAuthenticated = false;

  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _isAuthenticated;

  AuthProvider() {
    _checkAuthStatus();
  }

  // 認証状態をチェック
  Future<void> _checkAuthStatus() async {
    _isLoading = true;
    notifyListeners();

    try {
      final token = await StorageService.getAccessToken();
      if (token != null) {
        final user = await AuthService.getCurrentUser();
        if (user != null) {
          _user = user;
          _isAuthenticated = true;
        } else {
          // トークンが無効な場合、リフレッシュを試みる
          final refreshed = await AuthService.refreshToken();
          if (refreshed) {
            final user = await AuthService.getCurrentUser();
            if (user != null) {
              _user = user;
              _isAuthenticated = true;
            } else {
              await _logout();
            }
          } else {
            await _logout();
          }
        }
      } else {
        // 保存されたユーザーデータを確認
        final userData = StorageService.getUserData();
        if (userData != null) {
          try {
            _user = User.fromJson(jsonDecode(userData) as Map<String, dynamic>);
            _isAuthenticated = false; // トークンがないので認証状態はfalse
          } catch (e) {
            // データが無効な場合は削除
            await StorageService.clearAll();
          }
        }
      }
    } catch (e) {
      await _logout();
    }

    _isLoading = false;
    notifyListeners();
  }

  String? _lastError;

  String? get lastError => _lastError;

  // ログイン
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _lastError = null;
    notifyListeners();

    try {
      final response = await AuthService.login(email: email, password: password);
      
      if (response.success && response.user != null) {
        _user = response.user;
        _isAuthenticated = true;
        _isLoading = false;
        _lastError = null;
        notifyListeners();
        return true;
      } else {
        _isLoading = false;
        _lastError = response.message ?? 'ログインに失敗しました';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _isLoading = false;
      _lastError = 'エラーが発生しました: $e';
      notifyListeners();
      return false;
    }
  }

  // 新規登録
  Future<String?> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String passwordConfirm,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await AuthService.register(
        firstName: firstName,
        lastName: lastName,
        email: email,
        password: password,
        passwordConfirm: passwordConfirm,
      );

      _isLoading = false;
      notifyListeners();

      if (response.success) {
        return null; // 成功
      } else {
        return response.message ?? '登録に失敗しました';
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return 'エラーが発生しました: $e';
    }
  }

  // ログアウト
  Future<void> logout() async {
    await _logout();
  }

  Future<void> _logout() async {
    await AuthService.logout();
    _user = null;
    _isAuthenticated = false;
    _isLoading = false;
    _lastError = null;
    notifyListeners();
  }

  // ユーザー情報を更新
  Future<void> refreshUser() async {
    final user = await AuthService.getCurrentUser();
    if (user != null) {
      _user = user;
      notifyListeners();
    }
  }
}

