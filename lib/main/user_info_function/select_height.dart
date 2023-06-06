import 'package:flutter/material.dart';
import 'package:flutter_ruler_picker/flutter_ruler_picker.dart';
import 'package:isport_app/assets/assets.dart';

class SelectHeightScreen extends StatefulWidget {
  static String routeName = "/select_height_screen";
  const SelectHeightScreen({Key? key}) : super(key: key);

  @override
  State<SelectHeightScreen> createState() => _SelectHeightScreenState();
}

class _SelectHeightScreenState extends State<SelectHeightScreen> {
  RulerPickerController? rulerPickerController;

  int height = 0;

  @override
  void initState() {
    super.initState();
    rulerPickerController = RulerPickerController(value: 0);
  }

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
        padding: const EdgeInsets.symmetric(vertical: 200),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text('Chiều cao của bạn',
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
              margin: const EdgeInsets.symmetric(vertical: 20),
              child: RulerPicker(
                controller: rulerPickerController!,
                beginValue: 0,
                endValue: 300,
                rulerBackgroundColor: Colors.white,
                rulerScaleTextStyle: const TextStyle(
                    fontSize: 16,
                    fontFamily: 'Nunito Sans',
                    fontWeight: FontWeight.w700,
                    color: Colors.orange),
                initValue: height,
                onValueChange: (value) {
                  setState(() {
                    height = value;
                    debugPrint(height.toString());
                  });
                },
                width: MediaQuery.of(context).size.width,
                height: 90,
                rulerMarginTop: 25,
                marker: Column(
                  children: [
                    Text('$height cm',
                        style: const TextStyle(
                          fontSize: 16,
                          fontFamily: 'Nunito Sans',
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center),
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: Image.asset(IconsAssets.icDropDown,
                          color: Colors.red),
                    ),
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
