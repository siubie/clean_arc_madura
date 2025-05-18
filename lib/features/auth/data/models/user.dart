class UserModel {
  final String email;
  final String password;

  UserModel({required this.email, required this.password});

  //create factory method to convert json to UserModel
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(email: json['email'], password: json['password']);
  }
}
