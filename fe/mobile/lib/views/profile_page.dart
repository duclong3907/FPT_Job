import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../view_models/auth_view_model.dart';
import '../view_models/user_view_model.dart';
import '../models/user/user_response_model.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AuthViewModel authViewModel = Get.find<AuthViewModel>();
  final UserViewModel userViewModel = Get.find<UserViewModel>();
  final _formKey = GlobalKey<FormState>();
  UserResponse? user;

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final userId = authViewModel.userId.value;
    if (userId.isNotEmpty) {
      user = await userViewModel.getUser(userId);
      if (user != null) {
        fullNameController.text = user!.fullName ?? '';
        emailController.text = user!.user.email ?? '';
        phoneNumberController.text = user!.user.phoneNumber ?? '';
      }
      setState(() {});
    }
  }

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    phoneNumberController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              authViewModel.logout();
              Get.offNamed('/');
            },
          ),
        ],
      ),
      body: user == null
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Image field
                if (user?.image != null)
                  Image.network(user!.image!),
                TextFormField(
                  controller: fullNameController,
                  decoration: InputDecoration(labelText: 'Full Name'),
                ),
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                ),
                TextFormField(
                  controller: phoneNumberController,
                  decoration: InputDecoration(labelText: 'Phone Number'),
                ),
                TextFormField(
                  controller: passwordController,
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                ),
                // Role field as label
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      Text('Role: ', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(user!.roles.join() ?? ''),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState?.validate() ?? false) {
                      if (user != null) {
                        await userViewModel.updateUser(user!.user.id, {
                          'fullName': fullNameController.text,
                          'email': emailController.text,
                          'phoneNumber': phoneNumberController.text,
                          if (passwordController.text.isNotEmpty) 'password': passwordController.text,
                        });
                        Get.snackbar('Success', 'Profile updated successfully');
                      }
                    }
                  },
                  child: Text('Update Profile'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}