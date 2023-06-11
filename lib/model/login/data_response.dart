class DataResponseLogin {
  String accessToken = "";

  DataResponseLogin(
    this.accessToken,
  );
  DataResponseLogin.buildDefault();
  factory DataResponseLogin.fromJson(Map<String, dynamic> json) {
    return DataResponseLogin(
      json['accessToken'],
    );
  }
}
