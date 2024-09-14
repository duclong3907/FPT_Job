import 'package:flutter/material.dart';
import '../widgets/header.dart';
import '../widgets/job_list.dart';
import '../widgets/search_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              const Header(),
              const CustomSearchBar(),
              const Padding(
                padding: EdgeInsets.only(top: 30, left: 16, right: 16,bottom: 10),
                child: Row(
                  children: [
                    Text(
                      'Recent jobs',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    SizedBox(width: 15),
                    Text(
                      'All Jobs',
                      style: TextStyle(fontWeight: FontWeight.w300, fontSize: 20),
                    ),
                  ],
                ),
              ),
              JobList(),
            ],
          ),
        ),
      ),
    );
  }
}