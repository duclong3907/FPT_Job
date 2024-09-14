import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../routes/routes.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Job Finder',
        initialRoute: AppRoutes.splash,
        routes: AppRoutes.routes
    );
  }
}