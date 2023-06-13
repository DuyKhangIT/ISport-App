import 'package:flutter/material.dart';
import 'package:isport_app/routes/routes.dart';
import 'package:isport_app/until/global.dart';
import 'package:network_info_plus/network_info_plus.dart';

import 'onboarding/splash_page.dart';

void main() async {
  runApp(const MyApp());

  final info = NetworkInfo();
  final wifiName = await info.getWifiName();
  final wifiIPv4 = await info.getWifiIP();
  debugPrint(wifiName.toString());
  debugPrint(wifiIPv4.toString());

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ISport',
      color: Color(Global.primaryColor),
      theme: ThemeData(
          scaffoldBackgroundColor: Color(Global.primaryColor)
      ),
      routes: routes,
      initialRoute: SplashPage.routeName,
    );
  }
}

