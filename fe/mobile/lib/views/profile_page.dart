import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
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
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 80,
                            child: ClipOval(
                              child: user?.image != null
                                  ? (user!.image!.startsWith('data:image')
                                      ? Image.memory(
                                          base64Decode(
                                              user!.image!.split(',').last),
                                          fit: BoxFit.cover,
                                        )
                                      : Image.network(
                                          user!.image!,
                                          fit: BoxFit.cover,
                                          loadingBuilder:
                                              (context, child, progress) {
                                            if (progress == null) return child;
                                            return Center(
                                              child:
                                                  const CircularProgressIndicator(),
                                            );
                                          },
                                        ))
                                  : Image.asset(
                                      'assets/images/splash.png',
                                      fit: BoxFit.cover,
                                      width: 160,
                                      height: 160,
                                    ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: InkWell(
                              onTap: () {},
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 20,
                                child: Icon(Icons.camera_alt),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      Text(user!.roles.join() ?? '', style: TextStyle(fontSize: 20),),
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
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState?.validate() ?? false) {
                            if (user != null) {
                              await userViewModel.updateUser(user!.user.id, {
                                'fullName': fullNameController.text,
                                'userName': user!.user.userName,
                                'email': emailController.text,
                                'phoneNumber': phoneNumberController.text,
                                'role': user!.roles.join(),
                                if (passwordController.text.isNotEmpty)
                                  'password': passwordController.text,
                              });
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
