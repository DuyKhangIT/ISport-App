class RegisterRequest {
  String email;
  String phone;
  String password;
  String fullName;

  RegisterRequest(this.email, this.phone, this.password, this.fullName);

  Map<String, dynamic> toBodyRequest() => {
        'email': email,
        'phone': phone,
        'password': password,
        'fullName': fullName,
      };
}
