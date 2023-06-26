class DataListDataOfDeviceResponse {
  int idData = 0;
  int idDevice = 0;
  String time = "";
  int lat = 0;
  int lng = 0;
  int velocity = 0;
  int distance = 0;
  int heartRate = 0;
  int hour = 0;
  int minute = 0;
  int second = 0;
  int timeTotal = 0;

  DataListDataOfDeviceResponse(
    this.idData,
    this.idDevice,
    this.time,
    this.lat,
    this.lng,
    this.velocity,
    this.distance,
    this.heartRate,
    this.hour,
    this.minute,
    this.second,
    this.timeTotal,
  );
  DataListDataOfDeviceResponse.buildDefault();
  factory DataListDataOfDeviceResponse.fromJson(Map<String, dynamic> json) {
    return DataListDataOfDeviceResponse(
      json['iddata'],
      json['iddevice'],
      json['time'],
      json['lat'],
      json['lng'],
      json['velocity'],
      json['distance'],
      json['heart_rate'],
      json['hour'],
      json['minute'],
      json['second'],
      json['time_total'],
    );
  }
}
