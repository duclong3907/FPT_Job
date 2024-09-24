import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../view_models/auth_view_model.dart';
import '../view_models/job_view_model.dart';
import '../view_models/application_view_model.dart';
import '../widgets/job_list_widget.dart';

class FavoriteJobsPage extends StatefulWidget {
  @override
  _FavoriteJobsPageState createState() => _FavoriteJobsPageState();
}

class _FavoriteJobsPageState extends State<FavoriteJobsPage> {
  final JobViewModel jobViewModel = Get.find<JobViewModel>();
  final ApplicationViewModel applicationViewModel = Get.find<ApplicationViewModel>();
  var authViewModel = Get.find<AuthViewModel>();
  @override
  void initState() {
    super.initState();
    final userId = authViewModel.userId.value;
      applicationViewModel.fetchUserApplications(userId);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Jobs'),
          bottom: TabBar(
            tabs: [
              const Tab(text: 'Favorite'),
              Obx(() {
                return (authViewModel.role.value == 'JobSeeker') ? const Tab(text: 'Applied')
                    : (authViewModel.role.value == 'Employer')  ? const Tab(text: 'Posted Jobs')
                    : (authViewModel.role.value == 'Admin') ? const Tab(text: 'Management Jobs')
                    : const Tab(text: 'Unknown Role');
              }),

            ],
          ),
        ),
        body: TabBarView(
          children: [
            Obx(() {
              if (jobViewModel.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              } else {
                final favoriteJobs = jobViewModel.jobs.where((job) => jobViewModel.isFavorite(job)).toList();
                if (favoriteJobs.isEmpty) {
                  return const Center(child: Text('No favorite jobs found.'));
                } else {
                  return JobListWidget(jobs: favoriteJobs, source: 'detail_job');
                }
              }
            }),
            Obx(() {
              if(authViewModel.role.value == 'JobSeeker'){
                if (applicationViewModel.isLoading.value) {
                  return FutureBuilder(
                    future: Future.delayed(Duration(seconds: 2)),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else {
                        return Center(child: Text('No applications found.'));
                      }
                    },
                  );
                } else {
                  final appliedJobs = jobViewModel.jobs.where((job) => applicationViewModel.userAppliedJobIds.contains(job.id)).toList();
                  if (appliedJobs.isEmpty) {
                    return Center(child: Text('No applied jobs found.'));
                  } else {
                    return JobListWidget(jobs: appliedJobs, source: 'detail_job');
                  }
                }
              } else if(authViewModel.role.value == 'Employer') {
                if (jobViewModel.isLoading.value) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  if (jobViewModel.postedJobs.isEmpty) {
                    return Center(child: Text('No posted jobs found.'));
                  } else {
                    return JobListWidget(jobs: jobViewModel.postedJobs, source: 'detail_application_job');
                  }
                }
              } else {
                return Center(child: Text('Unknown Role'));
              }
            }),
          ],
        ),
      ),
    );
  }
}