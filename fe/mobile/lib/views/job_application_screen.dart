// lib/views/job_application_screen.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/application/application_model.dart';
import '../view_models/application_view_model.dart';

class JobApplicationsPage extends StatelessWidget {
  final int jobId;
  final ApplicationViewModel applicationViewModel = Get.find<ApplicationViewModel>();

  JobApplicationsPage({required this.jobId});

  @override
  Widget build(BuildContext context) {
    applicationViewModel.fetchApplicationsForJob(jobId);

    return Scaffold(
      appBar: AppBar(
        title: Text('Job Applications'),
      ),
      body: Obx(() {
        if (applicationViewModel.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        } else if (applicationViewModel.jobApplications.isEmpty) {
          return Center(child: Text('No applications found.'));
        } else {
          return ListView.builder(
            itemCount: applicationViewModel.jobApplications.length,
            itemBuilder: (context, index) {
              final application = applicationViewModel.jobApplications[index];
              return InkWell(
                child: ListTile(
                  leading: application.image != null
                      ? CircleAvatar(
                    radius: 30,
                    backgroundImage: MemoryImage(
                      base64Decode(
                        application.image!.replaceFirst('data:image/jpeg;base64,', ''),
                      ),
                    ),
                  )
                      : const CircleAvatar(
                    radius: 30,
                    child: Icon(Icons.person),
                  ),
                  title: Text(application.fullName ?? 'No Name'),
                  subtitle: Text(application.userEmail ?? 'No Email'),
                ),
                onTap: () {
                  _showDetail(context, application);
                },
              );
            },
          );
        }
      }),
    );
  }

  void _showDetail(BuildContext context, Application application) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: Column(
              children: [
                if (application.image != null)
                  CircleAvatar(
                    radius: 70,
                    backgroundImage: MemoryImage(
                      base64Decode(
                        application.image!.replaceFirst('data:image/jpeg;base64,', ''),
                      ),
                    ),
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
                    Text(application.status!),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}