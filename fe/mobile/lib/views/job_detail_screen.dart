import 'dart:convert';
import 'package:intl/intl.dart';
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
            leading: job!.employer?.image != null
                ? CircleAvatar(
              radius: 30, // Increase the radius to make it larger
              backgroundImage: MemoryImage(
                  base64Decode(
                    job!.employer!.image!
                        .replaceFirst('data:image/jpeg;base64,', ''),
                  )
              ),
            )
                : CircleAvatar(
              radius: 30,
              child: Icon(Icons.person),
            ),
            title: Text(
                job?.employer?.fullName != null && job!.employer!.fullName != ''
                    ? job!.employer!.fullName
                    : job?.employer?.user?.email ?? 'Unknown'),
            subtitle: Text(
              "${job!.updatedAt != null ? timeAgo(job!.updatedAt!) : 'Unknown date'}",
            ),
            trailing: ElevatedButton(
              onPressed: () {
                Get.snackbar('Apply', 'You have applied for this job');
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
                    fontSize: 20,)
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            textAlign: TextAlign.justify,
              'Skill Requirement: ${job!.skillRequired}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
                fontSize: 20,)
          ),
          const SizedBox(height: 16),
          Text('Salary: \$${job!.salaryRange} / Year',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
              fontSize: 20,)
          ),
          const SizedBox(height: 16),

          Text('Description', style: TextStyle(fontSize: 20)),
          const SizedBox(height: 16),
          Text(
            textAlign: TextAlign.justify,
            stripHtmlTags(job!.description),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
              fontSize: 16,)
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
