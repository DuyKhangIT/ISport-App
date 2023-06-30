import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../model/account_info/data_account_info_response.dart';
import '../model/list_device_user/data_list_device_user_response.dart';

class Global{
  static int primaryColor = 0xFFFFDAC1;
  static String mToken = "";
  static DataAccountInfoResponse? accountInfo;
  static List<DataListDeviceUserResponse> listDeviceUser = [];
  static LatLng? latLngFromDB;


  /// Condition to check the email address
  bool checkEmailAddress(String newEmail) {
    if (newEmail.isNotEmpty) {
      return RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          .hasMatch(newEmail);
    }
    return false;
  }


  /// block auto click or many time click
  static int mTimeClick = 0;

  static bool isAvailableToClick() {
    if (DateTime.now().millisecondsSinceEpoch - mTimeClick > 2000) {
      mTimeClick = DateTime.now().millisecondsSinceEpoch;
      return true;
    }
    return false;
  }

  static String convertMedia(String path) {
    debugPrint("Loaded path: " + path);
    return "http://192.168.1.8:3002/$path";
  }
}