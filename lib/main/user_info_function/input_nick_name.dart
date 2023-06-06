import 'package:flutter/material.dart';

import '../../assets/icons_assets.dart';

class InputNickNameScreen extends StatefulWidget {
  static String routeName = "/input_nick_name_screen";
  const InputNickNameScreen({Key? key}) : super(key: key);

  @override
  State<InputNickNameScreen> createState() => _InputNickNameScreenState();
}

class _InputNickNameScreenState extends State<InputNickNameScreen> {
  TextEditingController nickNameController = TextEditingController();
  String nickName = "";

  void clearTextFullName() {
    nickName = "";
    nickNameController.clear();
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
        padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 20),
        child: Column(
          children: [
            const Text('Nhập biệt danh của bạn',
                style: TextStyle(
                  fontSize: 26,
                  fontFamily: 'Nunito Sans',
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center),
            const SizedBox(
              height: 10,
            ),

            /// text field
            textFieldNickName(),
          ],
        ),
      ),
    ));
  }

  Widget textFieldNickName() {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(6),
      ),
      margin: const EdgeInsets.only(top: 20),
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
}
