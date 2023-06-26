import 'package:flutter/material.dart';
import 'package:isport_app/assets/assets.dart';
import 'package:isport_app/main/add_device.dart';
import 'package:isport_app/main/info_user.dart';
import 'package:isport_app/main/navigation_bar.dart';
import 'package:isport_app/widget/button_next.dart';

import '../until/global.dart';

class ListUserScreen extends StatefulWidget {
  static String routeName = "/list_user_screen";
  const ListUserScreen({Key? key}) : super(key: key);

  @override
  State<ListUserScreen> createState() => _ListUserScreenState();
}

class _ListUserScreenState extends State<ListUserScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      appBar: AppBar(
        backgroundColor: Color(Global.primaryColor),
        centerTitle: true,
        leading: GestureDetector(
          onTap: (){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NavigationBarScreen(currentIndex: 1)),
            );
          },
          child: const Icon(
              Icons.arrow_back_ios_rounded,
              color: Colors.black
          ),
        ),
        title: const Text(
          'Danh sách các thiết bị',
          style: TextStyle(
              fontFamily: 'Nunito Sans',
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black),
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(30,20,30,100),
        child:
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: ListView.builder(
                  itemCount:  Global.listDeviceUser.length,
                  itemBuilder: (context,index){
                return contentListUser(index);
              }),
            ),

            Padding(
                padding: const EdgeInsets.fromLTRB(20,20,20,0),
                child: ButtonNext(onTap: (){
                  Navigator.pushNamed(
                    context,
                    AddDeviceScreen.routeName,
                  );
                },textInside: "Thêm thiết bị",color: Colors.orange,))
          ],
        ),
      ),
    ));
  }
  Widget contentListUser(index){
    return GestureDetector(
      onTap: (){
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => InfoUserScreen(
                dataDeviceUser: Global.listDeviceUser[index],
              )),
        );
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 65,
        color: const Color(0xFFFFCC99),
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.only(left: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              Global.listDeviceUser[index].name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
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
                      child:
                      Global.listDeviceUser[index].avt.isNotEmpty
                      ?Image.network(Global.convertMedia(Global.listDeviceUser[index].avt),fit: BoxFit.cover,
                        errorBuilder: (context, exception, stackTrace) {
                          return Image.asset(
                              ImageAssets.imgAvtDefault,
                              fit: BoxFit.cover);
                        })
                      :Image.asset(
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
    );
  }
}
