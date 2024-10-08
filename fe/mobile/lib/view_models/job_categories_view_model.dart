import 'package:get/get.dart';
import '../models/category/job_category_model.dart';
import '../repository/category_repos.dart';
import '../utils/snackbar_get.dart';

class JobCategoryViewModel extends GetxController {
  var jobCategories = <JobCategory>[].obs;
  var isLoading = true.obs;
  final JobCategoryRepository jobCategoryRepository;

  JobCategoryViewModel({required this.jobCategoryRepository});

  @override
  void onInit() {
    fetchJobCategories();
    super.onInit();
  }

  void fetchJobCategories() async {
    try {
      isLoading(true);
      var categories = await jobCategoryRepository.fetchJobCategories();
      if (categories != null) {
        jobCategories.assignAll(categories);
      }
    } catch (e) {
      SnackbarUtils.showErrorSnackbar('$e');
    }
    finally {
      isLoading(false);
    }
  }
}