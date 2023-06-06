import 'package:flutter/material.dart';
import 'package:isport_app/assets/assets.dart';

class ChooseGenderScreen extends StatefulWidget {
  static String routeName = "/choose_gender_screen";
  const ChooseGenderScreen({Key? key}) : super(key: key);

  @override
  State<ChooseGenderScreen> createState() => _ChooseGenderScreenState();
}

class _ChooseGenderScreenState extends State<ChooseGenderScreen> {
  Color? colorFemaleGender;
  Color? colorMaleGender;
  String gender = "";
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: const Text(
          'Người dùng 1',
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.w500, fontSize: 20),
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
            margin: const EdgeInsets.only(right: 15, top: 10, bottom: 10),
            child: const Text(
              'Xác nhận',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
          ),
        ],
        elevation: 0,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.symmetric(vertical: 200, horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text('Chọn giới tính',
                style: TextStyle(
                  fontSize: 26,
                  fontFamily: 'Nunito Sans',
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center),
            const SizedBox(
              height: 10,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  /// male gender
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        colorMaleGender = Colors.pink;
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
                          width: 80,
                          height: 80,
                          padding: const EdgeInsets.all(25),
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
                                fontSize: 20,
                                fontFamily: 'Nunito Sans',
                                fontWeight: FontWeight.bold,
                                color: colorMaleGender ?? Colors.white54)),
                      ],
                    ),
                  ),

                  GestureDetector(
                    onTap: () {
                      setState(() {
                        colorFemaleGender = Colors.pink;
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
                          width: 80,
                          height: 80,
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(25),
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
                                fontSize: 20,
                                fontFamily: 'Nunito Sans',
                                fontWeight: FontWeight.bold,
                                color: colorFemaleGender ?? Colors.white54)),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    ));
  }
}
