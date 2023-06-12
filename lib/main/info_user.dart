import 'package:flutter/material.dart';
import 'package:isport_app/main/list_user.dart';
import 'package:isport_app/main/user_info_function/choose_gender.dart';
import 'package:isport_app/main/user_info_function/input_nick_name.dart';
import 'package:isport_app/main/user_info_function/select_age.dart';
import 'package:isport_app/main/user_info_function/select_height.dart';
import 'package:isport_app/main/user_info_function/select_weight.dart';
import 'package:isport_app/widget/button_next.dart';

import '../assets/images_assets.dart';
import '../until/global.dart';
import 'user_info_function/avatar_user.dart';

class InfoUserScreen extends StatefulWidget {
  static String routeName = "/info_user_screen";
  const InfoUserScreen({Key? key}) : super(key: key);

  @override
  State<InfoUserScreen> createState() => _InfoUserScreenState();
}

class _InfoUserScreenState extends State<InfoUserScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: Color(Global.primaryColor),
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ListUserScreen()),
            );
          },
          child: const Icon(
              Icons.arrow_back_ios_rounded,
              color: Colors.black
          ),
        ),
        title: const Text(
          'Người dùng 1',
          style: TextStyle(
              fontFamily: 'Nunito Sans',
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black),
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          children: [
            /// id
            Container(
              width: MediaQuery.of(context).size.width,
              height: 70,
              color: const Color(0xFFFFCC99),
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.only(left: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Mã',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontFamily: 'Nunito Sans',
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  ),
                  Container(
                    constraints: const BoxConstraints(maxWidth: 200),
                    margin: const EdgeInsets.only(right: 20),
                    child: const Text(
                      '1900',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontFamily: 'Nunito Sans',
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                    ),
                  )
                ],
              ),
            ),

            /// avt
            GestureDetector(
              onTap: (){
                Navigator.pushNamed(
                  context,
                  AvatarUserScreen.routeName,
                );
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 70,
                color: const Color(0xFFFFCC99),
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.only(left: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Ảnh đại diện',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontFamily: 'Nunito Sans',
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                    ),
                    Container(
                      width: 90,
                      margin: const EdgeInsets.only(right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 50,
                            height: 50,
                            child: ClipOval(
                              child: Image.asset(ImageAssets.imgMeo),
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios_outlined)
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),

            /// nick name
            GestureDetector(
              onTap: (){
                Navigator.pushNamed(
                  context,
                  InputNickNameScreen.routeName,
                );
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 70,
                color: const Color(0xFFFFCC99),
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.only(left: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Biệt danh',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontFamily: 'Nunito Sans',
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                    ),
                    Container(
                      constraints: const BoxConstraints(maxWidth: 200),
                      margin: const EdgeInsets.only(right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            constraints: const BoxConstraints(maxWidth: 150),
                            alignment: Alignment.centerRight,
                            child: const Text(
                              'Thức',
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
                    )
                  ],
                ),
              ),
            ),

            /// gender
            GestureDetector(
              onTap: (){
                Navigator.pushNamed(
                  context,
                  ChooseGenderScreen.routeName,
                );
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 70,
                color: const Color(0xFFFFCC99),
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.only(left: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Giới tính',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontFamily: 'Nunito Sans',
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                    ),
                    Container(
                      constraints: const BoxConstraints(maxWidth: 150),
                      margin: const EdgeInsets.only(right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            constraints: const BoxConstraints(maxWidth: 100),
                            alignment: Alignment.centerRight,
                            child: const Text(
                              'Nam',
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
                    )
                  ],
                ),
              ),
            ),

            /// Age
            GestureDetector(
              onTap: (){
                Navigator.pushNamed(
                  context,
                  SelectAgeScreen.routeName,
                );
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 70,
                color: const Color(0xFFFFCC99),
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.only(left: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Tuổi',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontFamily: 'Nunito Sans',
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                    ),
                    Container(
                      constraints: const BoxConstraints(maxWidth: 100),
                      margin: const EdgeInsets.only(right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            constraints: const BoxConstraints(maxWidth: 50),
                            alignment: Alignment.centerRight,
                            child: const Text(
                              '220',
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
                    )
                  ],
                ),
              ),
            ),

            /// height
            GestureDetector(
              onTap: (){
                Navigator.pushNamed(
                  context,
                  SelectHeightScreen.routeName,
                );
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 70,
                color: const Color(0xFFFFCC99),
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.only(left: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Chiều cao',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontFamily: 'Nunito Sans',
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                    ),
                    Container(
                      constraints: const BoxConstraints(maxWidth: 150),
                      margin: const EdgeInsets.only(right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            constraints: const BoxConstraints(maxWidth: 100),
                            alignment: Alignment.centerRight,
                            child: const Text(
                              '165 cm',
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
                    )
                  ],
                ),
              ),
            ),

            /// weight
            GestureDetector(
              onTap: (){
                Navigator.pushNamed(
                  context,
                  SelectWeightScreen.routeName,
                );
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 70,
                color: const Color(0xFFFFCC99),
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.only(left: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Cân nặng',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontFamily: 'Nunito Sans',
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                    ),
                    Container(
                      constraints: const BoxConstraints(maxWidth: 150),
                      margin: const EdgeInsets.only(right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            constraints: const BoxConstraints(maxWidth: 100),
                            alignment: Alignment.centerRight,
                            child: const Text(
                              '55 kg',
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
                    )
                  ],
                ),
              ),
            ),

            Padding(
                padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
                child: ButtonNext(
                  onTap: () {},
                  textInside: "Xóa người dùng",
                  color: Colors.orange,
                ))
          ],
        ),
      ),
    ));
  }
}
