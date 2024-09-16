import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../config/config_http.dart';
import '../models/user/user_response_model.dart';

class UserRepository {
  final String baseUrl = baseUrlApi;

  Future<List<UserResponse>> fetchUsers() async {
    HttpOverrides.global = MyHttpOverrides();
    final response = await http.get(Uri.parse('$baseUrl/User'));

    if (response.statusCode == 200) {
      List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => UserResponse.fromJson(json)).toList();
    } else {
      final Map<String, dynamic> errorResponse = json.decode(response.body);
      throw Exception(errorResponse["message"]);
    }
  }

  Future<UserResponse> getUser(String id) async {
    HttpOverrides.global = MyHttpOverrides();
    print('Fetching user data for id $id from $baseUrl/User/$id');
    final response = await http.get(Uri.parse('$baseUrl/User/$id'));

    if (response.statusCode == 200) {
      return UserResponse.fromJson(json.decode(response.body));
    } else {
      final Map<String, dynamic> errorResponse = json.decode(response.body);
      throw Exception(errorResponse["message"]);
    }
  }

  Future<void> updateUser(String userId, Map<String, String> requestBody) async {
    HttpOverrides.global = MyHttpOverrides();
    final url = Uri.parse('$baseUrl/User/$userId');

    final body = json.encode(requestBody);

    final response = await http.put(
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

  Future<void> deleteUser(String id) async {
    HttpOverrides.global = MyHttpOverrides();
    final response = await http.delete(Uri.parse('$baseUrl/User/$id'));

    if (response.statusCode == 200) {
    } else {
      final Map<String, dynamic> errorResponse = json.decode(response.body);
      throw Exception(errorResponse["message"]);
    }
  }
}
