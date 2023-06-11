import 'package:flutter/material.dart';
import 'package:isport_app/routes/routes.dart';
import 'package:isport_app/until/global.dart';

import 'onboarding/splash_page.dart';

void main() {
  runApp(const MyApp());
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

