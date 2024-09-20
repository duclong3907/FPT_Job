import 'dart:convert';
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
  final TextEditingController companyController = TextEditingController();

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
        if (user!.roles.contains('Employer')) {
          companyController.text = user!.company ?? '';
        }
      }
      setState(() {});
    }
  }

  final ImagePicker _picker = ImagePicker();

  void selectImage() async {
    final XFile? img = await _picker.pickImage(source: ImageSource.gallery);
    if (img != null) {
      final imageBytes = await img.readAsBytes();
      final encodedImage = base64Encode(imageBytes);
      setState(() {
        user!.image = 'data:image/png;base64,$encodedImage';
      });
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
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: btnLogout,
          ),
        ],
      ),
      body: user == null
          ? const Center(child: CircularProgressIndicator())
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
                                          width: 160,
                                          height: 160,
                                        )
                                      : Image.network(
                                          user!.image!,
                                          fit: BoxFit.cover,
                                          width: 160,
                                          height: 160,
                                          loadingBuilder:
                                              (context, child, progress) {
                                            if (progress == null) return child;
                                            return const Center(
                                              child:
                                                  CircularProgressIndicator(),
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
                              onTap: selectImage,
                              child: const CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 20,
                                child: Icon(Icons.camera_alt),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        user!.roles.join() ?? '',
                        style: const TextStyle(fontSize: 20),
                      ),
                      TextFormField(
                        controller: fullNameController,
                        decoration: const InputDecoration(labelText: 'Full Name'),
                      ),
                      TextFormField(
                        controller: emailController,
                        decoration: const InputDecoration(labelText: 'Email'),
                      ),
                      TextFormField(
                        controller: phoneNumberController,
                        decoration: const InputDecoration(labelText: 'Phone Number'),
                      ),
                      if (user!.roles.contains('Employer'))
                        TextFormField(
                          controller: companyController,
                          decoration: const InputDecoration(labelText: 'Company Name'),
                        ),
                      TextFormField(
                        controller: passwordController,
                        decoration: const InputDecoration(labelText: 'Password'),
                        obscureText: true,
                      ),
                      const SizedBox(height: 20),
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
                                'image': user!.image!,
                                if (user!.roles.contains('Employer'))
                                  'company': companyController.text,
                                if (passwordController.text.isNotEmpty)
                                  'password': passwordController.text,

                              });
                            }
                          }
                        },
                        child: const Text('Update Profile'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  void btnLogout() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                authViewModel.logout();
                Get.offNamed('/');
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
