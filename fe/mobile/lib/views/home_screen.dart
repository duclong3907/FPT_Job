import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/category/job_category_model.dart';
import '../repository/category_repos.dart';
import '../repository/job_repos.dart';
import '../view_models/job_categories_view_model.dart';
import '../view_models/job_view_model.dart';
import '../widgets/header.dart';
import '../widgets/job_list.dart';
import '../widgets/search_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? selectedCategoryName;
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final JobViewModel jobViewModel = Get.put(JobViewModel(jobRepository: JobRepository()));
    final JobCategoryViewModel jobCategoryViewModel = Get.put(JobCategoryViewModel(jobCategoryRepository: JobCategoryRepository()));

    return Scaffold(
      body: SafeArea(
        child: Scaffold(
          body: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Column(
              children: [
                const Header(),
                CustomSearchBar(
                  searchController: searchController,
                  onSearch: (query) {
                    jobViewModel.searchJobs(query);
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30, left: 16, right: 16, bottom: 10),
                  child: Row(
                    children: [
                      const Text(
                        'All jobs',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      const SizedBox(width: 15),
                      Obx(() {
                        if (jobCategoryViewModel.isLoading.value) {
                          return Center(child: CircularProgressIndicator());
                        } else {
                          return DropdownButton<String>(
                            hint: Text(selectedCategoryName ?? 'All'),
                            dropdownColor: Colors.white,
                            style: TextStyle(color: Colors.black, fontSize: 16),
                            underline: SizedBox(),
                            icon: Icon(Icons.arrow_drop_down, color: Colors.black),
                            items: [
                             const DropdownMenuItem<String>(
                                value: 'All',
                                child: Text('All'),
                              ),
                              ...jobCategoryViewModel.jobCategories.map((JobCategory category) {
                                return DropdownMenuItem<String>(
                                  value: category.id.toString(),
                                  child: Text(category.name),
                                );
                              }).toList(),
                            ],
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  if (value == 'All') {
                                    selectedCategoryName = 'All';
                                    jobViewModel.fetchJobs();
                                  } else {
                                    selectedCategoryName = jobCategoryViewModel.jobCategories
                                        .firstWhere((category) => category.id.toString() == value)
                                        .name;
                                    jobViewModel.fetchJobsByCategory(int.parse(value));
                                  }
                                });
                              }
                            },
                          );
                        }
                      }),
                    ],
                  ),
                ),
                JobList(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}