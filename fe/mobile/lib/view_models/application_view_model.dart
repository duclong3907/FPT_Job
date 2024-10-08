import 'package:get/get.dart';
import '../models/application/application_model.dart';
import '../repository/application_repos.dart';
import '../utils/snackbar_get.dart';
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
      // SnackbarUtils.showErrorSnackbar('$e');
    }
  }

  Future<void> addApplication(Map<String, String> requestBody) async {
    try {
      await _applicationRepository.addApplication(requestBody);
      SnackbarUtils.showSuccessSnackbar('You applied successfully!');
    } catch (e) {
      print('Error adding application: $e');
      SnackbarUtils.showErrorSnackbar('$e');
    }
  }

  Future<void> fetchUserApplications(String userId) async {
    isLoading.value = true;
    userAppliedJobIds.clear();
    try {
      print('Fetching applications for user: $userId');
      final fetchedApplications = await _applicationRepository.fetchUserApplications(userId);
      applications.value = fetchedApplications;
      userAppliedJobIds.value = fetchedApplications.map((application) => application.jobId).toList();
      print('Fetched applications: $fetchedApplications');
      print('User applied job IDs: ${userAppliedJobIds.value}');
    } catch (e) {
      print('Error fetching user applications: $e');
      // SnackbarUtils.showErrorSnackbar('$e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchApplicationsForJob(int jobId) async {
    isLoading.value = true;
    jobApplications.clear();
    try {
      var applications = await _applicationRepository.fetchApplicationsForJob(jobId);
      jobApplications.assignAll(applications.where((app) => app.jobId == jobId).toList());

    } catch (e) {
      print('Error fetching applications for job $jobId: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateApplication(int applicationId, Map<String, String> requestBody) async{
    try {
      await _applicationRepository.updateApplication(applicationId, requestBody);
      int index = jobApplications.indexWhere((app) => app.id == applicationId);
      if (index != -1) {
        jobApplications[index].status = requestBody['status']!;
      }
      // SnackbarUtils.showSuccessSnackbar('Updated successfully!');
    } catch (e) {
      print('Error updating application: $e');
      SnackbarUtils.showErrorSnackbar('$e');
    }
  }

}