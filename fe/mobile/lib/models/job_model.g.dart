// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Job _$JobFromJson(Map<String, dynamic> json) => Job(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      image: json['image'] as String?,
      description: json['description'] as String,
      salaryRange: json['salaryRange'] as String,
      experienceRequired: (json['experience_required'] as num).toDouble(),
      educationRequired: json['education_required'] as String,
      skillRequired: json['skill_required'] as String,
      applicationDeadline:
          DateTime.parse(json['application_deadline'] as String),
      status: json['status'] as String?,
      employerId: json['employerId'] as String,
      jobCategoryId: (json['jobCategoryId'] as num).toInt(),
      createdAt: json['created_At'] == null
          ? null
          : DateTime.parse(json['created_At'] as String),
      updatedAt: json['updated_At'] == null
          ? null
          : DateTime.parse(json['updated_At'] as String),
      deleted: (json['deleted'] as num?)?.toInt(),
    );

Map<String, dynamic> _$JobToJson(Job instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'image': instance.image,
      'description': instance.description,
      'salaryRange': instance.salaryRange,
      'experience_required': instance.experienceRequired,
      'education_required': instance.educationRequired,
      'skill_required': instance.skillRequired,
      'application_deadline': instance.applicationDeadline.toIso8601String(),
      'status': instance.status,
      'employerId': instance.employerId,
      'jobCategoryId': instance.jobCategoryId,
      'created_At': instance.createdAt?.toIso8601String(),
      'updated_At': instance.updatedAt?.toIso8601String(),
      'deleted': instance.deleted,
    };
