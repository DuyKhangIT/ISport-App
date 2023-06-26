import 'dart:convert';
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:isport_app/model/update_account_info/update_account_info_request/update_avt_device_info_request.dart';
import 'package:isport_app/widget/button_next.dart';

import '../../assets/icons_assets.dart';
import '../../handle_api/handle_api.dart';
import '../../model/account_info/account_info_response.dart';
import '../../model/update_account_info/update_account_info_response.dart';
import '../../model/upload_media/upload_media_response.dart';
import '../../until/global.dart';
import '../../until/show_loading_dialog.dart';
import '../account_info.dart';

class AvatarAccountUserScreen extends StatefulWidget {
  static String routeName = "/avatar_account_user_screen";
  const AvatarAccountUserScreen({Key? key}) : super(key: key);

  @override
  State<AvatarAccountUserScreen> createState() => _AvatarAccountUserScreenState();
}

class _AvatarAccountUserScreenState extends State<AvatarAccountUserScreen> {
  File? avatar;
  String filePath = "";
  String photoPath = "";
  bool isLoading = false;

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
          Uri.parse(
              "http://192.168.1.7:3002/api/upload-media"),
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
          UpdateAvtAccountInfoRequest updateAvtAccountInfoRequest = UpdateAvtAccountInfoRequest(photoPath);
          updateFullNameAccountInfoApi(updateAvtAccountInfoRequest);
        }
      });
    } else {
      debugPrint("Upload Fail: ${uploadMediaResponse.message}");
    }
    return uploadMediaResponse;
  }

  /// call api update device
  Future<UpdateAccountInfoResponse> updateFullNameAccountInfoApi(
      UpdateAvtAccountInfoRequest updateAvtAccountInfoRequest) async {
    setState(() {
      isLoading = true;
      if (isLoading) {
        IsShowDialog().showLoadingDialog(context);
      } else {
        Navigator.of(context).pop();
      }
    });
    UpdateAccountInfoResponse updateAccountInfoResponse;
    Map<String, dynamic>? body;
    try {
      body = await HttpHelper.invokeHttp(
          Uri.parse(
              "http://192.168.1.7:3002/api/user/update"),
          RequestType.post,
          headers: null,
          body: const JsonEncoder()
              .convert(updateAvtAccountInfoRequest.toBodyRequest()));
    } catch (error) {
      debugPrint("Fail to update avt account info $error");
      rethrow;
    }
    if (body == null) return UpdateAccountInfoResponse.buildDefault();
    updateAccountInfoResponse = UpdateAccountInfoResponse.fromJson(body);
    if (updateAccountInfoResponse.code != 0) {
      setState(() {
        isLoading = false;
        if (isLoading) {
          IsShowDialog().showLoadingDialog(context);
        } else {
          Navigator.of(context).pop();
        }
        Fluttertoast.showToast(
            msg: "Cập nhật ảnh đại diện không thành công!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 5,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16);
        debugPrint(updateAccountInfoResponse.message);
      });
    } else {
      setState(() {
        isLoading = false;
        if (isLoading) {
          IsShowDialog().showLoadingDialog(context);
        } else {
          Navigator.of(context).pop();
          Fluttertoast.showToast(
              msg: "Cập nhật ảnh đại diện thành công",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 5,
              backgroundColor: Colors.orange,
              textColor: Colors.black,
              fontSize: 16);
          getAccountInfo();

        }
      });
    }
    return updateAccountInfoResponse;
  }

  /// account info
  Future<AccountInfoResponse> getAccountInfo() async {
    AccountInfoResponse accountInfoResponse;
    Map<String, dynamic>? body;
    try {
      body = await HttpHelper.invokeHttp(
          Uri.parse("http://192.168.1.7:3002/api/user"),
          RequestType.get,
          headers: null,
          body: null);
    } catch (error) {
      debugPrint("Fail to get account info $error");
      rethrow;
    }
    if (body == null) return AccountInfoResponse.buildDefault();
    //get data from api here
    accountInfoResponse = AccountInfoResponse.fromJson(body);
    if(accountInfoResponse.code == 0){
      setState(() {
        Global.accountInfo = accountInfoResponse.accountInfo[0];
        debugPrint("Get Account Info successfully");
        debugPrint(Global.accountInfo.toString());
        Navigator.pushNamedAndRemoveUntil(context,
            AccountInfoScreen.routeName,(Route<dynamic> route) => false);
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
      debugPrint(accountInfoResponse.message);

    }
    return accountInfoResponse;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Text(
              'Thông tin tài khoản',
              style: TextStyle(
                  color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
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
              GestureDetector(
                onTap: (){
                  if(Global.isAvailableToClick()){
                    if(avatar !=null){
                      uploadMedia();
                    }else{
                      Fluttertoast.showToast(
                          msg: "Vui lòng chọn hình",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.black,
                          fontSize: 16);
                    }
                  }
                },
                child: Container(
                  width: 80,
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(right: 15,top: 10,bottom: 10),
                  child: const Text(
                    'Cập nhật',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ),
            ],
            elevation: 0,
          ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.fromLTRB(20,70,20,0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text('Ảnh đại diện bạn muốn đổi',
                style: TextStyle(
                  fontSize: 26,
                  fontFamily: 'Nunito Sans',
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center),

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
                            width: 160,
                            height: 160,
                            margin: const EdgeInsets.only(top: 80),
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
                          bottom: 10,
                          child: Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black,
                                width: 0.5,
                              ),
                              shape: BoxShape.circle,
                            ),
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
                        width: 160,
                        height: 160,
                        margin: const EdgeInsets.only(top: 80),
                        decoration: const BoxDecoration(shape: BoxShape.circle),
                        child: DottedBorder(
                            color: Colors.black.withOpacity(0.5),
                            strokeWidth: 1,
                            borderType: BorderType.Circle,
                            dashPattern: const [6, 5],
                            radius: const Radius.circular(60),
                            child: Center(
                                child: Image.asset(IconsAssets.icUpload)))),
                  ),

          ],
        ),
      ),
    ));
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
