import 'package:flutter/material.dart';
import 'package:mobile/views/splash_screen.dart';
import 'package:mobile/widgets/job_list.dart';
import '../views/home_screen.dart';
import '../views/job_detail_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String homePage = '/home';
  static const String jobList = '/job';

  static Map<String, WidgetBuilder> routes = {
    splash: (context) => SplashScreen(),
    homePage: (context) => HomePage(),
    jobList: (context) => JobList(),
  };
}