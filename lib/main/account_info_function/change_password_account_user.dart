import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:isport_app/model/update_account_info/update_account_info_request/update_password_device_info_request.dart';

import '../../handle_api/handle_api.dart';
import '../../model/account_info/account_info_response.dart';
import '../../model/update_account_info/update_account_info_response.dart';
import '../../until/global.dart';
import '../../until/show_loading_dialog.dart';
import '../account_info.dart';

class ChangePasswordAccountUserScreen extends StatefulWidget {
  static String routeName = "/change_password_account_user_screen";
  const ChangePasswordAccountUserScreen({Key? key}) : super(key: key);

  @override
  State<ChangePasswordAccountUserScreen> createState() =>
      _ChangePasswordAccountUserScreenState();
}

class _ChangePasswordAccountUserScreenState
    extends State<ChangePasswordAccountUserScreen> {
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmNewPasswordController = TextEditingController();
  String oldPassword = "";
  String newPassword = "";
  String confirmNewPassword = "";
  bool isShowOldPassword = false;
  bool isShowNewPassword = false;
  bool isShowConfirmNewPassword = false;
  bool isLoading = false;

  /// call api update device
  Future<UpdateAccountInfoResponse> updatePasswordAccountInfoApi(
      UpdatePasswordAccountInfoRequest updatePasswordAccountInfoRequest) async {
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
          Uri.parse("http://192.168.1.8:3002/api/user/update"),
          RequestType.post,
          headers: null,
          body: const JsonEncoder()
              .convert(updatePasswordAccountInfoRequest.toBodyRequest()));
    } catch (error) {
      debugPrint("Fail to update password account info $error");
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
            msg: "${updateAccountInfoResponse.message}!",
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
              msg: "Cập nhật mật khẩu thành công",
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
          Uri.parse("http://192.168.1.8:3002/api/user"), RequestType.get,
          headers: null, body: null);
    } catch (error) {
      debugPrint("Fail to get account info $error");
      rethrow;
    }
    if (body == null) return AccountInfoResponse.buildDefault();
    //get data from api here
    accountInfoResponse = AccountInfoResponse.fromJson(body);
    if (accountInfoResponse.code == 0) {
      setState(() {
        Global.accountInfo = accountInfoResponse.accountInfo[0];
        debugPrint("Get Account Info successfully");
        debugPrint(Global.accountInfo.toString());
        Navigator.pushNamedAndRemoveUntil(context, AccountInfoScreen.routeName,
            (Route<dynamic> route) => false);
      });
    } else {
      Fluttertoast.showToast(
          msg: "Lỗi server",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
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
            onTap: () {
              if (Global.isAvailableToClick()) {
                if (newPassword.isNotEmpty && oldPassword.isNotEmpty && confirmNewPassword.isNotEmpty) {
                  UpdatePasswordAccountInfoRequest
                      updatePasswordAccountInfoRequest =
                      UpdatePasswordAccountInfoRequest(
                          newPassword, oldPassword);
                  updatePasswordAccountInfoApi(
                      updatePasswordAccountInfoRequest);
                }else{
                  Fluttertoast.showToast(
                      msg: "Vui lòng nhập đủ thông tin!",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
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
        padding: const EdgeInsets.fromLTRB(20, 100, 20, 0),
        child: Column(
          children: [
            const Text('Đổi mật khẩu',
                style: TextStyle(
                  fontSize: 26,
                  fontFamily: 'Nunito Sans',
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center),
            const SizedBox(
              height: 30,
            ),

            /// text field
            oldPasswordTextField(),
            passwordTextField(),
            confirmPasswordTextField(),
          ],
        ),
      ),
    ));
  }

  /// text field password sign up
  Widget oldPasswordTextField() {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(6),
      ),
      margin: const EdgeInsets.only(bottom: 30),
      padding: const EdgeInsets.only(left: 16, right: 10),
      child: TextField(
        obscureText: !isShowOldPassword,
        controller: oldPasswordController,
        keyboardType: TextInputType.text,
        cursorColor: Colors.grey,
        decoration: InputDecoration(
          hintText: 'Mật khẩu cũ',
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
          suffixIcon: SizedBox(
            width: 50,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  isShowOldPassword = !isShowOldPassword;
                });
              },
              child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: (isShowOldPassword == true)
                      ? const Icon(Icons.visibility, color: Colors.black)
                      : Icon(
                          Icons.visibility_off,
                          color: Colors.black.withOpacity(0.4),
                        )),
            ),
          ),
        ),
        onChanged: (value) {
          setState(() {
            oldPassword = value;
          });
        },
        style: const TextStyle(
            color: Colors.black,
            fontFamily: 'NunitoSans',
            fontSize: 14,
            fontWeight: FontWeight.w400,
            height: 1.9),
      ),
    );
  }

  /// text field password sign up
  Widget passwordTextField() {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(6),
      ),
      margin: const EdgeInsets.only(bottom: 30),
      padding: const EdgeInsets.only(left: 16, right: 10),
      child: TextField(
        obscureText: !isShowNewPassword,
        controller: newPasswordController,
        keyboardType: TextInputType.text,
        cursorColor: Colors.grey,
        decoration: InputDecoration(
          hintText: 'Mật khẩu mới',
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
          suffixIcon: SizedBox(
            width: 50,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  isShowNewPassword = !isShowNewPassword;
                });
              },
              child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: (isShowNewPassword == true)
                      ? const Icon(Icons.visibility, color: Colors.black)
                      : Icon(
                          Icons.visibility_off,
                          color: Colors.black.withOpacity(0.4),
                        )),
            ),
          ),
        ),
        onChanged: (value) {
          setState(() {
            newPassword = value;
          });
        },
        style: const TextStyle(
            color: Colors.black,
            fontFamily: 'NunitoSans',
            fontSize: 14,
            fontWeight: FontWeight.w400,
            height: 1.9),
      ),
    );
  }

  /// text field confirm password sign up
  Widget confirmPasswordTextField() {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(6),
      ),
      margin: const EdgeInsets.only(bottom: 30),
      padding: const EdgeInsets.only(left: 16, right: 10),
      child: TextField(
        obscureText: !isShowConfirmNewPassword,
        controller: confirmNewPasswordController,
        keyboardType: TextInputType.text,
        cursorColor: Colors.grey,
        decoration: InputDecoration(
          hintText: 'Xác nhận mật khẩu mới',
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
          suffixIcon: SizedBox(
            width: 50,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  isShowConfirmNewPassword = !isShowConfirmNewPassword;
                });
              },
              child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: (isShowConfirmNewPassword == true)
                      ? const Icon(
                          Icons.visibility,
                          color: Colors.black,
                        )
                      : Icon(
                          Icons.visibility_off,
                          color: Colors.black.withOpacity(0.4),
                        )),
            ),
          ),
        ),
        onChanged: (value) {
          setState(() {
            confirmNewPassword = value;
          });
        },
        style: const TextStyle(
            color: Colors.black,
            fontFamily: 'NunitoSans',
            fontSize: 14,
            fontWeight: FontWeight.w400,
            height: 1.9),
      ),
    );
  }
}
