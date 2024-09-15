import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile/models/job/job_model.dart';
import '../repository/job_repos.dart';
import '../utils/time_ago.dart';
import '../view_models/job_view_model.dart';
import '../views/job_detail_screen.dart';

class JobList extends StatelessWidget {
  // final jobViewModel = Get.put(JobViewModel(jobRepository: JobRepository()));
  final jobViewModel = Get.find<JobViewModel>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (jobViewModel.jobs.isEmpty) {
        return Center(child: CircularProgressIndicator());
      }
      return Expanded(
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: jobViewModel.jobs.length,
          itemBuilder: (context, index) {
            final job = jobViewModel.jobs[index];
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
              onTap: () => Get.to(() => JobDetailScreen(jobId: job.id)),
            );
          },
        ),
      );
    });
  }
}

class itemCard extends StatelessWidget {
  const itemCard({super.key, required this.job});
  final Job job;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          CardBanner(image: job.image ?? ""),
          CardDetail(job: job),
        ],
      ),
    );
  }
}

class CardBanner extends StatelessWidget {
  const CardBanner({super.key, required this.image});
  final String image;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
          child: CustomImageWidget(imagePath: image),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: IconButton(
            onPressed: () {},
            icon: Icon(Icons.bookmark_border),
          ),
        )
      ],
    );
  }
}

class CardDetail extends StatelessWidget {
  const CardDetail({super.key, required this.job});

  final Job job;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            job.title,
            maxLines: 2,
            style: TextStyle(fontSize: 24),
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(Icons.alarm, size: 16),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        job.updatedAt != null
                            ? timeAgo(job.updatedAt!)
                            : 'Unknown date',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              Spacer(flex: 1),
              Icon(Icons.attach_money_outlined, size: 16),
              Expanded(
                child: Text(
                  '${job.salaryRange} / Year',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class CustomImageWidget extends StatelessWidget {
  final String imagePath;

  CustomImageWidget({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 200,
      child: imagePath.startsWith('data:image')
          ? Image.memory(
              base64Decode(imagePath.split(',').last),
              fit: BoxFit.cover,
            )
          : Image.network(
              imagePath,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, progress) {
                if (progress == null) return child;
                return Center(child: const CircularProgressIndicator());
              },
            ),
    );
  }
}
