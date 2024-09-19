import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/application/application_model.dart';
import '../config/config_http.dart';

class ApplicationRepository {
  final String baseUrl = baseUrlApi;

  Future<List<Application>> fetchApplications() async {
    HttpOverrides.global = MyHttpOverrides();
    final response = await http.get(Uri.parse('$baseUrl/Application'));

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      List<dynamic> jsonList = jsonResponse['applications'];
      return jsonList.map((json) => Application.fromJson(json)).toList();
    } else {
      final Map<String, dynamic> errorResponse = json.decode(response.body);
      throw Exception(errorResponse["message"]);
    }
  }

  Future<void> addApplication(Map<String, String> requestBody) async {
    HttpOverrides.global = MyHttpOverrides();
    final url = Uri.parse('$baseUrl/Application');
    final body = json.encode(requestBody);

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    if (response.statusCode == 200) {
    } else {
      final Map<String, dynamic> errorResponse = json.decode(response.body);
      throw Exception(errorResponse["message"]);
    }
  }

  Future<List<Application>> fetchUserApplications(String userId) async {
    HttpOverrides.global = MyHttpOverrides();
    print('Fetching applications for user: $userId'); // Kiểm tra xem phương thức có được gọi không
    final response = await http.get(Uri.parse('$baseUrl/Application/User/$userId'));

    print('Response status: ${response.statusCode}'); // Kiểm tra trạng thái phản hồi
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      List<dynamic> jsonList = jsonResponse['applications'];
      print('Fetched applications: $jsonList'); // Kiểm tra dữ liệu nhận được
      return jsonList.map((json) => Application.fromJson(json)).toList();
    } else {
      final Map<String, dynamic> errorResponse = json.decode(response.body);
      print('Error response: $errorResponse'); // Kiểm tra lỗi nếu có
      throw Exception(errorResponse["message"]);
    }
  }

  Future<List<Application>> fetchApplicationsForJob(int jobId) async {
    try {
      final url = Uri.parse('$baseUrl/Job/$jobId/Applications');
      HttpOverrides.global = MyHttpOverrides();
      final response = await http.get(url, headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      });
      print(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = json.decode(response.body);
        final List<dynamic> applicationsJson = responseBody['applications'];
        print(responseBody);
        return applicationsJson.map((json) => Application.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load applications');
      }
    } catch (e) {
      throw Exception('Error fetching applications: $e');
    }
  }

  Future<void> updateApplication(int applicationId, Map<String, String> requestBody) async {
    HttpOverrides.global = MyHttpOverrides();
    final url = Uri.parse('$baseUrl/Application/$applicationId');
    final body = json.encode(requestBody);
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    if (response.statusCode != 200) {
      final Map<String, dynamic> errorResponse = json.decode(response.body);
      throw Exception(errorResponse["message"]);
    }
  }


}