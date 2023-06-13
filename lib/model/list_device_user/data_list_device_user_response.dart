class DataListDeviceUserResponse {
  int idDevice = 0;
  String name = "";
  String gender = "";
  int age = 0;
  int weight = 0;
  int height = 0;
  String time = "";
  int idUser = 0;

  DataListDeviceUserResponse(
    this.idDevice,
    this.name,
    this.gender,
    this.age,
    this.weight,
    this.height,
    this.time,
    this.idUser,
  );
  DataListDeviceUserResponse.buildDefault();
  factory DataListDeviceUserResponse.fromJson(Map<String, dynamic> json) {
    return DataListDeviceUserResponse(
      json['iddevice'],
      json['name'],
      json['gender'],
      json['age'],
      json['weight'],
      json['height'],
      json['time'],
      json['iduser'],
    );
  }
}
