class LoginRequest {
  String emailOrPhone;
  String password;

  LoginRequest(this.emailOrPhone, this.password);

  Map<String, dynamic> toBodyRequest() => {
    'emailOrPhone': emailOrPhone,
    'password': password,
  };
}
