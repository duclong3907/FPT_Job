import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class User {
  String id;
  String userName;
  String email;
  String password;
  String phoneNumber;


  User({
    required this.id,
    required this.userName,
    required this.email,
    required this.password,
    required this.phoneNumber,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
