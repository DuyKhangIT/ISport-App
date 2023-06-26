import 'dart:convert';
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:isport_app/model/add_device/add_device_request.dart';
import 'package:isport_app/model/add_device/add_device_response.dart';

import '../assets/icons_assets.dart';
import '../handle_api/handle_api.dart';
import '../model/list_device_user/list_device_user_response.dart';
import '../model/upload_media/upload_media_response.dart';
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
  File? avatar;
  String filePath = "";
  TextEditingController nickNameController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  String nickName = "";
  String fullName = "";
  String age = "";
  String gender = "";
  String height = "";
  String weight = "";
  String photoPath = "";
  bool isLoading = false;

  void clearTextNickName() {
    nickName = "";
    nickNameController.clear();
  }

  void clearTextFullName() {
    fullName = "";
    fullNameController.clear();
  }

  void clearTextAge() {
    age = "";
    ageController.clear();
  }

  void clearTextGender() {
    gender = "";
    genderController.clear();
  }

  void clearTextHeight() {
    height = "";
    heightController.clear();
  }

  void clearTextWeight() {
    weight = "";
    weightController.clear();
  }

  /// instantiate our image picker object
  final imagePicker = ImagePicker();

  /// function to get the image from the camera
  Future getImageFromCamera() async {
    final pickedImageFromCam =
        await imagePicker.pickImage(source: ImageSource.camera);
    if (pickedImageFromCam == null) {
      return;
    }
    File? picture = File(pickedImageFromCam.path);
    picture = await cropperImage(imgFile: picture);
    if (picture == null) {
      return;
    }
    avatar = picture;
    String filePaths;
    filePaths = picture.path;
    setState(() {
      filePath = filePaths;
      Navigator.pop(context);
    });
  }

  /// function to get the image from the gallery
  Future getImageFromGallery() async {
    final pickedImageFromGa =
        await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedImageFromGa == null) {
      return;
    }
    File? imgFrame = File(pickedImageFromGa.path);
    imgFrame = await cropperImage(imgFile: imgFrame);
    if (imgFrame == null) {
      return;
    }
    avatar = imgFrame;
    String filePaths;
    filePaths = imgFrame.path;
    setState(() {
      filePath = filePaths;
      Navigator.pop(context);
    });
  }

  /// function to adjustment the image frame
  Future<File?> cropperImage({required File imgFile}) async {
    CroppedFile? cropperImage =
        await ImageCropper().cropImage(sourcePath: imgFile.path);
    if (cropperImage == null) return null;
    return File(cropperImage.path);
  }

  /// upload image api
  Future<UploadMediaResponse> uploadMedia() async {
    UploadMediaResponse uploadMediaResponse;
    Map<String, dynamic>? body;
    try {
      body = await HttpHelper.invokeSingleFile(
          Uri.parse("http://192.168.1.7:3002/api/upload-media"),
          RequestType.post,
          filePath,
          headers: null,
          body: null);
    } catch (error) {
      debugPrint("Fail to upload file ${(error)}");
      rethrow;
    }
    if (body == null) return UploadMediaResponse.buildDefault();
    uploadMediaResponse = UploadMediaResponse.fromJson(body);
    if (uploadMediaResponse.code == 0) {
     setState(() {
       photoPath = uploadMediaResponse.data!;
       debugPrint("Upload Media successfully");
       if (photoPath.isNotEmpty) {
         AddDeviceRequest addDeviceRequest = AddDeviceRequest(
             fullName,
             1,
             gender,
             int.parse(age),
             int.parse(weight),
             int.parse(height),
             "2023-06-26",
             "13:57",
             photoPath,
             nickName);
         addDeviceApi(addDeviceRequest);
       }
     });

    } else {
      debugPrint("Upload Fail: ${uploadMediaResponse.message}");
    }
    return uploadMediaResponse;
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
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              (avatar != null)
                  ? GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            context: context,
                            builder: (context) {
                              return detailBottomSheet();
                            });
                      },
                      child: Stack(
                        children: [
                          Container(
                              width: 120,
                              height: 120,
                              margin: const EdgeInsets.only(top: 20),
                              decoration:
                                  const BoxDecoration(shape: BoxShape.circle),
                              child: ClipOval(
                                child: Image.file(
                                  avatar!,
                                  fit: BoxFit.cover,
                                ),
                              )),
                          Positioned(
                            right: 10,
                            bottom: 0,
                            child: SizedBox(
                              width: 25,
                              height: 25,
                              child: CircleAvatar(
                                  backgroundColor: Colors.orangeAccent,
                                  child: Padding(
                                    padding: const EdgeInsets.all(7.5),
                                    child: Image.asset(IconsAssets.icPen,
                                        height: 16, width: 16),
                                  )),
                            ),
                          )
                        ],
                      ),
                    )
                  : GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            context: context,
                            builder: (context) {
                              return detailBottomSheet();
                            });
                      },
                      child: Container(
                          width: 120,
                          height: 120,
                          margin: const EdgeInsets.only(top: 20),
                          decoration:
                              const BoxDecoration(shape: BoxShape.circle),
                          child: DottedBorder(
                              color: Colors.black.withOpacity(0.5),
                              strokeWidth: 1,
                              borderType: BorderType.Circle,
                              dashPattern: const [6, 5],
                              radius: const Radius.circular(60),
                              child: Center(
                                  child: Image.asset(IconsAssets.icUpload)))),
                    ),

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

              /// text field full name
              textFieldFullName(),
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
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.only(top: 20),
                child: const Text('Nhập tuổi của bạn(*)',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Nunito Sans',
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.left),
              ),
              textFieldAge(),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.only(top: 20),
                child: const Text('Nhập giới tính của bạn(*)',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Nunito Sans',
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.left),
              ),
              textFieldGender(),
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

              Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: ButtonNext(
                    onTap: () {
                      if (Global.isAvailableToClick()) {
                          if (fullName.isNotEmpty &&
                              gender.isNotEmpty &&
                              age.isNotEmpty &&
                              weight.isNotEmpty &&
                              height.isNotEmpty) {
                            if (avatar != null) {
                              uploadMedia();
                            }else{
                              AddDeviceRequest addDeviceRequest =
                              AddDeviceRequest(
                                  fullName,
                                  1,
                                  gender,
                                  int.parse(age),
                                  int.parse(weight),
                                  int.parse(height),
                                  "2023-06-26",
                                  "13:57",
                                  photoPath,
                                  nickName);
                              addDeviceApi(addDeviceRequest);
                            }
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

  Widget textFieldAge() {
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
        controller: ageController,
        keyboardType: TextInputType.number,
        cursorColor: Colors.grey,
        decoration: InputDecoration(
            isDense: true,
            hintText: 'Tuổi của bạn',
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
            suffixIcon: (ageController.text.isEmpty)
                ? const SizedBox()
                : GestureDetector(
                    onTap: () {
                      clearTextAge();
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
            age = value;
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

  Widget textFieldGender() {
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
        controller: genderController,
        keyboardType: TextInputType.text,
        cursorColor: Colors.grey,
        decoration: InputDecoration(
            isDense: true,
            hintText: 'Giới tính của bạn',
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
            suffixIcon: (genderController.text.isEmpty)
                ? const SizedBox()
                : GestureDetector(
                    onTap: () {
                      clearTextGender();
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
            gender = value;
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

  Widget detailBottomSheet() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                color: Colors.transparent,
              )),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.only(left: 31, right: 31, bottom: 26),
          padding: const EdgeInsets.symmetric(horizontal: 15),
          decoration: const BoxDecoration(
            color: Color(0xFFFFCC99),
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              GestureDetector(
                  onTap: () {
                    getImageFromCamera();
                  },
                  child: SizedBox(
                    height: 50,
                    child: Center(
                      child: Text("Chụp ảnh".toUpperCase(),
                          style: const TextStyle(
                              fontFamily: 'Nunito Sans',
                              fontWeight: FontWeight.w500,
                              fontSize: 14)),
                    ),
                  )),
              Divider(
                thickness: 0.5,
                height: 0,
                color: Colors.black.withOpacity(0.1),
              ),
              GestureDetector(
                  onTap: () {
                    getImageFromGallery();
                  },
                  child: SizedBox(
                    height: 50,
                    child: Center(
                      child: Text("Chọn ảnh từ thư viện".toUpperCase(),
                          style: const TextStyle(
                              fontFamily: 'Nunito Sans',
                              fontWeight: FontWeight.w500,
                              fontSize: 14)),
                    ),
                  )),
            ],
          ),
        ),

        /// BUTTON CANCEL
        Padding(
            padding: const EdgeInsets.only(bottom: 34, left: 34, right: 34),
            child: ButtonNext(
              onTap: () {
                Navigator.pop(context);
              },
              textInside: "Hủy chọn".toUpperCase(),
              color: Colors.orange,
            ))
      ],
    );
  }
}
