final class LoginResponseEntity {
  final String token;
  final String userId;

  LoginResponseEntity({required this.token, required this.userId});

  factory LoginResponseEntity.fromMap(Map<String, dynamic> map) {
    return LoginResponseEntity(
      token: map['token'],
      userId: map['userId'],
    );
  }
}
