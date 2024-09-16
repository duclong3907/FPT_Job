import 'package:get/get.dart';
import '../models/job/job_model.dart';
import '../repository/job_repos.dart';

class JobViewModel extends GetxController {
  final JobRepository jobRepository;
  var jobs = <Job>[].obs;
  var isLoading = false.obs;
  var allJobs = <Job>[].obs;
  var selectedJob = Rxn<Job>();
  var userId = ''.obs;
  var favoriteJobIds = <int>[].obs;

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
      print(e);
      Get.snackbar('Title', 'Message');
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

  // void toggleFavorite(Job job, String userId) async {
  //   this.userId.value = userId;
  //   job.isFavorite = !job.isFavorite;
  //   jobs.refresh();
  //   await jobRepository.saveFavorites(jobs, userId);
  // }
  //
  // Future<void> loadFavorites() async {
  //   print(this.userId.value);
  //   await jobRepository.loadFavorites(jobs, this.userId.value);
  //   jobs.refresh();
  // }


  void toggleFavorite(Job job, String userId) async {
    this.userId.value = userId;
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

}
