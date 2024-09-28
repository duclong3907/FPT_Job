// lib/views/job_application_screen.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/application/application_model.dart';
import '../services/signalr_service.dart';
import '../view_models/application_view_model.dart';

final ApplicationViewModel applicationViewModel = Get.find<ApplicationViewModel>();
final SignalRService signalRService = Get.find<SignalRService>();

class JobApplicationsPage extends StatelessWidget {
  final int jobId;
  final ValueNotifier<List<Application>> jobApplicationsNotifier;

  JobApplicationsPage({required this.jobId})
      : jobApplicationsNotifier = ValueNotifier(applicationViewModel.jobApplications);

  @override
  Widget build(BuildContext context) {
    _fetchApplications();
    signalRService.refreshJobApplications.listen((refreshData) {
      final jobIdToRefresh = refreshData['jobId'];
      final shouldRefresh = refreshData['refresh'] == true;

      if (jobIdToRefresh != null && jobIdToRefresh == jobId && shouldRefresh) {
        _fetchApplications();
        signalRService.refreshJobApplications.value = {'jobId': null, 'refresh': false};
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Job Applications'),
      ),
      body: ValueListenableBuilder<List<Application>>(
        valueListenable: jobApplicationsNotifier,
        builder: (context, jobApplications, child) {
          if (applicationViewModel.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          } else if (jobApplications.isEmpty) {
            return const Center(child: Text('No applications found.'));
          } else {
            return ListView.builder(
              itemCount: jobApplications.length,
              itemBuilder: (context, index) {
                final application = jobApplications[index];
                return InkWell(
                  child: ListTile(
                    leading: application.image != null
                        ? CircleAvatar(
                      radius: 30,
                      backgroundImage: application.image!.startsWith('http')
                          ? NetworkImage(application.image!)
                          : MemoryImage(
                        base64Decode(
                          application.image!.replaceFirst(
                              RegExp(r'data:image/[^;]+;base64,'), ''),
                        ),
                      ) as ImageProvider,
                    )
                        : CircleAvatar(
                      radius: 30,
                      child: Icon(Icons.person),
                    ),
                    title: Text(application.fullName ?? 'No Name'),
                    subtitle: Text(application.userEmail ?? 'No Email'),
                  ),
                  onTap: () => Get.dialog(_ShowDetail(application: application)),
                );
              },
            );
          }
        },
      ),
    );
  }

  void _fetchApplications() async {
    await applicationViewModel.fetchApplicationsForJob(jobId);
    jobApplicationsNotifier.value = applicationViewModel.jobApplications;
  }
}

class _ShowDetail extends StatelessWidget {
  Application application;
  ValueNotifier<String> statusNotifier;
  _ShowDetail({required this.application})
      : statusNotifier = ValueNotifier(application.status ?? 'No Status');

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SingleChildScrollView(
        child: Column(
          children: [
            if (application.image != null)
              CircleAvatar(
                radius: 70,
                backgroundImage: application.image!.startsWith('http')
                    ? NetworkImage(application.image!)
                    : MemoryImage(
                  base64Decode(
                    application.image!.replaceFirst(
                        RegExp(r'data:image/[^;]+;base64,'), ''),
                  ),
                ) as ImageProvider,
              )
            else
              const CircleAvatar(
                radius: 30,
                child: Icon(Icons.person),
              ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Text('Name: ', style: TextStyle(fontWeight: FontWeight.bold)),
                Text(application.fullName ?? 'No Name'),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Text('Email: ', style: TextStyle(fontWeight: FontWeight.bold)),
                Text(application.userEmail ?? 'No Email'),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Text('Resume: ', style: TextStyle(fontWeight: FontWeight.bold)),
                Expanded(
                  child: Text(
                    application.resume,
                    softWrap: true,
                    overflow: TextOverflow.visible,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Text('Cover Letter: ', style: TextStyle(fontWeight: FontWeight.bold)),
                Expanded(
                  child: Text(
                    application.coverLetter ?? 'No Cover Letter',
                    softWrap: true,
                    overflow: TextOverflow.visible,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Text('Self Introduction: ', style: TextStyle(fontWeight: FontWeight.bold)),
                Expanded(
                  child: Text(
                    application.selfIntroduction ?? 'No Self Introduction',
                    softWrap: true,
                    overflow: TextOverflow.visible,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Text('Status: ', style: TextStyle(fontWeight: FontWeight.bold)),
                ValueListenableBuilder<String>(
                  valueListenable: statusNotifier,
                  builder: (context, status, child) {
                    return Expanded(
                      child: Row(
                        children: [
                          Text(status),
                          const Spacer(),
                          Icon(
                            status == 'pending'
                                ? Icons.pending_actions
                                : status == 'accepted'
                                ? Icons.check_circle
                                : Icons.cancel,
                            color: status == 'pending'
                                ? Colors.orange
                                : status == 'accepted'
                                ? Colors.green
                                : Colors.red,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            updateApplication('rejected');
          },
          child: Text('Reject'),
        ),
        TextButton(
          onPressed: () {
            updateApplication('accepted');
          },
          child: Text('Approve'),
        ),
        TextButton(
          onPressed: () {
            Get.back();
          },
          child: Text('Close'),
        ),
      ],
    );
  }

  void updateApplication(String status) {
    applicationViewModel.updateApplication(application.id!, {
      'resume': application.resume,
      'coverLetter': application.coverLetter,
      'selfIntroduction': application.selfIntroduction,
      'jobId': application.jobId.toString(),
      'userId': application.userId,
      'createdAt': application.createdAt.toString(),
      'updatedAt': application.updatedAt.toString(),
      'status': status,
    });
    statusNotifier.value = status;
  }
}