import 'data_account_info_response.dart';

class AccountInfoResponse {
  int code = 0;
  String message = "";
  List<DataAccountInfoResponse> accountInfo = [];

  AccountInfoResponse(
    this.code,
    this.message,
    this.accountInfo,
  );
  AccountInfoResponse.buildDefault();
  factory AccountInfoResponse.fromJson(Map<String, dynamic> json) {
    List<DataAccountInfoResponse> accountInfo = [];
    if (json['data'] != null) {
      List<dynamic> arrData = json['data'];
      for (var i = 0; i < arrData.length; i++) {
        accountInfo.add(DataAccountInfoResponse.fromJson(
            arrData[i] as Map<String, dynamic>));
      }
    }
    return AccountInfoResponse(json['code'], json['message'], accountInfo);
  }
}
