class UploadMediaResponse {
  int code = 0;
  String message = "";
  String? data = "";

  UploadMediaResponse(this.code,this.message, this.data);
  UploadMediaResponse.buildDefault();
  factory UploadMediaResponse.fromJson(Map<String, dynamic> json) {
    return UploadMediaResponse(
      json['code'],
      json['message'],
      json['data'],
    );
  }
}
