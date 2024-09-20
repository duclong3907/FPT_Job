import 'package:flutter/material.dart';
import 'package:mobile/views/splash_screen.dart';
import '../views/auth/login_screen.dart';
import '../views/auth/register_screen.dart';
import '../views/home_screen.dart';
import '../views/main_page.dart';

class AppRoutes {
  static const String splash = '/';
  static const String homePage = '/home';
  static const String main_home = '/main';
  static const String login = '/login';
  static const String register = '/register';

  static Map<String, WidgetBuilder> routes = {
    splash: (context) => const SplashScreen(),
    homePage: (context) => HomePage(),
    main_home: (context) => MainScreen(),
    login: (context) => LoginScreen(),
    register: (context) => RegisterScreen(),
  };
}