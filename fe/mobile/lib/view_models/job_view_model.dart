import 'package:get/get.dart';
import '../models/job/job_model.dart';
import '../repository/job_repos.dart';

class JobViewModel extends GetxController {
  final JobRepository jobRepository;
  var jobs = <Job>[].obs;
  var isLoading = false.obs;
  var allJobs = <Job>[].obs;
  var selectedJob = Rxn<Job>();

  JobViewModel({required this.jobRepository});

  @override
  void onInit() {
    fetchJobs();
    super.onInit();
  }

  Future<void> fetchJobs() async {
    isLoading.value = true;
    try {
      var jobList = await jobRepository.fetchJobs();
      jobList.sort((a, b) => b.updatedAt?.compareTo(a.updatedAt!) ?? 0);
      jobs.assignAll(jobList);
      allJobs.assignAll(jobList); // Populate allJobs
    } catch (e) {
      Get.snackbar('Error', '$e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchJobById(int id) async {
    try {
      isLoading.value = true;
      selectedJob.value = await jobRepository.fetchJobById(id);
    } catch (e) {
      Get.snackbar('Error', '$e');
    } finally {
      isLoading.value = false;
    }
  }


  void searchJobs(String query) {
    if (query.isEmpty) {
      jobs.assignAll(allJobs);
    } else {
      final filteredJobs = allJobs.where((job) => job.title.toLowerCase().contains(query.toLowerCase())).toList();
      jobs.assignAll(filteredJobs);
    }
  }

  Future<void> fetchJobsByCategory(int categoryId) async {
    isLoading.value = true;
    try {
      var jobList = await jobRepository.fetchJobsByCategory(categoryId);
      jobList.sort((a, b) => b.updatedAt?.compareTo(a.updatedAt!) ?? 0);
      jobs.assignAll(jobList);
      allJobs.assignAll(jobList);
    } catch (e) {
      Get.snackbar('Error', '$e');
    } finally {
      isLoading.value = false;
    }
  }
}
