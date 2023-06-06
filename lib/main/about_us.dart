import 'package:flutter/material.dart';

import 'navigation_bar.dart';

class AboutUsScreen extends StatelessWidget {
  static String routeName = "/about_us_screen";
  const AboutUsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
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
          'Về chúng tôi',
          style: TextStyle(
              fontFamily: 'Nunito Sans',
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black),
        ),
        elevation: 0,
      ),
      body: const Center(
        child: Text("Thức",style: TextStyle(
            fontFamily: 'Nunito Sans',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black)),
      ),
    ));
  }
}
