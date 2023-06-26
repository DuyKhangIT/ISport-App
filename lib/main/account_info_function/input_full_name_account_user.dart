import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:isport_app/main/account_info.dart';
import 'package:isport_app/model/update_account_info/update_account_info_request/update_full_name_device_info_request.dart';
import 'package:isport_app/model/update_account_info/update_account_info_response.dart';

import '../../assets/icons_assets.dart';
import '../../handle_api/handle_api.dart';
import '../../model/account_info/account_info_response.dart';
import '../../until/global.dart';
import '../../until/show_loading_dialog.dart';

class InputFullNameAccountUserScreen extends StatefulWidget {
  static String routeName = "/input_full_name_account_screen_screen";
  const InputFullNameAccountUserScreen({Key? key}) : super(key: key);

  @override
  State<InputFullNameAccountUserScreen> createState() => _InputFullNameAccountUserScreenState();
}

class _InputFullNameAccountUserScreenState extends State<InputFullNameAccountUserScreen> {
  TextEditingController fullNameController = TextEditingController();
  String fullName = "";
  bool isLoading = false;

  void clearTextFullName() {
    fullName = "";
    fullNameController.clear();
  }

  /// call api update device
  Future<UpdateAccountInfoResponse> updateFullNameAccountInfoApi(
      UpdateFullNameAccountInfoRequest updateFullNameAccountInfoRequest) async {
    setState(() {
      isLoading = true;
      if (isLoading) {
        IsShowDialog().showLoadingDialog(context);
      } else {
        Navigator.of(context).pop();
      }
    });
    UpdateAccountInfoResponse updateAccountInfoResponse;
    Map<String, dynamic>? body;
    try {
      body = await HttpHelper.invokeHttp(
          Uri.parse(
              "http://192.168.1.7:3002/api/user/update"),
          RequestType.post,
          headers: null,
          body: const JsonEncoder()
              .convert(updateFullNameAccountInfoRequest.toBodyRequest()));
    } catch (error) {
      debugPrint("Fail to update full name account info $error");
      rethrow;
    }
    if (body == null) return UpdateAccountInfoResponse.buildDefault();
    updateAccountInfoResponse = UpdateAccountInfoResponse.fromJson(body);
    if (updateAccountInfoResponse.code != 0) {
      setState(() {
        isLoading = false;
        if (isLoading) {
          IsShowDialog().showLoadingDialog(context);
        } else {
          Navigator.of(context).pop();
        }
        Fluttertoast.showToast(
            msg: "Cập nhật tên không thành công!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 5,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16);
        debugPrint(updateAccountInfoResponse.message);
      });
    } else {
      setState(() {
        isLoading = false;
        if (isLoading) {
          IsShowDialog().showLoadingDialog(context);
        } else {
          Navigator.of(context).pop();
          Fluttertoast.showToast(
              msg: "Cập nhật tên thành công",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 5,
              backgroundColor: Colors.orange,
              textColor: Colors.black,
              fontSize: 16);
          getAccountInfo();

        }
      });
    }
    return updateAccountInfoResponse;
  }


  /// account info
  Future<AccountInfoResponse> getAccountInfo() async {
    AccountInfoResponse accountInfoResponse;
    Map<String, dynamic>? body;
    try {
      body = await HttpHelper.invokeHttp(
          Uri.parse("http://192.168.1.7:3002/api/user"),
          RequestType.get,
          headers: null,
          body: null);
    } catch (error) {
      debugPrint("Fail to get account info $error");
      rethrow;
    }
    if (body == null) return AccountInfoResponse.buildDefault();
    //get data from api here
    accountInfoResponse = AccountInfoResponse.fromJson(body);
    if(accountInfoResponse.code == 0){
     setState(() {
       Global.accountInfo = accountInfoResponse.accountInfo[0];
       debugPrint("Get Account Info successfully");
       debugPrint(Global.accountInfo.toString());
       Navigator.pushNamedAndRemoveUntil(context,
           AccountInfoScreen.routeName,(Route<dynamic> route) => false);
     });

    }else{
      Fluttertoast.showToast(
          msg: "Lỗi server",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.orange,
          textColor: Colors.black,
          fontSize: 16);
      debugPrint(accountInfoResponse.message);

    }
    return accountInfoResponse;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: const Text(
          'Thông tin tài khoản',
          style: TextStyle(
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
                if(fullName.isNotEmpty){
                  UpdateFullNameAccountInfoRequest updateFullNameAccountRequest = UpdateFullNameAccountInfoRequest(fullName);
                  updateFullNameAccountInfoApi(updateFullNameAccountRequest);
                }else{
                  Fluttertoast.showToast(
                      msg: "Vui lòng điền tên bạn muốn đổi!",
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
                'Cập nhật',
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
        padding: const EdgeInsets.fromLTRB(20,100,20,0),
        child: Column(
          children: [
            const Text('Nhập tên bạn muốn đổi',
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
            textFieldFullName(),
          ],
        ),
      ),
    ));
  }

  Widget textFieldFullName() {
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
        controller: fullNameController,
        keyboardType: TextInputType.text,
        cursorColor: Colors.grey,
        decoration: InputDecoration(
            isDense: true,
            hintText: 'Tên của bạn',
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
            suffixIcon: (fullNameController.text.isEmpty)
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
            fullName = value;
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
