import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile/view_models/auth_view_model.dart';
import '../../utils/snackbar_get.dart';

class LoginScreen extends StatelessWidget {
  final AuthViewModel authViewModel = Get.put(AuthViewModel());

  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final ValueNotifier<bool> _isPasswordVisible = ValueNotifier<bool>(false);

  void _login() async {
    final userName = _userNameController.text;
    final password = _passwordController.text;
    await authViewModel.login(userName, password);

    if (authViewModel.isLoggedIn.value) {
      final token = authViewModel.token.value;
      if (token != null && token.isNotEmpty) {
        Get.offNamed('/main');
      } else {
        SnackbarUtils.showWarningSnackbar('Invalid token');
      }
    } else {
      SnackbarUtils.showErrorSnackbar('Login failed');
    }
  }

  void _forgotPassword() async {
    await authViewModel.forgotPassword(_emailController.text);
  }

  void _loginWithPhone() async {}

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
                _buildLogo(),
                const SizedBox(height: 32),
                _buildEmailPasswordSignIn(),
                const SizedBox(height: 8),
                const Text('Or'),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(child: _buildPhoneSignInButton()),
                      const SizedBox(width: 16),
                      Expanded(child: _buildGoogleSignInButton()),
                    ],
                  ),
                )
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
          'assets/images/techjobs_logo.png',
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
            decoration: const InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.email),
            ),
          ),
          const SizedBox(height: 16),
          ValueListenableBuilder<bool>(
            valueListenable: _isPasswordVisible,
            builder: (context, isPasswordVisible, child) {
              return TextFormField(
                controller: _passwordController,
                keyboardType: TextInputType.visiblePassword,
                obscureText: !isPasswordVisible,
                decoration: InputDecoration(
                  hintText: 'Password',
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      _isPasswordVisible.value = !isPasswordVisible;
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              );
            },
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                child: Text('Forgot password?',
                    style: TextStyle(color: Color(0xFF3157D4))),
                onTap: _forgotPasswordButton,
              ),
              InkWell(
                child: Text('Don\'t have an account?',
                    style: TextStyle(color: Color(0xFF3157D4))),
                onTap: () {
                  Get.toNamed('/register');
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _login,
            child: const Text('Login', style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF3157D4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoogleSignInButton() {
    return ElevatedButton.icon(
      onPressed: () {
        authViewModel.signinWithGoogle();
      },
      icon: Image.asset(
        'assets/images/google.png',
        height: 24,
        fit: BoxFit.cover,
        filterQuality: FilterQuality.high,
      ),
      label: const Text('Google'),
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
  }

  Widget _buildPhoneSignInButton() {
    return ElevatedButton.icon(
      onPressed: _loginPhoneButton,
      icon: Icon(Icons.phone, color: Color(0xFF3157D4)),
      label: const Text('Phone'),
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
  }

  void _loginPhoneButton() {
    showCustomDialog(
      title: 'Login with Phone',
      middleText: 'Enter your phone',
      controller: _emailController,
      labelText: 'Enter your phone',
      onConfirm: _loginWithPhone,
    );
  }

  void _forgotPasswordButton() {
    showCustomDialog(
      title: 'Forgot Password',
      middleText: 'Enter your email',
      controller: _emailController,
      labelText: 'Enter your email',
      onConfirm: _forgotPassword,
    );
  }

  void showCustomDialog({
    required String title,
    required String middleText,
    required TextEditingController controller,
    required String labelText,
    required VoidCallback onConfirm,
  }) {
    Get.defaultDialog(
      title: title,
      middleText: middleText,
      content: TextField(
        controller: controller,
        decoration: InputDecoration(labelText: labelText),
      ),
      onConfirm: () {
        onConfirm();
        Get.back();
      },
      titleStyle: TextStyle(color: Colors.black),
      middleTextStyle: TextStyle(color: Colors.black),
      textConfirm: 'OK',
      confirmTextColor: Colors.white,
      buttonColor: Color(0xFF3157D4),
      radius: 10,
    );
  }
}
