import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:isport_app/main/list_user.dart';

import '../../assets/icons_assets.dart';
import '../../handle_api/handle_api.dart';
import '../../model/list_device_user/data_list_device_user_response.dart';
import '../../model/update_device_info/update_device_info_request.dart';
import '../../model/update_device_info/update_device_info_response.dart';
import '../../until/global.dart';
import '../../until/show_loading_dialog.dart';

class InputNickNameScreen extends StatefulWidget {
  final DataListDeviceUserResponse? dataDeviceUser;
  static String routeName = "/input_nick_name_screen";
  const InputNickNameScreen({Key? key,this.dataDeviceUser}) : super(key: key);

  @override
  State<InputNickNameScreen> createState() => _InputNickNameScreenState();
}

class _InputNickNameScreenState extends State<InputNickNameScreen> {
  TextEditingController nickNameController = TextEditingController();
  String nickName = "";
  bool isLoading = false;

  void clearTextFullName() {
    nickName = "";
    nickNameController.clear();
  }

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
              "http://192.168.1.7:3002/api/device/update?iddevice=${widget.dataDeviceUser!.idDevice}"),
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
            msg: "Cập nhật biệt danh không thành công!",
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
              msg: "Cập nhật biệt danh thành công",
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
          widget.dataDeviceUser!.name.isNotEmpty ? widget.dataDeviceUser!.name: "",
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
               if(nickName.isNotEmpty){
                 UpdateDeviceInfoRequest updateDeviceInfoRequest =
                 UpdateDeviceInfoRequest(
                     widget.dataDeviceUser!.name,
                     widget.dataDeviceUser!.gender,
                     widget.dataDeviceUser!.age,
                     widget.dataDeviceUser!.weight,
                     widget.dataDeviceUser!.height,
                     widget.dataDeviceUser!.avt,
                     nickName);
                 updateDeviceInfoApi(updateDeviceInfoRequest);
               }else{
                 Fluttertoast.showToast(
                     msg: "Vui lòng nhập biệt danh!",
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
        padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 20),
        child: Column(
          children: [
            const Text('Nhập biệt danh của bạn',
                style: TextStyle(
                  fontSize: 26,
                  fontFamily: 'Nunito Sans',
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center),
            const SizedBox(
              height: 10,
            ),

            /// text field
            textFieldNickName(),
          ],
        ),
      ),
    ));
  }

  Widget textFieldNickName() {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(6),
      ),
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.only(left: 16, right: 10),
      child: TextField(
        controller: nickNameController,
        keyboardType: TextInputType.text,
        cursorColor: Colors.grey,
        decoration: InputDecoration(
            isDense: true,
            hintText: 'Biệt danh của bạn',
            hintStyle: const TextStyle(
              fontFamily: 'NunitoSans',
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w400,
              fontSize: 14,
            ),
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            counterText: '',
            suffixIcon: (nickNameController.text.isEmpty)
                ? const SizedBox()
                : GestureDetector(
                    onTap: () {
                      clearTextFullName();
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Image.asset(
                        IconsAssets.icClearText,
                      ),
                    ),
                  )),
        onChanged: (value) {
          setState(() {
            nickName = value;
          });
        },
        style: TextStyle(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.black,
            fontFamily: 'NunitoSans',
            fontSize: 14,
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.w600,
            height: 1.9),
      ),
    );
  }
}
