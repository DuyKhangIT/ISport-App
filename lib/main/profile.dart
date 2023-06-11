import 'package:flutter/material.dart';
import 'package:isport_app/main/about_us.dart';
import 'package:isport_app/main/list_user.dart';
import 'package:isport_app/main/review.dart';
import 'package:isport_app/onboarding/login.dart';
import 'package:isport_app/widget/button_next.dart';

import '../assets/icons_assets.dart';
import '../assets/images_assets.dart';
import '../until/share_preferences.dart';

class ProfileScreen extends StatefulWidget {
  static String routeName = "/profile";

  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          /// account user
          GestureDetector(
            onTap: (){},
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 100,
              margin: const EdgeInsets.only(bottom: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  /// avt
                  SizedBox(
                    width: 100,
                    height: 100,
                    child: ClipOval(child: Image.asset(ImageAssets.imgMeo)),
                  ),

                  /// full name and id
                  Container(
                    width: MediaQuery.of(context).size.width / 2.4,
                    height: 60,
                    margin: const EdgeInsets.only(left: 20,right: 5),
                    alignment: Alignment.centerLeft,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Thức',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontFamily: 'Nunito Sans',
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Colors.black),
                        ),
                        Text(
                          'ID: 112233',
                          style: TextStyle(
                              fontFamily: 'Nunito Sans',
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Colors.black),
                        ),
                      ],
                    ),
                  ),

                  const Icon(Icons.arrow_forward_ios_outlined)
                ],
              ),
            ),
          ),

          /// user info
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                ListUserScreen.routeName,
              );
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 70,
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              color: const Color(0xFFFFCC99),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                      width: 30,
                      height: 30,
                      child: Image.asset(IconsAssets.icUserInfo)),
                  Container(
                    constraints: const BoxConstraints(minWidth: 180),
                    child: const Text(
                      'Thông tin người dùng',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontFamily: 'Nunito Sans',
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios_outlined)
                ],
              ),
            ),
          ),

          /// about us
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                AboutUsScreen.routeName,
              );
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 70,
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              color: const Color(0xFFFFCC99),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                      width: 32,
                      height: 32,
                      child: Image.asset(IconsAssets.icAboutUs)),
                  Container(
                    constraints: const BoxConstraints(minWidth: 180),
                    child: const Text(
                      'Về chúng tôi',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontFamily: 'Nunito Sans',
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios_outlined)
                ],
              ),
            ),
          ),

          /// review
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                ReviewScreen.routeName,
              );
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 70,
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              color: const Color(0xFFFFCC99),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                      width: 30,
                      height: 30,
                      child: Image.asset(IconsAssets.icReview)),
                  Container(
                    constraints: const BoxConstraints(minWidth: 180),
                    child: const Text(
                      'Đánh giá',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontFamily: 'Nunito Sans',
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios_outlined)
                ],
              ),
            ),
          ),

          /// logout
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 40, 30, 0),
            child: ButtonNext(
              onTap: () {
                ConfigSharedPreferences()
                    .setStringValue(SharedData.TOKEN.toString(), "");
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  LoginScreen.routeName,
                  (Route<dynamic> route) => false,
                );
              },
              textInside: "Đăng xuất".toUpperCase(),
              color: Colors.orange,
            ),
          )
        ],
      ),
    )));
  }
}
