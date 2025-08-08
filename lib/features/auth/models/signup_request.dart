class SignupRequest {
  final String username;
  final String email;
  final String password;

  SignupRequest({
    required this.username,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {'name': username, 'email': email, 'password': password};
  }
}
