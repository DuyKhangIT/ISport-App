import 'package:flutter/material.dart';

import 'navigation_bar.dart';

class AboutUsScreen extends StatelessWidget {
  static String routeName = "/about_us_screen";
  const AboutUsScreen({Key? key}) : super(key: key);

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
              MaterialPageRoute(
                  builder: (context) => NavigationBarScreen(currentIndex: 1)),
            );
          },
          child: const Icon(Icons.arrow_back_ios_rounded, color: Colors.black),
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
      body: Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        alignment: Alignment.topCenter,
        child: Column(
          children: [
            const Text(
              "Thiết bị ISport được dùng để đo hiệu suất vận động của các cầu thủ trên sân bóng và thông báo về smartphone cho đội trưởng biết về hiện trạng của đội viên.\nThiết bị sẽ được cập nhật cũng như thường xuyên để cải thiện hiệu xuất đo đạc cũng như độ chính xác. ",
              style: TextStyle(
                  fontFamily: 'Nunito Sans',
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                  height: 1.9),
              textAlign: TextAlign.justify,
            ),
            const Text(
              "Mọi thắc mắc vui lòng liên hệ chúng tôi qua email:",
              style: TextStyle(
                  fontFamily: 'Nunito Sans',
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.italic,
                  color: Colors.black,
                  height: 1.9),
              textAlign: TextAlign.justify,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              constraints: const BoxConstraints(maxHeight: 100),
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        margin: const EdgeInsets.only(right: 10),
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: Colors.black),
                      ),
                      const Text(
                        "vocongthuc0611@gmail.com",
                        style: TextStyle(
                          fontFamily: 'Nunito Sans',
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        margin: const EdgeInsets.only(right: 10),
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: Colors.black),
                      ),
                      const Text(
                        "19146275@st.hcmute.edu.vn",
                        style: TextStyle(
                          fontFamily: 'Nunito Sans',
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        margin: const EdgeInsets.only(right: 10),
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: Colors.black),
                      ),
                      const Text(
                        "19146280@st.hcmute.edu.vn",
                        style: TextStyle(
                          fontFamily: 'Nunito Sans',
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    ));
  }
}
