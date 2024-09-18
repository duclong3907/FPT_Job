import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/snackbar_get.dart';
import '../view_models/auth_view_model.dart';
import 'favorite_job_screen.dart';
import 'home_screen.dart';
import 'profile_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final AuthViewModel authViewModel = Get.find<AuthViewModel>();
  final _currentIndex = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ValueListenableBuilder(
            valueListenable: _currentIndex,
            builder: (context, index, child) {
              final isLoggedIn = authViewModel.isLoggedIn.value;
              return IndexedStack(
                index: isLoggedIn ? index : 0,
                children: [
                  const HomePage(),
                  if (isLoggedIn) FavoriteJobsPage(),
                  if (isLoggedIn) ProfilePage(),
                ],
              );
            }),
      ),
      bottomNavigationBar: ValueListenableBuilder(
          valueListenable: _currentIndex,
          builder: (context, index, child) {
            return BottomNavigationBar(
              currentIndex: index,
              onTap: (value) {
                if ((value == 1 || value == 2) && !authViewModel.isLoggedIn.value) {
                  SnackbarUtils.showWarningSnackbar(
                      'You must be logged in to access this screen!');
                } else {
                  _currentIndex.value = value;
                }
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.list_alt_outlined),
                  label: 'List',
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
