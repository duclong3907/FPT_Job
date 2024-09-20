import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/auth/login_user_model.dart';
import '../repository/auth_repos.dart';
import '../utils/snackbar_get.dart';
import 'job_view_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthViewModel extends GetxController {
  var token = ''.obs;
  var isLoggedIn = false.obs;
  var userId = ''.obs;
  var role = ''.obs;
  var isLoading = false.obs;
  var selectedRole = 'JobSeeker'.obs;
  final AuthService _authService = AuthService();
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> login(String userName, String password) async {
    try {
      final token = await _authService.login(userName, password);
      if (token != null) {
        this.token.value = token;
        // Decode the token to extract userId
        final jwt = JWT.decode(token);
        print('UserId: ${jwt.payload['UserId']}');
        this.userId.value = jwt.payload['UserId'];
        this.role.value = jwt.payload['Role'];
        await secureStorage.write(key: 'token', value: token);
        await secureStorage.write(key: 'userId', value: jwt.payload['UserId']);
        await secureStorage.write(key: 'role', value: jwt.payload['Role']);
        isLoggedIn.value = true;
        // Refresh favorite jobs after login
        final JobViewModel jobViewModel = Get.find<JobViewModel>();
        await jobViewModel.login(this.userId.value, this.role.value);
      } else {
        isLoggedIn.value = false;
        SnackbarUtils.showErrorSnackbar('token is null');
      }
    } catch (e) {
      isLoggedIn.value = false;
      SnackbarUtils.showErrorSnackbar('$e');
    }
  }

  void checkLogin() async {
    final token = await _authService.getToken();
    if (token != null && token.isNotEmpty) {
      isLoggedIn.value = true;
    } else {
      isLoggedIn.value = false;
    }
  }

  Future<void> registerUser(LoginUser user) async {
    final result = await _authService.registerUser(user);
    if (result['status']) {
      // Handle successful registration
      print(result['message']);
      SnackbarUtils.showSuccessSnackbar(result['message']);
    } else {
      // Handle registration error
      print(result['message']);
      SnackbarUtils.showErrorSnackbar(result['message']);
    }
  }

  Future<void> logout() async {
    try {
      final token = await _authService.getToken();
      if (token != null) {
        await _authService.logout(token);
        await secureStorage.delete(key: 'token');
        await secureStorage.delete(key: 'userId');
        await secureStorage.delete(key: 'role');
        isLoggedIn.value = false;
        this.token.value = '';
        userId.value = '';
        role.value = '';
        await GoogleSignIn().signOut();
      }
    } catch (e) {
      SnackbarUtils.showErrorSnackbar('$e');
    }
  }

  Future<void> signinWithGoogle() async {
    try {
      final response = await _authService.signInWithGoogle('JobSeeker');
      if (response['status']) {
        final token = response['token'];
        this.token.value = token;
        // Decode the token to extract userId
        final jwt = JWT.decode(token);
        print('UserId: ${jwt.payload['UserId']}');
        this.userId.value = jwt.payload['UserId'] as String;
        this.role.value = jwt.payload['Role'] as String;
        await secureStorage.write(key: 'token', value: token);
        await secureStorage.write(key: 'userId', value: jwt.payload['UserId'] as String);
        await secureStorage.write(key: 'role', value: jwt.payload['Role'] as String);
        isLoggedIn.value = true;
        // Refresh favorite jobs after login
        final JobViewModel jobViewModel = Get.find<JobViewModel>();
        await jobViewModel.login(this.userId.value, this.role.value);
      } else {
        isLoggedIn.value = false;
        print(response['message']);
        SnackbarUtils.showErrorSnackbar(response['message']);
      }
    } catch (e) {
      isLoggedIn.value = false;
      print('Error signing in with Google: $e');
      SnackbarUtils.showErrorSnackbar('$e');
    }
  }

  void setRole(String role) {
    selectedRole.value = role;
  }

}
