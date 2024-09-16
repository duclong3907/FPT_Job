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
}