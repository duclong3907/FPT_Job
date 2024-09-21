import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile/view_models/auth_view_model.dart';

import '../../models/auth/login_user_model.dart';

class RegisterScreen extends StatelessWidget {
  final AuthViewModel authViewModel = Get.put(AuthViewModel());

  final _fullNameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _emailController = TextEditingController();
  final _companyController = TextEditingController();
  void _register() async {
    await authViewModel.registerUser(
      LoginUser(
        fullName: _fullNameController.text,
        userName: _emailController.text,
        password: _passwordController.text,
        phoneNumber: _phoneNumberController.text,
        email: _emailController.text,
        company: _companyController.text,
        role: authViewModel.selectedRole.value,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
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
            controller: _fullNameController,
            decoration: const InputDecoration(labelText: 'Full Name'),
          ),
          TextField(
            controller: _emailController,
            decoration: const InputDecoration(labelText: 'Email'),
          ),
          TextField(
            controller: _phoneNumberController,
            decoration: const InputDecoration(labelText: 'Phone Number'),
          ),
          TextField(
            controller: _passwordController,
            decoration: const InputDecoration(labelText: 'Password'),
            obscureText: true,
          ),
          const SizedBox(height: 16),
          Obx(() => Column(
                children: [
                  if (authViewModel.selectedRole.value == 'Employer') ...[
                    TextField(
                      controller: _companyController,
                      decoration: const InputDecoration(labelText: 'Company'),
                    ),
                    const SizedBox(height: 16),
                  ],
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: RadioListTile<String>(
                          title: const Text('JobSeeker'),
                          value: 'JobSeeker',
                          groupValue: authViewModel.selectedRole.value,
                          onChanged: (value) {
                            authViewModel.setRole(value!);
                          },
                        ),
                      ),
                      Expanded(
                        child: RadioListTile<String>(
                          title: const Text('Employer'),
                          value: 'Employer',
                          groupValue: authViewModel.selectedRole.value,
                          onChanged: (value) {
                            authViewModel.setRole(value!);
                          },
                        ),
                      ),
                    ],
                  ),

                ],
              )),
          ElevatedButton(
            onPressed: _register,
            child: const Text('Register', style: TextStyle(color: Colors.white)),
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
      label: const Text('Sign in with Google'),
    );
  }
}
