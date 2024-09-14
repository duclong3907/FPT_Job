import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/job_model.dart';
import '../config/config_http.dart';

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
        return Job.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load job');
      }
    } catch (e) {
      throw Exception('Error fetching job');
    }
  }

}
