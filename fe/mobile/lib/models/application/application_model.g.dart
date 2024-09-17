// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'application_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Application _$ApplicationFromJson(Map<String, dynamic> json) => Application(
      id: (json['id'] as num).toInt(),
      userName: json['userName'] as String?,
      fullName: json['fullName'] as String?,
      image: json['image'] as String?,
      userEmail: json['userEmail'] as String?,
      resume: json['resume'] as String,
      coverLetter: json['coverLetter'] as String,
      selfIntroduction: json['selfIntroduction'] as String,
      status: json['status'] as String?,
      jobId: (json['jobId'] as num).toInt(),
      userId: json['userId'] as String,
      createdAt: json['created_At'] == null
          ? null
          : DateTime.parse(json['created_At'] as String),
      updatedAt: json['updated_At'] == null
          ? null
          : DateTime.parse(json['updated_At'] as String),
    );

Map<String, dynamic> _$ApplicationToJson(Application instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userName': instance.userName,
      'fullName': instance.fullName,
      'image': instance.image,
      'userEmail': instance.userEmail,
      'resume': instance.resume,
      'coverLetter': instance.coverLetter,
      'selfIntroduction': instance.selfIntroduction,
      'status': instance.status,
      'jobId': instance.jobId,
      'userId': instance.userId,
      'created_At': instance.createdAt?.toIso8601String(),
      'updated_At': instance.updatedAt?.toIso8601String(),
    };
