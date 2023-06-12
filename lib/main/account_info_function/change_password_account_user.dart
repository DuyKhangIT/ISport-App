import 'package:flutter/material.dart';

class ChangePasswordAccountUserScreen extends StatefulWidget {
  static String routeName = "/change_password_account_user_screen";
  const ChangePasswordAccountUserScreen({Key? key}) : super(key: key);

  @override
  State<ChangePasswordAccountUserScreen> createState() => _ChangePasswordAccountUserScreenState();
}

class _ChangePasswordAccountUserScreenState extends State<ChangePasswordAccountUserScreen> {
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmNewPasswordController = TextEditingController();
  String oldPassword = "";
  String newPassword = "";
  String confirmNewPassword = "";
  bool isShowOldPassword = false;
  bool isShowNewPassword = false;
  bool isShowConfirmNewPassword = false;
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
              Container(
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
            ],
            elevation: 0,
          ),
          body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            padding: const EdgeInsets.fromLTRB(20,100,20,0),
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
                      :  Icon(
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
                      :  Icon(
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
                      ? const Icon(Icons.visibility,color: Colors.black,)
                      :  Icon(
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
