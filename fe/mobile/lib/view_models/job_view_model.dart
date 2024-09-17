import 'package:get/get.dart';
import '../models/job/job_model.dart';
import '../repository/job_repos.dart';
import '../utils/snackbar_get.dart';
import 'auth_view_model.dart';

class JobViewModel extends GetxController {
  final JobRepository jobRepository;
  var jobs = <Job>[].obs;
  var isLoading = false.obs;
  var allJobs = <Job>[].obs;
  var selectedJob = Rxn<Job>();
  var userId = ''.obs;
  var favoriteJobIds = <int>[].obs;
  var postedJobs = <Job>[].obs;


  JobViewModel({required this.jobRepository});

  @override
  void onInit() {
    fetchJobs();
    fetchJobsPostByEmployer(Get.find<AuthViewModel>().userId.value);
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
      SnackbarUtils.showErrorSnackbar('$e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchJobById(int id) async {
    try {
      isLoading.value = true;
      selectedJob.value = await jobRepository.fetchJobById(id);
    } catch (e) {
      print(e);
      SnackbarUtils.showErrorSnackbar('$e');
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
      SnackbarUtils.showErrorSnackbar('$e');
    } finally {
      isLoading.value = false;
    }
  }

  void toggleFavorite(Job job) async {
    final userId = Get.find<AuthViewModel>().userId.value;
    if (favoriteJobIds.contains(job.id)) {
      favoriteJobIds.remove(job.id);
      await jobRepository.deleteFavorite(job.id, userId);
    } else {
      favoriteJobIds.add(job.id);
      await jobRepository.insertFavorite(job.id, userId);
    }
    jobs.refresh();
  }

  Future<void> loadFavorites(String userId) async {
    this.userId.value = userId;
    favoriteJobIds.assignAll(await jobRepository.getFavorites(userId));
    jobs.refresh();
  }

  bool isFavorite(Job job) {
    return favoriteJobIds.contains(job.id);
  }

  Future<void> login(String userId) async {
    this.userId.value = userId;
    await loadFavorites(userId);
  }


  Future<void> fetchJobsPostByEmployer(String employerId) async {
    isLoading.value = true;
    try {
      var jobList = await jobRepository.fetchJobsPostByEmployer(employerId);
      postedJobs.assignAll(jobList);
    } catch (e) {
      SnackbarUtils.showErrorSnackbar('$e');
    } finally {
      isLoading.value = false;
    }
  }

}
