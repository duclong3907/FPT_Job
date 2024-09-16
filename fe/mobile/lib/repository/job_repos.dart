import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/category/job_category_model.dart';
import '../models/job/job_model.dart';
import '../config/config_http.dart';
import '../models/user/user_response_model.dart';
import '../config/database_helper.dart';

class JobRepository {
  String baseUrl = baseUrlApi;
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<List<Job>> fetchJobs() async {
    try {
      final url = Uri.parse('$baseUrl/Job');
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
        final Map<String, dynamic> errorResponse = json.decode(response.body);
        throw Exception(errorResponse["message"]);
      }
    } catch (e) {
      throw Exception('Error fetching jobs: $e');
    }
  }

  Future<Job> fetchJobById(int id) async {
    try {
      final url = Uri.parse('$baseUrl/Job/$id');

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

        final categoryResponse = await http.get(categoryUrl, headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        });

        if (categoryResponse.statusCode == 200) {
          job.jobCategory = JobCategory.fromJson(json.decode(categoryResponse.body));
        } else {
          throw Exception('Failed to load job category');
        }

        if(employerUrl != null){
          final employerResponse = await http.get(employerUrl, headers: {
            'Content-Type': 'application/json; charset=UTF-8',
          });
          if (employerResponse.statusCode == 200) {
            job.employer = UserResponse.fromJson(json.decode(employerResponse.body));
          } else {
            final Map<String, dynamic> errorResponse = json.decode(response.body);
            throw Exception(errorResponse["message"]);
          }
        }

        return job;
      } else {
        final Map<String, dynamic> errorResponse = json.decode(response.body);
        throw Exception(errorResponse["message"]);
      }
    } catch (e) {
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

  // Future<void> saveFavorites(List<Job> jobs, String userId) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final favoriteJobs = jobs.where((job) => job.isFavorite).map((job) => job.id).toList();
  //   await prefs.setStringList('favoriteJobs_$userId', favoriteJobs.map((id) => id.toString()).toList());
  // }
  //
  // Future<void> loadFavorites(List<Job> jobs, String userId) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final favoriteJobIds = prefs.getStringList('favoriteJobs_$userId')?.map((id) => int.parse(id)).toList() ?? [];
  //   for (var job in jobs) {
  //     if (favoriteJobIds.contains(job.id)) {
  //       job.isFavorite = true;
  //     }
  //   }
  // }

  Future<void> insertFavorite(int jobId, String userId) async {
    await _dbHelper.insertFavorite(jobId, userId);
  }

  Future<void> deleteFavorite(int jobId, String userId) async {
    await _dbHelper.deleteFavorite(jobId, userId);
  }

  Future<List<int>> getFavorites(String userId) async {
    return await _dbHelper.getFavorites(userId);
  }

}