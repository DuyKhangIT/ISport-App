class DataAccountInfoResponse {
  String email = "";
  String phone = "";
  String fullName = "";
  String avt = "";
  int idUser = 0;

  DataAccountInfoResponse(
    this.email,
    this.phone,
    this.fullName,
    this.avt,
    this.idUser,
  );
  DataAccountInfoResponse.buildDefault();
  factory DataAccountInfoResponse.fromJson(Map<String, dynamic> json) {
    return DataAccountInfoResponse(
      json['email'],
      json['phone'],
      json['fullname'],
      json['avt'],
      json['iduser'],
    );
  }
}
