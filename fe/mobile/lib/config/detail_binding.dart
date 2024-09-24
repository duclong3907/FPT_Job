import 'package:get/get.dart';
import '../repository/job_repos.dart';
import '../services/signalr_service.dart';
import '../view_models/application_view_model.dart';
import '../view_models/auth_view_model.dart';
import '../view_models/job_view_model.dart';
import '../view_models/user_view_model.dart';

class DetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthViewModel());
    Get.put(UserViewModel());
    Get.put(ApplicationViewModel());
    Get.lazyPut<JobViewModel>(() => JobViewModel(jobRepository: JobRepository()));
    Get.put(SignalRService());
  }
}