import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../view_models/job_view_model.dart';
import 'job_list_widget.dart';

class JobList extends StatelessWidget {
  final jobViewModel = Get.find<JobViewModel>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (jobViewModel.jobs.isEmpty) {
        return Center(child: CircularProgressIndicator());
      }
      return Expanded(
        child: JobListWidget(jobs: jobViewModel.jobs),
      );
    });
  }
}