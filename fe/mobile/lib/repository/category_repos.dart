import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../config/config_http.dart';
import '../models/category/job_category_model.dart';

class JobCategoryRepository {
  final String apiUrl = "https://192.168.1.5:5001/api/Categories";

  Future<List<JobCategory>> fetchJobCategories() async {
    final response = await http.get(Uri.parse(apiUrl));
    HttpOverrides.global = MyHttpOverrides();
    if (response.statusCode == 200) {
      print('Response body: ${response.body}'); // Print the response body for debugging
      Map<String, dynamic> body = json.decode(response.body);
      List<dynamic> categoriesJson = body['jobCategories']; // Use the correct key 'jobCategories'
      if (categoriesJson == null) {
        throw Exception('Categories not found in the response');
      }
      List<JobCategory> jobCategories = categoriesJson
          .map(
            (dynamic item) => JobCategory.fromJson(item),
      )
          .toList();
      return jobCategories;
    } else {
      throw Exception('Failed to load job categories');
    }
  }


}