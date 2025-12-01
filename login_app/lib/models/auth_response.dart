import 'user.dart';

class AuthResponse {
  final String? accessToken;
  final String? refreshToken;
  final User? user;
  final bool success;
  final String? message;
  final Map<String, dynamic>? errors;

  AuthResponse({
    this.accessToken,
    this.refreshToken,
    this.user,
    required this.success,
    this.message,
    this.errors,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      accessToken: json['access'] as String?,
      refreshToken: json['refresh'] as String?,
      user: json['user'] != null ? User.fromJson(json['user'] as Map<String, dynamic>) : null,
      success: json['success'] as bool? ?? true,
      message: json['message'] as String?,
      errors: json['errors'] as Map<String, dynamic>?,
    );
  }

  factory AuthResponse.error(String message, {Map<String, dynamic>? errors}) {
    return AuthResponse(
      success: false,
      message: message,
      errors: errors,
    );
  }
}

