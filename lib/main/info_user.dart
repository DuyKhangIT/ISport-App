import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:isport_app/main/list_user.dart';
import 'package:isport_app/main/user_info_function/choose_gender.dart';
import 'package:isport_app/main/user_info_function/input_nick_name.dart';
import 'package:isport_app/main/user_info_function/select_age.dart';
import 'package:isport_app/main/user_info_function/select_height.dart';
import 'package:isport_app/main/user_info_function/select_weight.dart';
import 'package:isport_app/model/delete_device/delete_device_response.dart';
import 'package:isport_app/widget/button_next.dart';

import '../assets/images_assets.dart';
import '../handle_api/handle_api.dart';
import '../model/list_device_user/data_list_device_user_response.dart';
import '../model/list_device_user/list_device_user_response.dart';
import '../until/global.dart';
import 'user_info_function/avatar_user.dart';

class InfoUserScreen extends StatefulWidget {
  final DataListDeviceUserResponse? dataDeviceUser;
  static String routeName = "/info_user_screen";
  const InfoUserScreen({Key? key, required this.dataDeviceUser}) : super(key: key);

  @override
  State<InfoUserScreen> createState() => _InfoUserScreenState();
}

class _InfoUserScreenState extends State<InfoUserScreen> {

  /// list delete device
  Future<DeleteDeviceResponse> deleteDevice() async {
    DeleteDeviceResponse deleteDeviceResponse;
    Map<String, dynamic>? body;
    try {
      body = await HttpHelper.invokeHttp(
          Uri.parse("http://192.168.1.7:3002/api/device?iddevice=${widget.dataDeviceUser!.idDevice}"),
          RequestType.delete,
          headers: null,
          body: null);
    } catch (error) {
      debugPrint("Fail to delete device $error");
      rethrow;
    }
    if (body == null) return DeleteDeviceResponse.buildDefault();
    //get data from api here
    deleteDeviceResponse = DeleteDeviceResponse.fromJson(body);
    if(deleteDeviceResponse.code == 0){
     setState(() {
       getListDeviceUSer();
       debugPrint("get list data of device successfully");
     });

    }else{
      debugPrint(deleteDeviceResponse.message);
    }
    return deleteDeviceResponse;
  }

  /// list device user
  Future<ListDeviceUserResponse> getListDeviceUSer() async {
    ListDeviceUserResponse listDeviceUserResponse;
    Map<String, dynamic>? body;
    try {
      body = await HttpHelper.invokeHttp(
          Uri.parse("http://192.168.1.7:3002/api/user/devices"),
          RequestType.get,
          headers: null,
          body: null);
    } catch (error) {
      debugPrint("Fail to list device user $error");
      rethrow;
    }
    if (body == null) return ListDeviceUserResponse.buildDefault();
    //get data from api here
    listDeviceUserResponse = ListDeviceUserResponse.fromJson(body);
    if(listDeviceUserResponse.code == 0){
      setState(() {
        Global.listDeviceUser = listDeviceUserResponse.listDataDeviceUser;
        debugPrint("Get list device successfully");
        Navigator.pushNamedAndRemoveUntil(
            context, ListUserScreen.routeName, (Route<dynamic> route) => false);
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
      debugPrint(listDeviceUserResponse.message);
    }
    return listDeviceUserResponse;
  }

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
        title:  Text(
          widget.dataDeviceUser!.name.isNotEmpty ? widget.dataDeviceUser!.name : "Thiết bị 1",
          style: const TextStyle(
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
                    "Mã",
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
                    child:  Text(
                      widget.dataDeviceUser!.idDevice != 0 ? widget.dataDeviceUser!.idDevice.toString(): "0",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontFamily: 'Nunito Sans',
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
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
                              child:
                              widget.dataDeviceUser!.avt.isNotEmpty
                              ?Image.network(Global.convertMedia(widget.dataDeviceUser!.avt),fit: BoxFit.cover,
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
                      "Biệt danh",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontFamily: 'Nunito Sans',
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                    ),
                    Container(
                      constraints: const BoxConstraints(maxWidth: 210),
                      margin: const EdgeInsets.only(right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            constraints: const BoxConstraints(maxWidth: 170),
                            alignment: Alignment.centerRight,
                            child: Text(
                              widget.dataDeviceUser!.nickName.isNotEmpty ? widget.dataDeviceUser!.nickName : "Chưa đặt biệt danh",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontFamily: 'Nunito Sans',
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
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
                            child:  Text(
                              widget.dataDeviceUser!.gender.isNotEmpty ?widget.dataDeviceUser!.gender :"",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontFamily: 'Nunito Sans',
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
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
                            child:  Text(
                              widget.dataDeviceUser!.age != 0 ?  widget.dataDeviceUser!.age.toString() : "0",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontFamily: 'Nunito Sans',
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
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
                            child:  Text(
                              widget.dataDeviceUser!.height != 0 ?  "${widget.dataDeviceUser!.height} Cm" : "0",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontFamily: 'Nunito Sans',
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
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
                            child:  Text(
                              widget.dataDeviceUser!.weight != 0 ?  "${widget.dataDeviceUser!.weight} Kg" : "0",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontFamily: 'Nunito Sans',
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
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
                  onTap: () {
                    deleteDevice();
                  },
                  textInside: "Xóa người dùng",
                  color: Colors.orange,
                ))
          ],
        ),
      ),
    ));
  }
}
