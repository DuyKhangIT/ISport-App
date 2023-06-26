import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:isport_app/model/add_device/add_device_request.dart';
import 'package:isport_app/model/add_device/add_device_response.dart';
import 'package:numberpicker/numberpicker.dart';

import '../assets/icons_assets.dart';
import '../handle_api/handle_api.dart';
import '../model/list_device_user/list_device_user_response.dart';
import '../until/global.dart';
import '../until/show_loading_dialog.dart';
import '../widget/button_next.dart';
import 'list_user.dart';

class AddDeviceScreen extends StatefulWidget {
  static String routeName = "/add_device_screen";
  const AddDeviceScreen({Key? key}) : super(key: key);

  @override
  State<AddDeviceScreen> createState() => _AddDeviceScreenState();
}

class _AddDeviceScreenState extends State<AddDeviceScreen> {
  Color? colorFemaleGender;
  Color? colorMaleGender;
  File? avatar;
  String filePath = "";
  TextEditingController nickNameController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  String nickName = "";
  String fullName = "";
  String gender = "";
  String height = "";
  String weight = "";
  bool isLoading = false;
  int age =0 ;

  void clearTextNickName() {
    nickName = "";
    nickNameController.clear();
  }

  void clearTextFullName() {
    fullName = "";
    fullNameController.clear();
  }


  void clearTextHeight() {
    height = "";
    heightController.clear();
  }

  void clearTextWeight() {
    weight = "";
    weightController.clear();
  }


