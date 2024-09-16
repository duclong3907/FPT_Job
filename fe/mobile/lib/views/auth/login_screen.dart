import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile/view_models/auth_view_model.dart';

class LoginScreen extends StatelessWidget {
  final AuthViewModel authViewModel = Get.put(AuthViewModel());

  final TextEditingController _userNameController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  late final AuthViewModel _controller;

  void _login() async {
    final userName = _userNameController.text;
    final password = _passwordController.text;
    await authViewModel.login(userName, password);

    if (authViewModel.isLoggedIn.value) {
      final token = authViewModel.token.value;
      if (token != null && token.isNotEmpty) {
        Get.offNamed('/main');
      } else {
        Get.snackbar('warning', 'Invalid token');
      }
    } else {
      Get.snackbar('Error', 'Login failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // _buildLogo(),
                const SizedBox(height: 32),
                _buildEmailPasswordSignIn(),
                const SizedBox(height: 16),
                const Text('Or'),
                const SizedBox(height: 16),
                _buildGoogleSignInButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/',
          height: 80,
          fit: BoxFit.cover,
          filterQuality: FilterQuality.high,
        ),
      ],
    );
  }

  Widget _buildEmailPasswordSignIn() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
          children: [
            TextField(
              controller: _userNameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _login,
              child: const Text('Login'),
            ),
          ],
        ),
    );
  }

  Widget _buildGoogleSignInButton() {
    return ElevatedButton.icon(
      onPressed: () {

      },
      icon: Image.asset(
        'assets/images/google.png',
        height: 24,
        fit: BoxFit.cover,
        filterQuality: FilterQuality.high,
      ),
      label: const Text('Sign in with Google'),
    );
  }
}