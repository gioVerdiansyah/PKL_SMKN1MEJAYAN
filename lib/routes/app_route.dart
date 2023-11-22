import 'package:flutter/material.dart';
import 'package:pkl_smkn1mejayan/modules/views/home_page.dart';
import 'package:pkl_smkn1mejayan/modules/views/login_page.dart';

class AppRoute {
  static const String INITIAL = HomePage.routeName;

  // title


  // routeName
  static const String homeRoute = HomePage.routeName;
  static const String loginRoute = LoginPage.routeName;

  static Map<String, WidgetBuilder> routes = {
    homeRoute: (context) => HomePage(),
    loginRoute: (context) => LoginPage(),
  };
}