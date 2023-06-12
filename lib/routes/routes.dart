import 'package:flutter/material.dart';
import 'package:isport_app/main/about_us.dart';
import 'package:isport_app/main/home.dart';
import 'package:isport_app/main/info_user.dart';
import 'package:isport_app/main/list_user.dart';
import 'package:isport_app/main/map.dart';
import 'package:isport_app/main/profile.dart';
import 'package:isport_app/main/review.dart';
import 'package:isport_app/main/user_info_function/choose_gender.dart';
import 'package:isport_app/main/user_info_function/input_nick_name.dart';
import 'package:isport_app/main/user_info_function/select_age.dart';
import 'package:isport_app/main/user_info_function/select_height.dart';
import 'package:isport_app/onboarding/login.dart';
import 'package:isport_app/onboarding/resgister.dart';
import 'package:isport_app/onboarding/splash_page.dart';

import '../main/account_info.dart';
import '../main/account_info_function/avatar_account_user.dart';
import '../main/account_info_function/change_password_account_user.dart';
import '../main/account_info_function/input_full_name_account_user.dart';
import '../main/user_info_function/avatar_user.dart';
import '../main/navigation_bar.dart';
import '../main/user_info_function/select_weight.dart';

final Map<String,WidgetBuilder> routes = {
  SplashPage.routeName: (context) =>  const SplashPage(),
  LoginScreen.routeName: (context) =>  const LoginScreen(),
  RegisterScreen.routeName: (context) =>  const RegisterScreen(),
  NavigationBarScreen.routeName: (context) =>  NavigationBarScreen(),
  HomeScreen.routeName: (context) =>  const HomeScreen(),
  ProfileScreen.routeName: (context) =>  const ProfileScreen(),
  MapScreen.routeName: (context) =>  const MapScreen(),
  ListUserScreen.routeName: (context) =>  const ListUserScreen(),
  InfoUserScreen.routeName: (context) =>  const InfoUserScreen(),
  AvatarUserScreen.routeName: (context) =>  const AvatarUserScreen(),
  InputNickNameScreen.routeName: (context) =>  const InputNickNameScreen(),
  ChooseGenderScreen.routeName: (context) =>  const ChooseGenderScreen(),
  SelectAgeScreen.routeName: (context) =>  const SelectAgeScreen(),
  SelectHeightScreen.routeName: (context) =>  const SelectHeightScreen(),
  SelectWeightScreen.routeName: (context) =>  const SelectWeightScreen(),
  ReviewScreen.routeName: (context) =>  const ReviewScreen(),
  AboutUsScreen.routeName: (context) =>  const AboutUsScreen(),
  AccountInfoScreen.routeName: (context) =>  const AccountInfoScreen(),
  AvatarAccountUserScreen.routeName: (context) =>  const AvatarAccountUserScreen(),
  InputFullNameAccountUserScreen.routeName: (context) =>  const InputFullNameAccountUserScreen(),
  ChangePasswordAccountUserScreen.routeName: (context) =>  const ChangePasswordAccountUserScreen(),

};