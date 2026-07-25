class LoginRequest {
  final String email;
  final String password;

  LoginRequest({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'password': password,
    };
  }
}

class AuthResponse {
  final String accessToken;
  final String userId;

  AuthResponse({
    required this.accessToken,
    required this.userId,
  });

  factory AuthResponse.fromMap(Map<String, dynamic> map) {
    return AuthResponse(
      accessToken: map['access_token'] ?? '',
      userId: map['user_id'] ?? '',
    );
  }
}
