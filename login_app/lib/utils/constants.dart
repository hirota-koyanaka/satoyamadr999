class ApiConstants {
  // iPhoneからアクセスする場合は、PCのローカルIPアドレスを使用
  // MacのIPアドレス: 192.168.0.9
  static const String baseUrl = 'http://192.168.0.9:8000/api';
  
  static const String registerEndpoint = '/accounts/register/';
  static const String loginEndpoint = '/accounts/login/';
  static const String userEndpoint = '/accounts/user/';
  static const String refreshTokenEndpoint = '/accounts/token/refresh/';
}

class StorageKeys {
  static const String accessToken = 'access_token';
  static const String refreshToken = 'refresh_token';
  static const String userData = 'user_data';
}

