// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginUser _$LoginUserFromJson(Map<String, dynamic> json) => LoginUser(
      fullName: json['fullName'] as String,
      userName: json['userName'] as String,
      password: json['password'] as String?,
      phoneNumber: json['phoneNumber'] as String,
      email: json['email'] as String,
      company: json['company'] as String?,
      image: json['image'] as String?,
      role: json['role'] as String,
    );

Map<String, dynamic> _$LoginUserToJson(LoginUser instance) => <String, dynamic>{
      'fullName': instance.fullName,
      'userName': instance.userName,
      'password': instance.password,
      'phoneNumber': instance.phoneNumber,
      'email': instance.email,
      'company': instance.company,
      'image': instance.image,
      'role': instance.role,
    };
