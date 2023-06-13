import 'data_register_response.dart';

class RegisterResponse {
  int code = 0;
  String message = "";
  DataResponseRegister? dataResponseRegister;

  RegisterResponse(
    this.code,
    this.message,
    this.dataResponseRegister,
  );
  RegisterResponse.buildDefault();
  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      json['code'],
      json['message'],
      (json['data'] != null)
          ? DataResponseRegister.fromJson(json['data'])
          : null,
    );
  }
}
