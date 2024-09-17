import 'package:get/get.dart';
import '../models/application/application_model.dart';
import '../repository/application_repos.dart';
import 'auth_view_model.dart';

class ApplicationViewModel extends GetxController {
  var applications = <Application>[].obs;
  final ApplicationRepository _applicationRepository = ApplicationRepository();
  var isLoading = false.obs;
  var userAppliedJobIds = <int>[].obs;
  var jobApplications = <Application>[].obs;

  @override
  void onInit() {
    super.onInit();
    final userId = Get.find<AuthViewModel>().userId.value;
    print('User ID in ApplicationViewModel: $userId');
    if (userId.isNotEmpty) {
      fetchUserApplications(userId);
    }
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

  Future<void> fetchUserApplications(String userId) async {
    isLoading.value = true;
    try {
      print('Fetching applications for user: $userId');
      final fetchedApplications = await _applicationRepository.fetchUserApplications(userId);
      applications.value = fetchedApplications;
      userAppliedJobIds.value = fetchedApplications.map((application) => application.jobId).toList();
      print('Fetched applications: $fetchedApplications');
      print('User applied job IDs: ${userAppliedJobIds.value}');
    } catch (e) {
      print('Error fetching user applications: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchApplicationsForJob(int jobId) async {
    isLoading.value = true;
    try {
      var applications = await _applicationRepository.fetchApplicationsForJob(jobId);
      jobApplications.assignAll(applications);
    } catch (e) {
      print(e);
      Get.snackbar('Error', '$e');
    } finally {
      isLoading.value = false;
    }
  }

}