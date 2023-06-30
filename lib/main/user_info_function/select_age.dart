import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:numberpicker/numberpicker.dart';

import '../../handle_api/handle_api.dart';
import '../../model/list_device_user/data_list_device_user_response.dart';
import '../../model/update_device_info/update_device_info_request.dart';
import '../../model/update_device_info/update_device_info_response.dart';
import '../../until/global.dart';
import '../../until/show_loading_dialog.dart';
import '../list_user.dart';
class SelectAgeScreen extends StatefulWidget {
  final DataListDeviceUserResponse? dataDeviceUser;
  static String routeName = "/select_age_screen";
  const SelectAgeScreen({Key? key,this.dataDeviceUser}) : super(key: key);

  @override
  State<SelectAgeScreen> createState() => _SelectAgeScreenState();
}

class _SelectAgeScreenState extends State<SelectAgeScreen> {
  int currentAge = 0;
  bool isLoading = false;

  /// call api update device
  Future<UpdateDeviceInfoResponse> updateDeviceInfoApi(
      UpdateDeviceInfoRequest updateDeviceInfoRequest) async {
    setState(() {
      isLoading = true;
      if (isLoading) {
        IsShowDialog().showLoadingDialog(context);
      } else {
        Navigator.of(context).pop();
      }
    });
    UpdateDeviceInfoResponse updateDeviceInfoResponse;
    Map<String, dynamic>? body;
    try {
      body = await HttpHelper.invokeHttp(
          Uri.parse(
              "http://192.168.1.8:3002/api/device/update?iddevice=${widget.dataDeviceUser!.idDevice}"),
          RequestType.post,
          headers: null,
          body: const JsonEncoder()
              .convert(updateDeviceInfoRequest.toBodyRequest()));
    } catch (error) {
      debugPrint("Fail to update device info $error");
      rethrow;
    }
    if (body == null) return UpdateDeviceInfoResponse.buildDefault();
    updateDeviceInfoResponse = UpdateDeviceInfoResponse.fromJson(body);
    if (updateDeviceInfoResponse.code != 0) {
      setState(() {
        isLoading = false;
        if (isLoading) {
          IsShowDialog().showLoadingDialog(context);
        } else {
          Navigator.of(context).pop();
        }
        Fluttertoast.showToast(
            msg: "Cập nhật tuổi không thành công!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 3,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16);
        debugPrint(updateDeviceInfoResponse.message);
      });
    } else {
      setState(() {
        isLoading = false;
        if (isLoading) {
          IsShowDialog().showLoadingDialog(context);
        } else {
          Navigator.of(context).pop();
          Fluttertoast.showToast(
              msg: "Cập nhật tuổi thành công",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 3,
              backgroundColor: Colors.orange,
              textColor: Colors.black,
              fontSize: 16);
          Navigator.pushNamedAndRemoveUntil(context,
              ListUserScreen.routeName,(Route<dynamic> route) => false);
        }
      });
    }
    return updateDeviceInfoResponse;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title:  Text(
              widget.dataDeviceUser!.name.isNotEmpty ? widget.dataDeviceUser!.name :"",
              style: const TextStyle(
                  color: Colors.black, fontWeight: FontWeight.w500, fontSize: 20),
            ),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.black),
            ),
            actions: [
              GestureDetector(
                onTap: (){
                  if(Global.isAvailableToClick()){
                    if(currentAge != 0){
                      UpdateDeviceInfoRequest updateDeviceInfoRequest =
                      UpdateDeviceInfoRequest(
                          widget.dataDeviceUser!.name,
                          widget.dataDeviceUser!.gender,
                          currentAge,
                          widget.dataDeviceUser!.weight,
                          widget.dataDeviceUser!.height,
                          widget.dataDeviceUser!.avt,
                          widget.dataDeviceUser!.nickName);
                      updateDeviceInfoApi(updateDeviceInfoRequest);
                    }else{
                      Fluttertoast.showToast(
                          msg: "Vui lòng chọn tuổi!",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 5,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16);
                    }
                  }
                },
                child: Container(
                  width: 80,
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(right: 15, top: 10, bottom: 10),
                  child: const Text(
                    'Xác nhận',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                ),
              ),
            ],
            elevation: 0,
          ),
          body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            padding: const EdgeInsets.symmetric(vertical: 150, horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text('Tuổi của bạn',
                    style: TextStyle(
                      fontSize: 26,
                      fontFamily: 'Nunito Sans',
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height/4,
                  margin: const EdgeInsets.symmetric(vertical: 20),
                  child:  NumberPicker(
                    selectedTextStyle: const TextStyle(
                      fontSize: 20,
                      fontFamily: 'Nunito Sans',
                      fontWeight: FontWeight.bold,
                      color: Colors.orangeAccent
                    ),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontFamily: 'Nunito Sans',
                      fontWeight: FontWeight.bold,
                    ),
                    value: currentAge,
                    minValue: 0,
                    maxValue: 100,
                    onChanged: (value) {
                      setState(() {
                        currentAge = value;
                        debugPrint(currentAge.toString());
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
