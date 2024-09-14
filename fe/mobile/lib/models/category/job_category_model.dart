import 'package:json_annotation/json_annotation.dart';

part 'job_category_model.g.dart';

@JsonSerializable()
class JobCategory {
  final int id;
  final String name;

  JobCategory({required this.id, required this.name});

  factory JobCategory.fromJson(Map<String, dynamic> json) => _$JobCategoryFromJson(json);

  Map<String, dynamic> toJson() => _$JobCategoryToJson(this);
}