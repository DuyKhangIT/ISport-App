import 'data_list_device_user_response.dart';

class ListDeviceUserResponse {
  int code = 0;
  String message = "";
  List<DataListDeviceUserResponse> listDataDeviceUser = [];

  ListDeviceUserResponse(
    this.code,
    this.message,
    this.listDataDeviceUser,
  );
  ListDeviceUserResponse.buildDefault();
  factory ListDeviceUserResponse.fromJson(Map<String, dynamic> json) {
    List<DataListDeviceUserResponse> listDeviceUserData = [];
    if (json['data'] != null) {
      List<dynamic> arrData = json['data'];
      for (var i = 0; i < arrData.length; i++) {
        listDeviceUserData.add(DataListDeviceUserResponse.fromJson(
            arrData[i] as Map<String, dynamic>));
      }
    }
    return ListDeviceUserResponse(
        json['code'],
        json['message'],
        listDeviceUserData);
  }
}
