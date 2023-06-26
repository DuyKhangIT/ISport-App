class AddDeviceResponse {
  int code = 0;
  String message = "";

  AddDeviceResponse(
    this.code,
    this.message,
  );
  AddDeviceResponse.buildDefault();
  factory AddDeviceResponse.fromJson(Map<String, dynamic> json) {
    return AddDeviceResponse(
      json['code'],
      json['message'],
    );
  }
}
