import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../config/config_html.dart';
import '../models/job/job_model.dart';
import '../utils/snackbar_get.dart';
import '../utils/time_ago.dart';
import '../view_models/application_view_model.dart';
import '../view_models/auth_view_model.dart';
import '../view_models/job_view_model.dart';
import '../widgets/custom_image_widget.dart';

class JobDetailScreen extends StatelessWidget {
  final int jobId;
  JobDetailScreen({required this.jobId});

  @override
  Widget build(BuildContext context) {
    final JobViewModel jobViewModel = Get.find<JobViewModel>();

    //tranh loi setState() hoặc markNeedsBuild() called during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      jobViewModel.fetchJobById(jobId);
    });

    return Scaffold(
      body: Obx(() {
        if (jobViewModel.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        } else if (jobViewModel.selectedJob.value == null) {
          return Center(child: Text('Job not found.'));
        } else {
          final job = jobViewModel.selectedJob.value!;
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 300,
                pinned: true,
                floating: true,
                elevation: 50,
                flexibleSpace: FlexibleSpaceBar(
                  background: CustomImageWidget(imagePath: job.image!),
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    JobMeta(job: job),
                    JobContent(job: job),
                    const JobTags(),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 16),
                      height: 16,
                      color: Colors.grey[300],
                    ),
                  ],
                ),
              ),
            ],
          );
        }
      }),
    );
  }
}

class JobMeta extends StatelessWidget {
  final Job? job;

  const JobMeta({
    super.key,
    required this.job,
  });

  @override
  Widget build(BuildContext context) {
    final AuthViewModel authViewModel = Get.find<AuthViewModel>();
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            '${job!.title}',
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 16),
          ListTile(
            contentPadding: const EdgeInsets.all(0),
            leading: job!.employer?.image != null
                ? CircleAvatar(
                    radius: 30, // Increase the radius to make it larger
                    backgroundImage: job!.employer!.image!.startsWith('http')
                        ? NetworkImage(job!.employer!.image!)
                        : MemoryImage(
                            base64Decode(
                              job!.employer!.image!.replaceFirst(
                                  RegExp(r'data:image/[^;]+;base64,'), ''),
                            ),
                          ) as ImageProvider,
                  )
                : CircleAvatar(
                    radius: 30,
                    child: Icon(Icons.person),
                  ),
            title: Text(
                job?.employer?.fullName != null && job!.employer!.fullName != ''
                    ? job!.employer!.fullName
                    : job?.employer?.user?.email ?? 'Unknown'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (job!.employer!.company != null)
                  Text(
                    'Company: ${job!.employer!.company}',
                  ),
                Text(
                  "${job!.updatedAt != null ? timeAgo(job!.updatedAt!) : 'Unknown date'}",
                ),
              ],
            ),
            trailing: ElevatedButton(
              onPressed: () {
                if (authViewModel.isLoggedIn.value) {
                  if (authViewModel.role.value == 'Admin') {
                    SnackbarUtils.showWarningSnackbar(
                        'Admin cannot apply for a job!');
                  } else if (authViewModel.role.value == 'Employer') {
                    SnackbarUtils.showWarningSnackbar(
                        'Employer cannot apply for a job!');
                  } else {
                    _showAddApplicationDialog(context);
                  }
                } else {
                  SnackbarUtils.showWarningSnackbar(
                      'You must be logged in to apply for a job!');
                }
              },
              child: const Text(
                'Apply',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  void _showAddApplicationDialog(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final TextEditingController _resumeController = TextEditingController();
    final TextEditingController _coverLetterController =
        TextEditingController();
    final TextEditingController _selfIntroductionController =
        TextEditingController();
    final TextEditingController _jobIdController = TextEditingController();
    final AuthViewModel authViewModel = Get.find<AuthViewModel>();
    final ApplicationViewModel _applicationViewModel =
        Get.find<ApplicationViewModel>();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Application'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _resumeController,
                  decoration: InputDecoration(labelText: 'Resume'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter resume';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _coverLetterController,
                  decoration: InputDecoration(labelText: 'Cover Letter'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter cover letter';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _selfIntroductionController,
                  decoration: InputDecoration(labelText: 'Self Introduction'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter self introduction';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  Map<String, String> applicationData = {
                    'resume': _resumeController.text,
                    'coverLetter': _coverLetterController.text,
                    'selfIntroduction': _selfIntroductionController.text,
                    'status': 'pending', // Default status
                    'jobId': job!.id.toString(),
                    'userId': authViewModel.userId.value,
                  };

                  _applicationViewModel.addApplication(applicationData);
                  Navigator.of(context).pop();
                }
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }
}

class JobContent extends StatelessWidget {
  final Job? job;

  const JobContent({
    super.key,
    required this.job,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Category: ${job?.jobCategory!.name ?? 'N/A'}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontStyle: FontStyle.italic,
                  color: Colors.grey[600],
                  fontSize: 20,
                ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(Icons.alarm, size: 16, color: Colors.black),
              const SizedBox(width: 6),
              Text(
                  'Deadline: ${DateFormat('dd/MM/yyyy').format(job!.applicationDeadline)}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                        fontSize: 20,
                      )),
            ],
          ),
          const SizedBox(height: 16),
          Text(
              textAlign: TextAlign.justify,
              'Skill Requirement: ${job!.skillRequired}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                    fontSize: 20,
                  )),
          const SizedBox(height: 16),
          Text('Salary: \$${job!.salaryRange} / Year',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                    fontSize: 20,
                  )),
          const SizedBox(height: 16),
          Text('Description', style: TextStyle(fontSize: 20)),
          const SizedBox(height: 16),
          Text(
              textAlign: TextAlign.justify,
              stripHtmlTags(job!.description),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                    fontSize: 16,
                  )),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class JobTags extends StatelessWidget {
  const JobTags({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Wrap(
        spacing: 8,
        children: [
          Chip(label: Text('Science')),
          Chip(label: Text('Technology')),
          Chip(label: Text('Devices')),
        ],
      ),
    );
  }
}
