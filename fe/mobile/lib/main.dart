import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'repository/job_repos.dart';
import 'routes/routes.dart';
import 'view_models/application_view_model.dart';
import 'view_models/auth_view_model.dart';
import 'view_models/job_view_model.dart';
import 'view_models/user_view_model.dart';

void main() {
  Get.put(AuthViewModel());
  Get.put(UserViewModel());
  Get.put(ApplicationViewModel());
  Get.lazyPut<JobViewModel>(() => JobViewModel(jobRepository: JobRepository()));
  runApp(MainPage());
}

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Job Finder',
        initialRoute: AppRoutes.splash,
        routes: AppRoutes.routes);
  }
}
