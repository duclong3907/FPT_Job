import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'config/detail_binding.dart';
import 'routes/routes.dart';


void main() {
  runApp(MainPage());
}

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Job Finder',
      initialBinding: DetailBinding(),
      initialRoute: AppRoutes.splash,
      routes: AppRoutes.routes,
    );
  }
}
