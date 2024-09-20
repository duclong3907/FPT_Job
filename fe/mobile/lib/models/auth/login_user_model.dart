import 'package:json_annotation/json_annotation.dart';

part 'login_user_model.g.dart';

@JsonSerializable()
class LoginUser {
  String fullName;
  String userName;
  String? password;
  String phoneNumber;
  String email;
  String? company;
  String? image;
  String role;


  LoginUser({
    required this.fullName,
    required this.userName,
    this.password,
    required this.phoneNumber,
    required this.email,
    this.company,
    this.image,
    required this.role,
  });

  factory LoginUser.fromJson(Map<String, dynamic> json) => _$LoginUserFromJson(json);
  Map<String, dynamic> toJson() => _$LoginUserToJson(this);
}
