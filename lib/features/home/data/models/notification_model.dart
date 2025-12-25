import 'package:json_annotation/json_annotation.dart';

part '../../../../generated/features/home/data/models/notification_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class NotificationModel {
  final String id;
  final String userId;
  final String title;
  final String message;
  final String type;
  @JsonKey(defaultValue: false)
  final bool isRead;
  final String? actionUrl;
  final Map<String, dynamic>? metadata;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const NotificationModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.message,
    required this.type,
    required this.isRead,
    this.actionUrl,
    this.metadata,
    required this.createdAt,
    this.updatedAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationModelToJson(this);
}

