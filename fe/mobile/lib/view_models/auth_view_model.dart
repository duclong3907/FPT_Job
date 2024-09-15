import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../repository/auth_repos.dart';

class AuthViewModel extends GetxController {
  var token = ''.obs;
  var isLoggedIn = false.obs;
  var userId = ''.obs;
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
        //
        await SharedPreferences.getInstance().then((prefs) {
          prefs.setString('token', token);
          prefs.setString('userId', jwt.payload['UserId']);
        });
        isLoggedIn.value = true;
      } else {
        isLoggedIn.value = false;
        Get.snackbar('Error', 'token is null');
      }
    } catch (e) {
      isLoggedIn.value = false;
      print('Error logging in: $e');
    }
  }

  // Future<void> login(String userName, String password) async {
  //   try {
  //     final token = await _authService.login(userName, password);
  //     if (token != null) {
  //       this.token.value = token;
  //       print('Token: $token');
  //
  //       // Decode the token to extract userId
  //       final jwt = JWT.decode(token);
  //       print('UserId: ${jwt.payload['userId']}');
  //
  //       await SharedPreferences.getInstance().then((prefs) {
  //         prefs.setString('token', token);
  //         prefs.setString('userId', jwt.payload['userId']);
  //       });
  //
  //       isLoggedIn.value = true;
  //     } else {
  //       isLoggedIn.value = false;
  //     }
  //   } catch (e) {
  //     print('Error logging in: $e');
  //     isLoggedIn.value = false;
  //   }
  // }

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
        });
        isLoggedIn.value = false;
        this.token.value = '';
        userId.value = '';
      }
    } catch (e) {
      print('Error logging out: $e');
    }
  }
}
