import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/category/job_category_model.dart';
import '../models/job/job_model.dart';
import '../config/config_http.dart';
import '../models/user/user_response_model.dart';

class JobRepository {
  String baseUrl = 'https://192.168.1.5:5001/api';

  Future<List<Job>> fetchJobs() async {
    try {
      final url = Uri.parse('$baseUrl/Job');
      print('Fetching jobs from: $url');
      HttpOverrides.global = MyHttpOverrides();
      final response = await http.get(url, headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      });

      if (response.statusCode == 200) {
        // Parse the JSON response
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        List<dynamic> jobsJson = jsonResponse['jobs'];
        List<Job> jobs = jobsJson.map((dynamic item) => Job.fromJson(item)).toList();
        return jobs;
      } else {
        throw Exception('Failed to load jobs');
      }
    } catch (e) {
      throw Exception('Error fetching jobs');
    }
  }

  Future<Job> fetchJobById(int id) async {
    try {
      final url = Uri.parse('$baseUrl/Job/$id');
      print('Fetching job from: $url');

      HttpOverrides.global = MyHttpOverrides();
      final response = await http.get(url, headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      });

      if (response.statusCode == 200) {
        final jobJson = json.decode(response.body);
        Job job = Job.fromJson(jobJson);

        // Fetch JobCategory
        final categoryUrl = Uri.parse('$baseUrl/Categories/${job.jobCategoryId}');
        //Fetch Employer
        final employerUrl = Uri.parse('$baseUrl/User/${job.employerId}');

        print('Fetching job category from: $categoryUrl');
        print('Fetching job employer from: $employerUrl');
        final categoryResponse = await http.get(categoryUrl, headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        });

        if (categoryResponse.statusCode == 200) {
          job.jobCategory = JobCategory.fromJson(json.decode(categoryResponse.body));
        } else {
          print('Failed to load job category: ${categoryResponse.statusCode}');
          throw Exception('Failed to load job category');
        }

        if(employerUrl != null){
          final employerResponse = await http.get(employerUrl, headers: {
            'Content-Type': 'application/json; charset=UTF-8',
          });
          if (employerResponse.statusCode == 200) {
            job.employer = UserResponse.fromJson(json.decode(employerResponse.body));
          } else {
            print('Failed to load employer: ${employerResponse.statusCode}');
            throw Exception('Failed to load employer');
          }
        }

        return job;
      } else {
        print('Failed to load job: ${response.statusCode}');
        throw Exception('Failed to load job: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching job: $e');
      throw Exception('Error fetching job: $e');
    }
  }

  Future<List<Job>> fetchJobsByCategory(int categoryId) async {
    try {
      final url = Uri.parse('$baseUrl/Job');
      print('Fetching jobs from: $url');
      HttpOverrides.global = MyHttpOverrides();
      final response = await http.get(url, headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      });

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = json.decode(response.body);
        final List<dynamic> jobsJson = responseBody['jobs'];
        final List<Job> jobs = jobsJson.map((dynamic item) => Job.fromJson(item)).toList();
        return jobs.where((job) => job.jobCategoryId == categoryId).toList();
      } else {
        throw Exception('Failed to load jobs');
      }
    } catch (e) {
      throw Exception('Error fetching jobs by category: $e');
    }
  }


}