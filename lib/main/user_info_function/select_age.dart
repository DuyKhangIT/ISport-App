import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
class SelectAgeScreen extends StatefulWidget {
  static String routeName = "/select_age_screen";
  const SelectAgeScreen({Key? key}) : super(key: key);

  @override
  State<SelectAgeScreen> createState() => _SelectAgeScreenState();
}

class _SelectAgeScreenState extends State<SelectAgeScreen> {
  int currentAge = 0;
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
            padding: const EdgeInsets.symmetric(vertical: 150, horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text('Tuổi của bạn',
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
                  height: MediaQuery.of(context).size.height/4,
                  margin: const EdgeInsets.symmetric(vertical: 20),
                  child:  NumberPicker(
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontFamily: 'Nunito Sans',
                      fontWeight: FontWeight.bold,
                    ),
                    value: currentAge,
                    minValue: 0,
                    maxValue: 100,
                    onChanged: (value) {
                      setState(() {
                        currentAge = value;
                        debugPrint(currentAge.toString());
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
