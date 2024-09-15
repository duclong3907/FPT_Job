import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'profile_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final _currentIndex = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ValueListenableBuilder(
            valueListenable: _currentIndex,
            builder: (context, index, child) {
              return IndexedStack(
                index: index,
                children: const [
                  HomePage(),
                  ProfilePage(),
                ],
              );
            }),
      ),
      bottomNavigationBar: ValueListenableBuilder(
          valueListenable: _currentIndex,
          builder: (context, index, child) {
            return BottomNavigationBar(
              currentIndex: index,
              onTap: (value) => _currentIndex.value = value,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Profile',
                ),
              ],
            );
          }),
    );
  }
}