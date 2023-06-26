import 'package:flutter/material.dart';
import 'package:isport_app/main/account_info_function/avatar_account_user.dart';

import '../assets/images_assets.dart';
import '../until/global.dart';

import 'account_info_function/change_password_account_user.dart';
import 'account_info_function/input_full_name_account_user.dart';
import 'navigation_bar.dart';

class AccountInfoScreen extends StatefulWidget {
  static String routeName = "/account_info";
  const AccountInfoScreen({Key? key}) : super(key: key);

  @override
  State<AccountInfoScreen> createState() => _AccountInfoScreenState();
}

class _AccountInfoScreenState extends State<AccountInfoScreen> {
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
              MaterialPageRoute(
                  builder: (context) => NavigationBarScreen(currentIndex: 1)),
            );
          },
          child: const Icon(Icons.arrow_back_ios_rounded, color: Colors.black),
        ),
        title: const Text(
          'Thông tin tài khoản',
          style: TextStyle(
              fontFamily: 'Nunito Sans',
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black),
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        child: Column(
          children: [
            /// avt
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  AvatarAccountUserScreen.routeName,
                );
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 70,
                color: const Color(0xFFFFCC99),
                margin: const EdgeInsets.only(bottom: 20),
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
                              child: Global.accountInfo!.avt.isNotEmpty
                                  ? Image.network(
                                      Global.convertMedia(
                                          Global.accountInfo!.avt),
                                      fit: BoxFit.cover, errorBuilder:
                                          (context, exception, stackTrace) {
                                      return Image.asset(
                                          ImageAssets.imgAvtDefault,
                                          fit: BoxFit.cover);
                                    })
                                  : Image.asset(
                                  ImageAssets.imgAvtDefault,
                                  fit: BoxFit.cover),
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

            /// full name
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  InputFullNameAccountUserScreen.routeName,
                );
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 70,
                color: const Color(0xFFFFCC99),
                margin: const EdgeInsets.only(bottom: 20),
                padding: const EdgeInsets.only(left: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Tên',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontFamily: 'Nunito Sans',
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                    ),
                    Container(
                      constraints: const BoxConstraints(maxWidth: 220),
                      margin: const EdgeInsets.only(right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            constraints: const BoxConstraints(maxWidth: 180),
                            alignment: Alignment.centerRight,
                            child: Text(
                              Global.accountInfo!.fullName.isNotEmpty
                                  ? Global.accountInfo!.fullName
                                  : "",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontFamily: 'Nunito Sans',
                                  fontSize: 18,
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

            /// password account
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  ChangePasswordAccountUserScreen.routeName,
                );
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 70,
                color: const Color(0xFFFFCC99),
                padding: const EdgeInsets.only(left: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Mật khẩu',
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
                              '*****',
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
          ],
        ),
      ),
    ));
  }
}
