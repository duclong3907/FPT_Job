import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile/view_models/auth_view_model.dart';

class LoginScreen extends StatelessWidget {
  final AuthViewModel authViewModel = Get.put(AuthViewModel());
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login() async {
    final userName = _userNameController.text;
    final password = _passwordController.text;
    await authViewModel.login(userName, password);

    if (authViewModel.isLoggedIn.value) {
      final token = authViewModel.token.value;
      if (token != null && token.isNotEmpty) {
        Get.offNamed('/main');
      } else {
        print('Error: Token is null or empty');
      }
    } else {
      print('Error logging in');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _userNameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: _login,
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}