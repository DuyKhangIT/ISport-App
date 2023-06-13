import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:isport_app/onboarding/login.dart';
import 'package:isport_app/widget/button_next.dart';

import '../handle_api/handle_api.dart';
import '../model/register/register_request.dart';
import '../model/register/register_response.dart';
import '../until/global.dart';
import '../until/show_loading_dialog.dart';

class RegisterScreen extends StatefulWidget {
  static String routeName = "/register";
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
  String email = "";
  String phoneNumber = "";
  String password = "";
  String confirmPassword = "";
  String fullName = "";
  bool isShowPassword = false;
  bool isShowConfirmPassword = false;
  bool isLoading = false;

  /// call api register
  Future<RegisterResponse> registerApi(RegisterRequest registerRequest) async {
    setState(() {
      isLoading = true;
      if (isLoading) {
        IsShowDialog().showLoadingDialog(context);
      } else {
        Navigator.of(context).pop();
      }
    });
    RegisterResponse registerResponse;
    Map<String, dynamic>? body;
    try {
      body = await HttpHelper.invokeHttp(
          Uri.parse(
              "http://192.168.1.10:3002/api/register"),
          RequestType.post,
          headers: null,
          body: const JsonEncoder().convert(registerRequest.toBodyRequest()));
    } catch (error) {
      debugPrint("Fail to register $error");
      rethrow;
    }
    if (body == null) return RegisterResponse.buildDefault();
    registerResponse = RegisterResponse.fromJson(body);
    if (registerResponse.code != 0) {
      setState(() {
        isLoading = false;
        if (isLoading) {
          IsShowDialog().showLoadingDialog(context);
        } else {
          Navigator.of(context).pop();
        }
        Fluttertoast.showToast(
            msg: "Đăng kí không thành công!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 3,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16);
      });
    } else {
      setState(() {
        isLoading = false;
        if (isLoading) {
          IsShowDialog().showLoadingDialog(context);
        } else {
          Navigator.of(context).pop();
          Fluttertoast.showToast(
              msg: "Đăng ký thành công",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 3,
              backgroundColor: Colors.orange,
              textColor: Colors.black,
              fontSize: 16);
          Navigator.pushNamedAndRemoveUntil(
              context, LoginScreen.routeName, (Route<dynamic> route) => false);
        }
      });
    }
    return registerResponse;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.fromLTRB(30, 60, 30, 0),
              child: Column(
                children: [
                  const Text('Tạo tài khoản',
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          height: 1.5)),
                  const SizedBox(height: 20),
                  const Text(
                    'Chào mừng bạn đến với ISport',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  registerForm()
                ],
              ),
            ),
          ),
        ));
  }

  Widget registerForm(){
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 30, 10, 0),
      child: Column(
        children: [
          emailTextField(),
          phoneNumberTextField(),
          passwordTextField(),
          confirmPasswordTextField(),
          fullNameTextField(),

          /// button
          ButtonNext(onTap: (){
            setState(() {
              if (Global.isAvailableToClick()) {
                RegisterRequest registerRequest = RegisterRequest(email, phoneNumber,password,fullName);
                if (emailController.text.isNotEmpty &&
                    passwordController.text.isNotEmpty &&
                    confirmController.text.isNotEmpty && fullNameController.text.isNotEmpty) {
                  if (Global().checkEmailAddress(email) == true) {
                    if (passwordController.text == confirmController.text) {
                      registerApi(registerRequest);
                    } else {
                      Fluttertoast.showToast(
                          msg:
                          "Mật khẩu xác nhận chưa trùng với mật khẩu của bạn  ",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 3,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16);
                    }
                  } else {
                    Fluttertoast.showToast(
                        msg: "Định dạng email không hợp lệ. Vui lòng nhập lại",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 3,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16);
                  }
                } else {
                  Fluttertoast.showToast(
                      msg: "Vui lòng nhập đủ thông tin",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 3,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16);
                }
              }
            });

          },textInside: "Tạo tài khoản",  color: const Color(0xFFDEB887)),

          /// login
          Padding(
            padding: const EdgeInsets.only(top: 40),
            child: RichText(
                text: TextSpan(children: [
                  TextSpan(
                      text: 'Đã có tải khoản?',
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Nunito Sans',
                          color: Theme.of(context).brightness ==
                              Brightness.dark
                              ? Colors.white
                              : Colors.black)),
                  const TextSpan(text: " "),
                  TextSpan(
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.pushNamed(
                            context,
                            LoginScreen.routeName,
                          );
                        },
                      text: 'Đăng nhập.',
                      style: const TextStyle(
                          decoration: TextDecoration.underline,
                          fontSize: 16,
                          fontFamily: 'Nunito Sans',
                          fontStyle: FontStyle.italic,
                          color: Colors.blue))
                ])),
          )

        ],
      ),
    );
  }

  /// text field user name
  Widget emailTextField() {
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
        controller: emailController,
        keyboardType: TextInputType.text,
        cursorColor: Colors.grey,
        decoration:  InputDecoration(
            hintText: 'Địa chỉ mail',
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
            suffixIcon: Icon(Icons.email_outlined,color: Colors.black.withOpacity(0.4))),
        onChanged: (value) {
          setState(() {
            email = value;
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

  /// text field phone number
  Widget phoneNumberTextField() {
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
        controller: phoneNumberController,
        keyboardType: TextInputType.phone,
        cursorColor: Colors.grey,
        decoration:  InputDecoration(
            hintText: 'Số điện thoại',
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
            suffixIcon: Icon(Icons.phone,color: Colors.black.withOpacity(0.4))),
        onChanged: (value) {
          setState(() {
            phoneNumber = value;
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
        obscureText: !isShowPassword,
        controller: passwordController,
        keyboardType: TextInputType.text,
        cursorColor: Colors.grey,
        decoration: InputDecoration(
          hintText: 'Mật khẩu',
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
                  isShowPassword = !isShowPassword;
                });
              },
              child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: (isShowPassword == true)
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
            password = value;
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
        obscureText: !isShowConfirmPassword,
        controller: confirmController,
        keyboardType: TextInputType.text,
        cursorColor: Colors.grey,
        decoration: InputDecoration(
          hintText: 'Xác nhận mật khẩu',
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
                  isShowConfirmPassword = !isShowConfirmPassword;
                });
              },
              child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: (isShowConfirmPassword == true)
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
            confirmPassword = value;
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

  /// text field full name
  Widget fullNameTextField() {
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
        controller: fullNameController,
        keyboardType: TextInputType.text,
        cursorColor: Colors.grey,
        decoration: const InputDecoration(
            hintText: 'Họ tên',
            hintStyle: TextStyle(
              fontFamily: 'NunitoSans',
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w400,
              fontSize: 14,
            ),
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            counterText: '',),
        onChanged: (value) {
          setState(() {
            fullName = value;
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
