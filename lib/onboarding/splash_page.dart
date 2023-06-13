import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:isport_app/onboarding/login.dart';

import '../main/navigation_bar.dart';
import '../until/global.dart';
import '../until/share_preferences.dart';


class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);
  static String routeName = "/splash_page";
  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool isNewUser = false;
  @override
  void initState() {
    checkAlreadyLoggedIn();
    super.initState();
  }
  /// check login with shared preferences
  Future<void> checkAlreadyLoggedIn() async {
    String? userId = await ConfigSharedPreferences().getStringValue(
        SharedData.TOKEN.toString(),
        defaultValue: "");
    if (userId.isEmpty || userId == "") {
      setState(() {
        isNewUser = true;
      });
    } else {
      Global.mToken = userId;
      loadData();
    }
  }
  Future<void> loadData() async {
    await Future.delayed(const Duration(seconds: 3));
    setState(() {
      isNewUser = false;
      Navigator.pushNamedAndRemoveUntil(context, NavigationBarScreen.routeName, (Route<dynamic> route) => false);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: isNewUser == false
          /// loading
          ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              CircularProgressIndicator(
                backgroundColor: Colors.orangeAccent,
                strokeWidth: 5,
                color: Colors.black,
              ),
              SizedBox(height: 15),
              Text('loading...', style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18
              )),

            ],
          )
          : Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              /// start for new joiner
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 1.5,
                margin: const EdgeInsets.only(top: 50),
                alignment: Alignment.center,
                child: const Text('ISport',
                    style: TextStyle(
                        fontSize: 40,
                        color: Colors.black,
                        fontWeight: FontWeight.bold)),
              ),

              /// button start
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamedAndRemoveUntil(
                          context,
                          LoginScreen.routeName,
                              (Route<dynamic> route) => false);
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      alignment: Alignment.center,
                      margin: const EdgeInsets.only(
                          left: 20, right: 20, bottom: 30),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.orangeAccent,
                      ),
                      child:  Text(
                        'Bắt đầu'.toUpperCase(),
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

