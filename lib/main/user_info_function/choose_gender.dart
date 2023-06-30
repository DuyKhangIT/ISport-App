import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:isport_app/assets/assets.dart';

import '../../handle_api/handle_api.dart';
import '../../model/list_device_user/data_list_device_user_response.dart';
import '../../model/update_device_info/update_device_info_request.dart';
import '../../model/update_device_info/update_device_info_response.dart';
import '../../until/global.dart';
import '../../until/show_loading_dialog.dart';
import '../list_user.dart';

class ChooseGenderScreen extends StatefulWidget {
  final DataListDeviceUserResponse? dataDeviceUser;
  static String routeName = "/choose_gender_screen";
  const ChooseGenderScreen({Key? key,this.dataDeviceUser}) : super(key: key);

  @override
  State<ChooseGenderScreen> createState() => _ChooseGenderScreenState();
}

class _ChooseGenderScreenState extends State<ChooseGenderScreen> {
  Color? colorFemaleGender;
  Color? colorMaleGender;
  String gender = "";
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
            msg: "Cập nhật giới tính không thành công!",
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
              msg: "Cập nhật giới tính thành công",
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
                if(gender.isNotEmpty){
                  UpdateDeviceInfoRequest updateDeviceInfoRequest =
                  UpdateDeviceInfoRequest(
                      widget.dataDeviceUser!.name,
                      gender,
                      widget.dataDeviceUser!.age,
                      widget.dataDeviceUser!.weight,
                      widget.dataDeviceUser!.height,
                      widget.dataDeviceUser!.avt,
                      widget.dataDeviceUser!.nickName);
                  updateDeviceInfoApi(updateDeviceInfoRequest);
                }else{
                  Fluttertoast.showToast(
                      msg: "Vui lòng chọn giới tính!",
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
        padding: const EdgeInsets.symmetric(vertical: 200, horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text('Chọn giới tính',
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
              margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  /// male gender
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        colorMaleGender = Colors.orangeAccent;
                        if (colorMaleGender != null) {
                          gender = "Nam";
                          debugPrint(gender);
                          colorFemaleGender = null;
                        }
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          padding: const EdgeInsets.all(25),
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                              color: colorMaleGender ??
                                  Colors.grey.withOpacity(0.6),
                              shape: BoxShape.circle),
                          child: Image.asset(
                            IconsAssets.icMaleGender,
                            color: Colors.white,
                          ),
                        ),
                        Text('Nam',
                            style: TextStyle(
                                fontSize: 20,
                                fontFamily: 'Nunito Sans',
                                fontWeight: FontWeight.bold,
                                color: colorMaleGender ?? Colors.white54)),
                      ],
                    ),
                  ),
                  /// female gender
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        colorFemaleGender = Colors.orangeAccent;
                        if (colorFemaleGender != null) {
                          gender = "Nữ";
                          debugPrint(gender);
                          colorMaleGender = null;
                        }
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(25),
                          decoration: BoxDecoration(
                              color: colorFemaleGender ??
                                  Colors.grey.withOpacity(0.6),
                              shape: BoxShape.circle),
                          child: Image.asset(
                            IconsAssets.icFemaleGender,
                            color: Colors.white,
                          ),
                        ),
                        Text('Nữ',
                            style: TextStyle(
                                fontSize: 20,
                                fontFamily: 'Nunito Sans',
                                fontWeight: FontWeight.bold,
                                color: colorFemaleGender ?? Colors.white54)),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    ));
  }
}
