import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:isport_app/widget/button_next.dart';

import '../../assets/icons_assets.dart';
import '../../handle_api/handle_api.dart';
import '../../model/upload_media/upload_media_response.dart';

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


  // /// upload image api
  // Future<UploadMediaResponse> uploadMedia() async {
  //   UploadMediaResponse uploadMediaResponse;
  //   Map<String, dynamic>? body;
  //   try {
  //     body = await HttpHelper.invokeSingleFile(
  //         Uri.parse(
  //             "http://192.168.1.7:3002/api/upload-media?iddevice=${widget.dataDeviceUser!.idDevice}"),
  //         RequestType.post,
  //         filePath,
  //         headers: null,
  //         body: null);
  //   } catch (error) {
  //     debugPrint("Fail to upload file ${(error)}");
  //     rethrow;
  //   }
  //   if (body == null) return UploadMediaResponse.buildDefault();
  //   uploadMediaResponse = UploadMediaResponse.fromJson(body);
  //   if (uploadMediaResponse.code == 0) {
  //     setState(() {
  //       photoPath = uploadMediaResponse.data!;
  //       debugPrint("Upload Media successfully");
  //       if (photoPath.isNotEmpty) {
  //       }
  //     });
  //   } else {
  //     debugPrint("Upload Fail: ${uploadMediaResponse.message}");
  //   }
  //   return uploadMediaResponse;
  // }

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
              Container(
                width: 80,
                alignment: Alignment.center,
                margin: const EdgeInsets.only(right: 15,top: 10,bottom: 10),
                child: const Text(
                  'Cập nhật',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
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
