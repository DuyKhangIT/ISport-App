import 'package:flutter/material.dart';

import 'navigation_bar.dart';

class ReviewScreen extends StatelessWidget {
  static String routeName = "/review_screen";
  const ReviewScreen({Key? key}) : super(key: key);

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
          'Đánh giá',
          style: TextStyle(
              fontFamily: 'Nunito Sans',
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black),
        ),
        elevation: 0,
      ),
      body: const Center(
        child: Text("Chưa có đánh giá",style: TextStyle(
            fontFamily: 'Nunito Sans',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black)),
      ),
    ));
  }
}
