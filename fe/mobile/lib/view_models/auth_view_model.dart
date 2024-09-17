import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../repository/auth_repos.dart';
import '../utils/snackbar_get.dart';
import 'job_view_model.dart';

class AuthViewModel extends GetxController {
  var token = ''.obs;
  var isLoggedIn = false.obs;
  var userId = ''.obs;
  var role = ''.obs;
  var isLoading = false.obs;
  final AuthService _authService = AuthService();

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
        await SharedPreferences.getInstance().then((prefs) {
          prefs.setString('token', token);
          prefs.setString('userId', jwt.payload['UserId']);
          prefs.setString('role', jwt.payload['Role']);
        });
        isLoggedIn.value = true;
        // Refresh favorite jobs after login
        final JobViewModel jobViewModel = Get.find<JobViewModel>();
        await jobViewModel.login(this.userId.value);
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

  Future<void> logout() async {
    try {
      final token = await _authService.getToken();
      if (token != null) {
        await _authService.logout(token);
        await SharedPreferences.getInstance().then((prefs) {
          prefs.remove('token');
          prefs.remove('userId');
          prefs.remove('role');
        });
        isLoggedIn.value = false;
        this.token.value = '';
        userId.value = '';
        role.value = '';
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
        await SharedPreferences.getInstance().then((prefs) {
          prefs.setString('token', token);
          prefs.setString('userId', jwt.payload['UserId'] as String);
          prefs.setString('role', jwt.payload['Role'] as String);
        });
        isLoggedIn.value = true;
        // Refresh favorite jobs after login
        final JobViewModel jobViewModel = Get.find<JobViewModel>();
        await jobViewModel.login(this.userId.value);
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

}
