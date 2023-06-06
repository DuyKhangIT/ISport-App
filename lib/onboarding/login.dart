import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:isport_app/main/home.dart';
import 'package:isport_app/main/navigation_bar.dart';
import 'package:isport_app/onboarding/resgister.dart';

import '../assets/icons_assets.dart';
import '../until/global.dart';
import '../until/module.dart';
import '../widget/button_next.dart';

class LoginScreen extends StatefulWidget {
  static String routeName = "/login";
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController phoneLoginController = TextEditingController();
  TextEditingController passwordLoginController = TextEditingController();
  String phoneLogin = "";
  String passwordLogin = "";
  bool isLoading = false;
  bool isShowPassword = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(child:
    Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          margin: const EdgeInsets.symmetric(horizontal: 30,vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              /// logo
              Container(
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.topLeft,
                  margin: const EdgeInsets.only(bottom: 120),
                  child: const Text("ISport",style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic
                  ))),

              const Text("Đăng nhập",style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold
              )),

              formLogin(),

              Padding(
                padding: const EdgeInsets.fromLTRB(10,0,10,10),
                child: ButtonNext(
                    color: const Color(0xFFDEB887),
                    onTap: () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        NavigationBarScreen.routeName,
                            (Route<dynamic> route) => false,
                      );
                    },
                    textInside: "Đăng nhập"),
              ),

              customDivider(),

              /// register
              Padding(
                padding: const EdgeInsets.fromLTRB(40,0,40,10),
                child: ButtonNext(
                    color: Colors.orange,
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        RegisterScreen.routeName,
                      );
                    },
                    textInside: "Tạo tài khoản"),
              ),

            ],
          ),
        ),
      ),
    ));
  }

  /// form login
  Widget formLogin() {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(vertical: 20,horizontal: 10),
      child: Column(
        children: [
          /// text field phone login
          Container(
            width: double.infinity,
            height: 50,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(6),
            ),
            margin: const EdgeInsets.symmetric(vertical: 15),
            padding: const EdgeInsets.only(left: 16, right: 10),
            child: TextField(
              controller: phoneLoginController,
              keyboardType: TextInputType.text,
              cursorColor: Colors.grey,
              decoration: InputDecoration(
                isDense: true,
                hintText: 'Email hoặc Số điện thoại',
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
                suffixIcon: (phoneLoginController.text.isEmpty)
                    ? const SizedBox()
                    : GestureDetector(
                  onTap: () {
                    //loginController.clearTextPhoneLogin();
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Image.asset(
                        IconsAssets.icClearText,color: Theme.of(context).brightness ==
                        Brightness.dark
                        ? Colors.white
                        : Colors.black
                    ),
                  ),
                )
              ),
              onChanged: (value) {
                setState(() {
                  phoneLogin = value;
                });
              },
              style: TextStyle(
                  color: Theme.of(context).brightness ==
                      Brightness.dark
                      ? Colors.white
                      : Colors.black,
                  fontFamily: 'NunitoSans',
                  fontSize: 14,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w600,
                  height: 1.9),
            ),
          ),

          /// text field password login
          Container(
            width: double.infinity,
            height: 50,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(6),
            ),
            padding: const EdgeInsets.only(left: 16, right: 10),
            child: TextField(
              obscureText: !isShowPassword,
              controller: passwordLoginController,
              keyboardType: TextInputType.text,
              cursorColor: Colors.grey,
              decoration: InputDecoration(
                  isDense: true,
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
                  suffixIcon: (passwordLoginController.text.isEmpty)
                      ? const SizedBox()
                      : GestureDetector(
                    onTap: () {
                      setState(() {
                        isShowPassword =
                        !isShowPassword;
                      });

                    },
                    child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: isShowPassword == true
                            ?  Icon(Icons.visibility, color: Theme.of(context).brightness ==
                            Brightness.dark
                            ? Colors.white
                            : Colors.black)
                            :  Icon(Icons.visibility_off,
                            color: Theme.of(context).brightness ==
                                Brightness.dark
                                ? Colors.white
                                : Colors.black)),
                  )
              ),
              onChanged: (value) {
                setState(() {
                  passwordLogin = value;
                });
              },
              style: TextStyle(
                  color: Theme.of(context).brightness ==
                      Brightness.dark
                      ? Colors.white
                      : Colors.black,
                  fontFamily: 'NunitoSans',
                  fontSize: 14,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w600,
                  height: 1.9),
            ),
          ),

          // /// forgot password
          // GestureDetector(
          //   onTap: () {
          //
          //   },
          //   child: Container(
          //     margin: const EdgeInsets.only(top: 15),
          //     alignment: Alignment.centerRight,
          //     child: const Text(
          //       'Quên mật khẩu?',
          //       style: TextStyle(
          //           fontSize: 14,
          //           fontFamily: 'Nunito Sans',
          //           fontWeight: FontWeight.w700),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  /// divider
  Widget customDivider() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 30),
              child: Divider(thickness: 0.5,color: Theme.of(context).brightness ==
                  Brightness.dark
                  ? Colors.white
                  : Colors.black),
            ),
          ),
          Text(
            'Hoặc'.toUpperCase(),
            style: const TextStyle(fontSize: 12, fontFamily: 'Nunito Sans',fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 30),
              child: Divider(thickness: 0.5,color: Theme.of(context).brightness ==
                  Brightness.dark
                  ? Colors.white
                  : Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
