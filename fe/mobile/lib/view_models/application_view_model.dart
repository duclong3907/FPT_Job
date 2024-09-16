import 'package:get/get.dart';
import '../models/application/application_model.dart';
import '../repository/application_repos.dart';

class ApplicationViewModel extends GetxController {
  var applications = <Application>[].obs;
  final ApplicationRepository _applicationRepository = ApplicationRepository();

  @override
  void onInit() {
    fetchApplications();
    super.onInit();
  }

  Future<void> fetchApplications() async {
    try {
      var result = await _applicationRepository.fetchApplications();
      applications.value = result;
    } catch (e) {
      print('Error fetching applications: $e');
      Get.snackbar('Error', '$e');
    }
  }

  Future<void> addApplication(Map<String, String> requestBody) async {
    try {
      await _applicationRepository.addApplication(requestBody);
      Get.snackbar('Alert', 'Apply successfully');
    } catch (e) {
      print('Error adding application: $e');
      Get.snackbar('Error', '$e');
    }
  }
}