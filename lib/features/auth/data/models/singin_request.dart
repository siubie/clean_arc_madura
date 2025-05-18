class SinginRequest {
  final String email;
  final String password;

  SinginRequest({required this.email, required this.password});

  Map<String, dynamic> toJson() {
    return {'email': email, 'password': password};
  }

  factory SinginRequest.fromJson(Map<String, dynamic> json) {
    return SinginRequest(email: json['email'], password: json['password']);
  }
}
