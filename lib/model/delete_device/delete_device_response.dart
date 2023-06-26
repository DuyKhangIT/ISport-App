class DeleteDeviceResponse {
  int code = 0;
  String message = "";

  DeleteDeviceResponse(
    this.code,
    this.message,
  );
  DeleteDeviceResponse.buildDefault();
  factory DeleteDeviceResponse.fromJson(Map<String, dynamic> json) {
    return DeleteDeviceResponse(
      json['code'],
      json['message'],
    );
  }
}
