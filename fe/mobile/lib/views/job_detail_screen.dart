import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../config/config_html.dart';
import '../models/job/job_model.dart';
import '../utils/time_ago.dart';
import '../view_models/job_view_model.dart';

class JobDetailScreen extends StatelessWidget {
  final int jobId;

  JobDetailScreen({required this.jobId});

  @override
  Widget build(BuildContext context) {
    final JobViewModel jobViewModel = Get.find();

    return Scaffold(
      body: FutureBuilder(
        future: jobViewModel.fetchJobById(jobId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final job = jobViewModel.selectedJob.value;
            if (job == null) {
              return Center(child: Text('Job not found'));
            }
            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 300,
                  pinned: true,
                  floating: true,
                  elevation: 50,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Image.network(
                      '${job.image}',
                      fit: BoxFit.cover,
                    ),
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
        },
      ),
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
            leading: const CircleAvatar(
              child: Icon(Icons.person),
            ),
            title: Text(job!.employerId),
            subtitle: Text(
              "${job!.updatedAt != null ? timeAgo(job!.updatedAt!) : 'Unknown date'}",
            ),
            trailing: ElevatedButton(
              onPressed: () {},
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
          Text(
            stripHtmlTags(job!.description),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Wrap(
        // Wrap se tu dong chuyen dong khi het khong gian
        spacing: 8, // khoang cach giua cac tag
        children: [
          const Chip(label: Text('Science')), // tao 1 tag
          const Chip(label: Text('Technology')),
          const Chip(label: Text('Devices')),
        ],
      ),
    );
  }
}
