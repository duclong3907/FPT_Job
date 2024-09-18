import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile/view_models/auth_view_model.dart';
import '../models/job/job_model.dart';
import '../views/job_application_screen.dart';
import '../views/job_detail_screen.dart';
import 'item_card_widget.dart';

class JobListWidget extends StatelessWidget {
  final List<Job> jobs;
  final String source;

  const JobListWidget({super.key, required this.jobs, required this.source});

  @override
  Widget build(BuildContext context) {
    AuthViewModel authViewModel = Get.find<AuthViewModel>();
    return ListView.builder(
      itemCount: jobs.length,
      itemBuilder: (context, index) {
        final job = jobs[index];
        return GestureDetector(
          child: Card(
            margin: EdgeInsets.all(16),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: LayoutBuilder(builder: (context, constraints) {
              return itemCard(job: job);
            }),
          ),
          onTap: () {
            if(source == 'detail_application_job'){
              Get.to(() => JobApplicationsPage(jobId: job.id));
              return;
            }
            if(source == 'detail_job'){
              Get.to(() => JobDetailScreen(jobId: job.id));
              return;
            }
          },
        );
      },
    );
  }
}

