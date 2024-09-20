// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserResponse _$UserResponseFromJson(Map<String, dynamic> json) => UserResponse(
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      roles: (json['roles'] as List<dynamic>).map((e) => e as String).toList(),
      fullName: json['fullName'] as String,
      image: json['image'] as String?,
      company: json['company'] as String?,
    );

Map<String, dynamic> _$UserResponseToJson(UserResponse instance) =>
    <String, dynamic>{
      'user': instance.user,
      'roles': instance.roles,
      'fullName': instance.fullName,
      'image': instance.image,
      'company': instance.company,
    };
