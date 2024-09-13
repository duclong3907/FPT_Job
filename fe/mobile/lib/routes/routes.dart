import 'package:flutter/material.dart';
import '../views/home_page.dart';
import '../views/main_page.dart';

class AppRoutes {
  static const String main = '/';
  static const String homePage = '/home';

  static Map<String, WidgetBuilder> routes = {
    main: (context) => MainPage(),
    homePage: (context) => HomePage(),
  };
}