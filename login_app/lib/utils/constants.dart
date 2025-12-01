class ApiConstants {
  // RailwayデプロイURL
  static const String baseUrl = 'https://backend-production-876f.up.railway.app/api';
  
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

