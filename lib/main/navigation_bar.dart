import 'package:flutter/material.dart';
import 'package:isport_app/main/home.dart';
import 'package:isport_app/main/profile.dart';

import '../assets/icons_assets.dart';

class NavigationBarScreen extends StatefulWidget {
  int? currentIndex = 0;
  static String routeName = "/navigation_bar_screen";
  NavigationBarScreen({Key? key,this.currentIndex}) : super(key: key);

  @override
  State<NavigationBarScreen> createState() => _NavigationBarScreenState();
}

class _NavigationBarScreenState extends State<NavigationBarScreen> {
  List page = [
    const HomeScreen(),
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      widget.currentIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      body: Stack(
        children: [
          page[widget.currentIndex??0],
          Align(
            alignment: Alignment.bottomCenter,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(20),
                  topLeft: Radius.circular(20)),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: (60),
                child: BottomNavigationBar(
                  type: BottomNavigationBarType.fixed,
                  currentIndex: widget.currentIndex ?? 0,
                  onTap: _onItemTapped,
                  showUnselectedLabels: false,
                  showSelectedLabels: false,
                  selectedItemColor: Colors.black,
                  elevation: 0,
                  backgroundColor: Colors.orange,
                  items: [
                    BottomNavigationBarItem(
                      activeIcon: Image.asset(
                          IconsAssets.icHomeActive,
                          color: Colors.black),
                      icon: Image.asset(IconsAssets.icHome,
                          color: Colors.black),
                      label: '',
                    ),
                    BottomNavigationBarItem(
                      activeIcon: Image.asset(
                          IconsAssets.icProfileActive,
                          color:  Colors.black),
                      icon: Image.asset(
                          IconsAssets.icProfile,
                          color:Colors.black),
                      label: '',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
