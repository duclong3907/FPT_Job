import 'package:flutter/material.dart';

import 'routes/routes.dart';
import 'views/home_page.dart';
import 'views/main_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Job Finder',
      // home: MainPage(),
      initialRoute: AppRoutes.main,
      routes: AppRoutes.routes
    );
  }
}
