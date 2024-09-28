import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile/view_models/auth_view_model.dart';
import '../../models/auth/login_user_model.dart';
import '../../utils/validators.dart';

class RegisterScreen extends StatelessWidget {
  final AuthViewModel authViewModel = Get.put(AuthViewModel());

  final _fullNameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _emailController = TextEditingController();
  final _companyController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final ValueNotifier<bool> _isPasswordVisible = ValueNotifier<bool>(false);

  void _register() async {
    if (_formKey.currentState!.validate()) {
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildLogo(),
                  _buildEmailPasswordSignIn(),
                  _buildGoogleSignInButton(),
                ],
              ),
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
          TextFormField(
            controller: _fullNameController,
            decoration: const InputDecoration(
              labelText: 'Full Name',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.person),
            ),
            validator: (value) {
              return Validators.validateFullName(value!);
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.email),
            ),
            validator: (value) {
              return Validators.validateEmail(value!);
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _phoneNumberController,
            decoration: const InputDecoration(
              labelText: 'Phone Number',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.phone),
            ),
            validator: (value) {
              return Validators.validatePhoneNumber(value!);
            },
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
                  return Validators.validatePassword(value!);
                },
              );
            },
          ),

          const SizedBox(height: 16),
          Obx(() => Column(
                children: [
                  if (authViewModel.selectedRole.value == 'Employer') ...[
                    TextFormField(
                      controller: _companyController,
                      decoration: const InputDecoration(
                        labelText: 'Company',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.business),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Company cannot be empty';
                        }
                        return null;
                      },
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
            child:
                const Text('Register', style: TextStyle(color: Colors.white)),
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
