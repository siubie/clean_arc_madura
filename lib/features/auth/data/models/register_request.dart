class RegisterRequest {
  final String email;
  final String password;
  final String name;
  final String passwordConfirmation;

  RegisterRequest({
    required this.email,
    required this.password,
    required this.name,
    required this.passwordConfirmation,
  });

  // Convert the RegisterRequest object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'name': name,
      'password_confirmation': passwordConfirmation,
    };
  }
}
