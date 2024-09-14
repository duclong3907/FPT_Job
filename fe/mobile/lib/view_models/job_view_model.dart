import 'package:get/get.dart';
import '../models/job_model.dart';
import '../repository/job_repos.dart';

class JobViewModel extends GetxController {
  final JobRepository jobRepository;
  var jobs = <Job>[].obs;
  var isLoading = false.obs;
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
    } catch (e) {
      Get.snackbar('Error fetching jobs', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchJobById(int id) async {
    try {
      selectedJob.value = await jobRepository.fetchJobById(id);
    } catch (e) {
      Get.snackbar('Error fetching jobs', e.toString());
    }
  }
}
