class UpdateDeviceInfoResponse {
  int code = 0;
  String message = "";

  UpdateDeviceInfoResponse(
    this.code,
    this.message,
  );
  UpdateDeviceInfoResponse.buildDefault();
  factory UpdateDeviceInfoResponse.fromJson(Map<String, dynamic> json) {
    return UpdateDeviceInfoResponse(
      json['code'],
      json['message'],
    );
  }
}
