import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/job/job_model.dart';
import '../utils/snackbar_get.dart';
import '../utils/time_ago.dart';
import '../view_models/job_view_model.dart';
import 'custom_image_widget.dart';

class itemCard extends StatelessWidget {
  const itemCard({super.key, required this.job});
  final Job job;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          CardBanner(image: job.image ?? "", job: job),
          CardDetail(job: job),
        ],
      ),
    );
  }
}

class CardBanner extends StatelessWidget {
  const CardBanner({super.key, required this.image, required this.job});
  final String image;
  final Job job;
  @override
  Widget build(BuildContext context) {
    final jobViewModel = Get.find<JobViewModel>();
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
            onPressed: () {
              jobViewModel.toggleFavorite(job);
              SnackbarUtils.showSuccessSnackbar(
                  'Favorite status changed');
            },
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