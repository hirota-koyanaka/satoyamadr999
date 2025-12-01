import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';
import '../services/storage_service.dart';
import '../services/auth_service.dart';

class ApiService {
  // 401エラー時にトークンをリフレッシュして再試行する
  static Future<http.Response> _retryWithRefresh(
    Future<http.Response> Function() requestFn,
    bool requireAuth,
  ) async {
    final response = await requestFn();
    
    // 401エラーで認証が必要な場合、トークンをリフレッシュして再試行
    if (response.statusCode == 401 && requireAuth) {
      final refreshed = await AuthService.refreshToken();
      if (refreshed) {
        // リフレッシュ成功したら再試行
        return await requestFn();
      }
    }
    
    return response;
  }

  static Future<http.Response> get(
    String endpoint, {
    Map<String, String>? headers,
    bool requireAuth = true,
  }) async {
    return await _retryWithRefresh(() async {
      final url = Uri.parse('${ApiConstants.baseUrl}$endpoint');
      
      Map<String, String> requestHeaders = {
        'Content-Type': 'application/json',
        ...?headers,
      };

      if (requireAuth) {
        final token = await StorageService.getAccessToken();
        if (token != null) {
          requestHeaders['Authorization'] = 'Bearer $token';
        }
      }

      return await http.get(url, headers: requestHeaders);
    }, requireAuth);
  }

  static Future<http.Response> post(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    bool requireAuth = false,
  }) async {
    try {
      return await _retryWithRefresh(() async {
        final url = Uri.parse('${ApiConstants.baseUrl}$endpoint');
        
        Map<String, String> requestHeaders = {
          'Content-Type': 'application/json',
          ...?headers,
        };

        if (requireAuth) {
          final token = await StorageService.getAccessToken();
          if (token != null) {
            requestHeaders['Authorization'] = 'Bearer $token';
          }
        }

        return await http.post(
          url,
          headers: requestHeaders,
          body: body != null ? jsonEncode(body) : null,
        ).timeout(
          const Duration(seconds: 10),
          onTimeout: () {
            throw Exception('リクエストがタイムアウトしました');
          },
        );
      }, requireAuth);
    } catch (e) {
      // エラーを再スローして、呼び出し元で処理できるようにする
      rethrow;
    }
  }

  static Future<http.Response> put(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    bool requireAuth = true,
  }) async {
    return await _retryWithRefresh(() async {
      final url = Uri.parse('${ApiConstants.baseUrl}$endpoint');
      
      Map<String, String> requestHeaders = {
        'Content-Type': 'application/json',
        ...?headers,
      };

      if (requireAuth) {
        final token = await StorageService.getAccessToken();
        if (token != null) {
          requestHeaders['Authorization'] = 'Bearer $token';
        }
      }

      return await http.put(
        url,
        headers: requestHeaders,
        body: body != null ? jsonEncode(body) : null,
      );
    }, requireAuth);
  }
}

