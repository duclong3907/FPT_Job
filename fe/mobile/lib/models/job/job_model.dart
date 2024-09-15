import 'package:json_annotation/json_annotation.dart';
import 'package:mobile/models/user/user_response_model.dart';
import '../category/job_category_model.dart';

part 'job_model.g.dart';

@JsonSerializable()
class Job {
  int id;
  String title;
  String? image;
  String description;
  String salaryRange;
  @JsonKey(name: 'experience_required')
  double experienceRequired;
  @JsonKey(name: 'education_required')
  String educationRequired;
  @JsonKey(name: 'skill_required')
  String skillRequired;
  @JsonKey(name: 'application_deadline')
  DateTime applicationDeadline;
  String? status;
  @JsonKey(name: 'employerId')
  String employerId;
  @JsonKey(name: 'jobCategoryId')
  int jobCategoryId;
  @JsonKey(name: 'created_At')
  DateTime? createdAt;
  @JsonKey(name: 'updated_At')
  DateTime? updatedAt;
  int? deleted;
  JobCategory? jobCategory;
  UserResponse? employer;

  Job({
    required this.id,
    required this.title,
    this.image,
    required this.description,
    required this.salaryRange,
    required this.experienceRequired,
    required this.educationRequired,
    required this.skillRequired,
    required this.applicationDeadline,
    this.status,
    required this.employerId,
    required this.jobCategoryId,
    this.createdAt,
    this.updatedAt,
    this.deleted,
    this.jobCategory,
  });

  factory Job.fromJson(Map<String, dynamic> json) => _$JobFromJson(json);
  Map<String, dynamic> toJson() => _$JobToJson(this);
}
