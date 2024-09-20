// user_response_model.dart
import 'package:json_annotation/json_annotation.dart';
import 'user_model.dart';

part 'user_response_model.g.dart';

@JsonSerializable()
class UserResponse {
  User user;
  List<String> roles;
  String fullName;
  String? image;
  String? company;

  UserResponse({
    required this.user,
    required this.roles,
    required this.fullName,
    this.image,
    this.company,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      user: json['user'] != null ? User.fromJson(json['user']) : throw Exception('User is null'),
      roles: (json['roles'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      fullName: json['fullName'] ?? 'No name', // Handle missing fullName
      image: json['image'], // Handle missing image
      company: json['company'], // Handle missing company
    );
  }

  Map<String, dynamic> toJson() => _$UserResponseToJson(this);

  static List<UserResponse> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => UserResponse.fromJson(json)).toList();
  }
}