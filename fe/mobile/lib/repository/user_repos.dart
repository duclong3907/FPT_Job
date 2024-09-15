// user_repository.dart
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../config/config_http.dart';
import '../models/user/user_response_model.dart';

class UserRepository {
  final String baseUrl = 'https://192.168.1.5:5001/api';

  Future<List<UserResponse>> fetchUsers() async {
    HttpOverrides.global = MyHttpOverrides();
    print('Fetching user data from $baseUrl/User');
    final response = await http.get(Uri.parse('$baseUrl/User'));

    if (response.statusCode == 200) {
      print('User data fetched successfully');
      print('Response body: ${response.body}');
      List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => UserResponse.fromJson(json)).toList();
    } else {
      print('Failed to load user data: ${response.statusCode}');
      throw Exception('Failed to load user');
    }
  }

  Future<UserResponse> getUser(String id) async {
    HttpOverrides.global = MyHttpOverrides();
    print('Fetching user data for id $id from $baseUrl/User/$id');
    final response = await http.get(Uri.parse('$baseUrl/User/$id'));

    if (response.statusCode == 200) {
      print('User data fetched successfully');
      print('Response body: ${response.body}');
      return UserResponse.fromJson(json.decode(response.body));
    } else {
      print('Failed to load user data: ${response.statusCode}');
      throw Exception('Failed to load user');
    }
  }

  Future<void> updateUser(String userId, Map<String, String> requestBody) async {
    HttpOverrides.global = MyHttpOverrides();
    final url = Uri.parse('$baseUrl/User/$userId');
    print('Updating user data for id $userId at $url');

    final body = json.encode(requestBody);
    print('Request body: $body');

    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    if (response.statusCode == 200) {
      print('User data updated successfully');
    } else {
      print('Failed to update user data: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to update user');
    }
  }

  Future<void> deleteUser(String id) async {
    HttpOverrides.global = MyHttpOverrides();
    print('Deleting user data for id $id from $baseUrl/User/$id');
    final response = await http.delete(Uri.parse('$baseUrl/User/$id'));

    if (response.statusCode == 200) {
      print('User data deleted successfully');
    } else {
      print('Failed to delete user data: ${response.statusCode}');
      throw Exception('Failed to delete user');
    }
  }
}
