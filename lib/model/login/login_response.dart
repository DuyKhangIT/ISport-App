import 'data_response.dart';

class LoginResponse {
  int code = 0;
  String message = "";
  DataResponseLogin? dataResponseLogin;

  LoginResponse(
      this.code,
      this.message,
      this.dataResponseLogin,
      );
  LoginResponse.buildDefault();
  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      json['code'],
      json['message'],
      (json['data'] != null) ? DataResponseLogin.fromJson(json['data']) : null,
    );
  }
}