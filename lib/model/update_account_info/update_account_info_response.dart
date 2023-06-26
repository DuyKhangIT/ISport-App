class UpdateAccountInfoResponse {
  int code = 0;
  String message = "";

  UpdateAccountInfoResponse(
    this.code,
    this.message,
  );
  UpdateAccountInfoResponse.buildDefault();
  factory UpdateAccountInfoResponse.fromJson(Map<String, dynamic> json) {
    return UpdateAccountInfoResponse(
      json['code'],
      json['message'],
    );
  }
}
