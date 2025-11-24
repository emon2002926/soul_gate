class LoginResponseModel {
  final String access;
  final String refresh;

  LoginResponseModel({required this.access, required this.refresh});

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      access: json['access'] ?? '',
      refresh: json['refresh'] ?? '',
    );
  }
}