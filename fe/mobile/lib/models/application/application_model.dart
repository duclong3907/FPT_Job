import 'package:json_annotation/json_annotation.dart';

import '../job/job_model.dart';

part 'application_model.g.dart';

@JsonSerializable()
class Application {
  int id;
  String resume;
  String coverLetter;
  String selfIntroduction;
  String status;
  int jobId;
  String userId;
  @JsonKey(name: 'created_At')
  DateTime? createdAt;
  @JsonKey(name: 'updated_At')
  DateTime? updatedAt;


  Application({
    required this.id,
    required this.resume,
    required this.coverLetter,
    required this.selfIntroduction,
    required this.status,
    required this.jobId,
    required this.userId,
    this.createdAt,
    this.updatedAt,
  });

  factory Application.fromJson(Map<String, dynamic> json) => _$ApplicationFromJson(json);
  Map<String, dynamic> toJson() => _$ApplicationToJson(this);
}
