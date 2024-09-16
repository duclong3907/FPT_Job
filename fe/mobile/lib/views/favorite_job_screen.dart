import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../view_models/job_view_model.dart';
import 'job_detail_screen.dart';

class FavoriteJobsPage extends StatelessWidget {
  final JobViewModel jobViewModel = Get.find<JobViewModel>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Jobs'),
      ),
      body: Obx(() {
        if (jobViewModel.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        } else {
          final favoriteJobs = jobViewModel.jobs.where((job) => jobViewModel.isFavorite(job)).toList();
          if (favoriteJobs.isEmpty) {
            return Center(child: Text('No favorite jobs found.'));
          } else {
            return ListView.builder(
              itemCount: favoriteJobs.length,
              itemBuilder: (context, index) {
                final job = favoriteJobs[index];
                return ListTile(
                  title: Text(job.title),
                  subtitle: Text(job.jobCategory?.name ?? 'Unknown category'),
                  onTap: () {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => JobDetailScreen(jobId: job.id),
                        ),
                      );
                    });
                  },
                );
              },
            );
          }
        }
      }),
    );
  }
}