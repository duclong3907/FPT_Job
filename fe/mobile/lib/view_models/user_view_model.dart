import 'package:get/get.dart';
import '../repository/user_repos.dart';
import '../models/user/user_response_model.dart';
import '../utils/snackbar_get.dart';

class UserViewModel extends GetxController {
  var users = <UserResponse>[].obs;
  var isLoading = false.obs;
  final UserRepository _userRepository = UserRepository();

  Future<void> fetchUsers() async {
    isLoading.value = true;
    try {
      users.value = await _userRepository.fetchUsers();
    } catch (e) {
      SnackbarUtils.showErrorSnackbar('$e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<UserResponse?> getUser(String id) async {
    try {
      return await _userRepository.getUser(id);
    } catch (e) {
      SnackbarUtils.showErrorSnackbar('$e');
    }
  }

  Future<void> updateUser(String userId, Map<String, String> requestBody) async {
    try {
      await _userRepository.updateUser(userId, requestBody);
      SnackbarUtils.showSuccessSnackbar('Updated successfully!');
    } catch (e) {
      SnackbarUtils.showErrorSnackbar('$e');
    }
  }

  Future<void> deleteUser(String id) async {
    try {
      await _userRepository.deleteUser(id);
      SnackbarUtils.showSuccessSnackbar('Deleted successfully!');
    } catch (e) {
      SnackbarUtils.showErrorSnackbar('$e');
    }
  }
}