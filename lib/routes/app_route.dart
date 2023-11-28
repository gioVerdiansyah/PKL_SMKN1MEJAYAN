import 'dart:js';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pkl_smkn1mejayan/modules/views/home_page.dart';
import 'package:pkl_smkn1mejayan/modules/views/izin_page.dart';
import 'package:pkl_smkn1mejayan/modules/views/login_page.dart';
import 'package:pkl_smkn1mejayan/modules/views/riwayat_izin_page.dart';

class AppRoute {
  static GetStorage box = GetStorage();
  static String INITIAL = hasLogin();

  static String hasLogin() {
    var dataLogin = box.read('dataLogin');
    if (dataLogin != null) {
      return HomePage.routeName;
    } else {
      return LoginPage.routeName;
    }
  }

  // routeName
  static const String homeRoute = HomePage.routeName;
  static const String loginRoute = LoginPage.routeName;
  static const String izinRoute = IzinPage.routeName;
  static const String riwayatIzinRoute = RiwayatIzinPage.routeName;

  //

  static Map<String, WidgetBuilder> routes = {
    homeRoute: (context) => HomePage(),
    loginRoute: (context) => LoginPage(),
    izinRoute: (context) => IzinPage(),
    riwayatIzinRoute: (context) => RiwayatIzinPage()
  };
}