  /// call api add device
  Future<AddDeviceResponse> addDeviceApi(
      AddDeviceRequest addDeviceRequest) async {
    setState(() {
      isLoading = true;
      if (isLoading) {
        IsShowDialog().showLoadingDialog(context);
      } else {
        Navigator.of(context).pop();
      }
    });
    AddDeviceResponse addDeviceResponse;
    Map<String, dynamic>? body;
    try {
      body = await HttpHelper.invokeHttp(
          Uri.parse("http://192.168.1.7:3002/api/device"), RequestType.post,
          headers: null,
          body: const JsonEncoder().convert(addDeviceRequest.toBodyRequest()));
    } catch (error) {
      debugPrint("Fail to add device $error");
      rethrow;
    }
    if (body == null) return AddDeviceResponse.buildDefault();
    addDeviceResponse = AddDeviceResponse.fromJson(body);
    if (addDeviceResponse.code != 0) {
      setState(() {
        isLoading = false;
        if (isLoading) {
          IsShowDialog().showLoadingDialog(context);
        } else {
          Navigator.of(context).pop();
        }
        Fluttertoast.showToast(
            msg: "Thêm thiết bị không thành công!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 3,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16);
        debugPrint(addDeviceResponse.message);
      });
    } else {
      setState(() {
        isLoading = false;
        if (isLoading) {
          IsShowDialog().showLoadingDialog(context);
        } else {
          Navigator.of(context).pop();
          Fluttertoast.showToast(
              msg: "Thêm thiết bị thành công",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 3,
              backgroundColor: Colors.orange,
              textColor: Colors.black,
              fontSize: 16);
          getListDeviceUSer();
        }
      });
    }
    return addDeviceResponse;
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
        backgroundColor: Colors.transparent,
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ListUserScreen()),
            );
          },
          child: const Icon(Icons.arrow_back_ios_rounded, color: Colors.black),
        ),
        title: const Text(
          'Thêm thiết bị',
          style: TextStyle(
              fontFamily: 'Nunito Sans',
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black),
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              /// full name
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.only(top: 20),
                child: const Text('Nhập tên của bạn(*)',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Nunito Sans',
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.left),
              ),
              textFieldFullName(),
              /// nick name
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.only(top: 20),
                child: const Text('Nhập biệt danh của bạn',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Nunito Sans',
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.left),
              ),
              textFieldNickName(),
              /// age
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.only(top: 20),
                child: const Text('Chọn tuổi của bạn(*)',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Nunito Sans',
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.left),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.fromLTRB(20,20,20,0),
                child: NumberPicker(
                  axis: Axis.horizontal,
                  selectedTextStyle: const TextStyle(
                      fontSize: 20,
                      fontFamily: 'Nunito Sans',
                      fontWeight: FontWeight.bold,
                      color: Colors.orangeAccent
                  ),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontFamily: 'Nunito Sans',
                    fontWeight: FontWeight.bold,
                  ),
                  value: age,
                  minValue: 0,
                  maxValue: 100,
                  onChanged: (value) {
                    setState(() {
                      age = value;
                      debugPrint(age.toString());
                    });
                  },
                ),
              ),
              /// gender
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.only(top: 20),
                child: const Text('Chọn giới tính của bạn(*)',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Nunito Sans',
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.left),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.fromLTRB(20,20,20,0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    /// male gender
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          colorMaleGender = Colors.orangeAccent;
                          if (colorMaleGender != null) {
                            gender = "Nam";
                            debugPrint(gender);
                            colorFemaleGender = null;
                          }
                        });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            padding: const EdgeInsets.all(18),
                            margin: const EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                                color: colorMaleGender ??
                                    Colors.grey.withOpacity(0.6),
                                shape: BoxShape.circle),
                            child: Image.asset(
                              IconsAssets.icMaleGender,
                              color: Colors.white,
                            ),
                          ),
                          Text('Nam',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Nunito Sans',
                                  fontWeight: FontWeight.bold,
                                  color: colorMaleGender ?? Colors.white54)),
                        ],
                      ),
                    ),
                    /// female gender
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          colorFemaleGender = Colors.orangeAccent;
                          if (colorFemaleGender != null) {
                            gender = "Nữ";
                            debugPrint(gender);
                            colorMaleGender = null;
                          }
                        });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                                color: colorFemaleGender ??
                                    Colors.grey.withOpacity(0.6),
                                shape: BoxShape.circle),
                            child: Image.asset(
                              IconsAssets.icFemaleGender,
                              color: Colors.white,
                            ),
                          ),
                          Text('Nữ',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Nunito Sans',
                                  fontWeight: FontWeight.bold,
                                  color: colorFemaleGender ?? Colors.white54)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              /// height
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.only(top: 20),
                child: const Text('Nhập chiều cao của bạn(Cm)(*)',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Nunito Sans',
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.left),
              ),
              textFieldHeight(),
              /// weight
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.only(top: 20),
                child: const Text('Nhập cân nặng của bạn(Kg)(*)',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Nunito Sans',
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.left),
              ),
              textFieldWeight(),
              /// button add
              Padding(
                  padding: const EdgeInsets.only(top: 40,left: 20,right: 20,bottom: 20),
                  child: ButtonNext(
                    onTap: () {
                      if (Global.isAvailableToClick()) {
                          if (fullName.isNotEmpty &&
                              gender.isNotEmpty &&
                              age != 0 &&
                              weight.isNotEmpty &&
                              height.isNotEmpty) {
                              AddDeviceRequest addDeviceRequest =
                              AddDeviceRequest(
                                  fullName,
                                  gender,
                                  age,
                                  int.parse(weight),
                                  int.parse(height),
                                  "2023-06-26",
                                  "13:57",
                                  nickName);
                              addDeviceApi(addDeviceRequest);
                          } else {
                            Fluttertoast.showToast(
                                msg: "Vui lòng điền đầy đủ những thông tin có dấu (*)",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 5,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16);
                          }
                      }
                    },
                    textInside: "Thêm",
                    color: Colors.orange,
                  ))
            ],
          ),
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
      margin: const EdgeInsets.only(top: 10),
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

  Widget textFieldNickName() {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(6),
      ),
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.only(left: 16, right: 10),
      child: TextField(
        controller: nickNameController,
        keyboardType: TextInputType.text,
        cursorColor: Colors.grey,
        decoration: InputDecoration(
            isDense: true,
            hintText: 'Biệt danh của bạn',
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
            suffixIcon: (nickNameController.text.isEmpty)
                ? const SizedBox()
                : GestureDetector(
                    onTap: () {
                      clearTextNickName();
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
            nickName = value;
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

  Widget textFieldHeight() {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(6),
      ),
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.only(left: 16, right: 10),
      child: TextField(
        controller: heightController,
        keyboardType: TextInputType.number,
        cursorColor: Colors.grey,
        decoration: InputDecoration(
            isDense: true,
            hintText: 'Chiều cao của bạn',
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
            suffixIcon: (heightController.text.isEmpty)
                ? const SizedBox()
                : GestureDetector(
                    onTap: () {
                      clearTextHeight();
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
            height = value;
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

  Widget textFieldWeight() {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(6),
      ),
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.only(left: 16, right: 10),
      child: TextField(
        controller: weightController,
        keyboardType: TextInputType.number,
        cursorColor: Colors.grey,
        decoration: InputDecoration(
            isDense: true,
            hintText: 'Cân nặng của bạn',
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
            suffixIcon: (weightController.text.isEmpty)
                ? const SizedBox()
                : GestureDetector(
                    onTap: () {
                      clearTextWeight();
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
            weight = value;
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
