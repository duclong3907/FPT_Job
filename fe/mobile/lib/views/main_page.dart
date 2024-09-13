import 'package:flutter/material.dart';
import 'package:mobile/views/splash_screen.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text('Material App Bar'),
      ),
      body: SplashScreen(),
    );
  }
}
