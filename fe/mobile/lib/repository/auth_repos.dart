import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../config/config_http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final String apiUrl = '$baseUrlApi/Auth';

  Future<String?> login(String userName, String password) async {
    final url = Uri.parse('$apiUrl/Login');
    HttpOverrides.global = MyHttpOverrides();

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': userName, 'password': password}),
    );

    try {
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['token'];


        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);


        return token;
      } else {
        final Map<String, dynamic> errorResponse = json.decode(response.body);
        throw Exception(errorResponse["message"]);
      }
    } catch (e) {
      throw Exception('Error logging in: $e');
    }
  }

  Future<bool> logout(String token) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token != null) {
      final url = Uri.parse('$apiUrl/logout');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        await prefs.remove('token');
      } else {
        final Map<String, dynamic> errorResponse = json.decode(response.body);
        throw Exception(errorResponse["message"]);
      }
    }
    return true;
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

}