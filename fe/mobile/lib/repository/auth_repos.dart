import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../config/config_http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/auth/login_user_model.dart';

class AuthService {
  final String apiUrl = '$baseUrlApi/Auth';
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();

  AuthService(){
    HttpOverrides.global = MyHttpOverrides();
  }

  Future<Map<String, dynamic>> registerUser(LoginUser user) async {
    final url = Uri.parse('$apiUrl/Register');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(user.toJson()),
    );

    if (response.statusCode == 200) {
      return {'status': true, 'message': response.body};
    } else {
      return {'status': false, 'message': jsonDecode(response.body)['message']};
    }
  }

  Future<String?> login(String userName, String password) async {
    final url = Uri.parse('$apiUrl/Login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': userName, 'password': password}),
    );

    try {
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['token'];

        await secureStorage.write(key: 'token', value: token);


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
        await secureStorage.delete(key: 'token');
      } else {
        final Map<String, dynamic> errorResponse = json.decode(response.body);
        throw Exception(errorResponse["message"]);
      }
    }
    return true;
  }

  Future<Map<String, dynamic>> forgotPassword(String email) async {
    final url = Uri.parse('$apiUrl/ForgotPassword');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );

    if (response.statusCode == 200) {
      return {'status': true, 'message': response.body};
    } else {
      return {'status': false, 'message': response.body};
    }
  }

  Future<Map<String, dynamic>> checkPhone(String phone) async {
    final url = Uri.parse('$apiUrl/CheckPhoneNumber');
    final responseCheckPhone = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'phoneNumber': phone}),
    );
    if (responseCheckPhone.statusCode == 200) {
      return {'status': true, 'message': responseCheckPhone.body};
    } else {
      return {'status': false, 'message': jsonDecode(responseCheckPhone.body)['message']};
    }
  }

  Future<Map<String, dynamic>> loginWithPhone(String phone) async {
    final result = await checkPhone(phone);
    if (result['status']) {

      final url = Uri.parse('$apiUrl/LoginWithPhoneNumber');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'phoneNumber': phone}),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['token'];

        await secureStorage.write(key: 'token', value: token);

        return {'status': true, 'message': response.body};
      } else {
        return {'status': false, 'message': jsonDecode(response.body)['message']};
      }
    } else {
      return {'status': false, 'message': result['message']};
    }
  }


  Future<String?> getToken() async {
    return await secureStorage.read(key: 'token');
  }

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
    ],
  );

  Future<Map<String, dynamic>> signInWithGoogle(String role) async {
    try {
      // Trigger the Google Sign-In flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return {'status': false, 'message': 'Google sign-in aborted'};
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create the request URL with query parameters
      final Uri requestUri = Uri.parse('$baseUrlApi/Auth/GoogleResponse')
          .replace(queryParameters: {
        'idToken': googleAuth.idToken,
        'accessToken': googleAuth.accessToken,
        'role': role,
      });

      // Send the request to your backend
      final response = await http.get(requestUri);

      if (response.statusCode == 200) {
        // Parse the response
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        return responseData;
      } else {
        return {'status': false, 'message': 'Failed to sign in with Google'};
      }
    } catch (error) {
      return {'status': false, 'message': error.toString()};
    }
  }


}