// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_category_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JobCategory _$JobCategoryFromJson(Map<String, dynamic> json) => JobCategory(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
    );

Map<String, dynamic> _$JobCategoryToJson(JobCategory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };
