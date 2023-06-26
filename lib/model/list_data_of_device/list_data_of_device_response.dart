import 'data_list_data_of_device_response.dart';

class ListDataOfDeviceResponse {
  int code = 0;
  String message = "";
  List<DataListDataOfDeviceResponse> listDataDevice= [];

  ListDataOfDeviceResponse(
    this.code,
    this.message,
    this.listDataDevice,
  );
  ListDataOfDeviceResponse.buildDefault();
  factory ListDataOfDeviceResponse.fromJson(Map<String, dynamic> json) {
    List<DataListDataOfDeviceResponse> listDataOfDevice = [];
    if (json['data'] != null) {
      List<dynamic> arrData = json['data'];
      for (var i = 0; i < arrData.length; i++) {
        listDataOfDevice.add(DataListDataOfDeviceResponse.fromJson(
            arrData[i] as Map<String, dynamic>));
      }
    }
    return ListDataOfDeviceResponse(
        json['code'], json['message'], listDataOfDevice);
  }
}
