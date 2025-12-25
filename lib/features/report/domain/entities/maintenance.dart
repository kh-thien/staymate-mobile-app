import 'package:json_annotation/json_annotation.dart';

enum MaintenanceStatus {
  @JsonValue('PENDING')
  pending,
  @JsonValue('IN_PROGRESS')
  inProgress,
  @JsonValue('COMPLETED')
  completed,
  @JsonValue('CANCELLED')
  cancelled,
}

enum MaintenanceType {
  @JsonValue('PLUMBING')
  plumbing,
  @JsonValue('ELECTRICAL')
  electrical,
  @JsonValue('HVAC')
  hvac,
  @JsonValue('APPLIANCE')
  appliance,
  @JsonValue('STRUCTURAL')
  structural,
  @JsonValue('OTHER')
  other,
}

class Maintenance {
  final String id;
  final String? userReportId;
  final String status;
  final String maintenanceType;
  final String title;
  final String description;
  final String? notes;
  final String? roomId;
  final String propertyId;
  final String? urlImage;
  final double? cost;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String? priority;
  final String? maintenanceRequestId;

  // Joined fields
  final String? propertyName;
  final String? roomCode;
  final String? roomName;

  const Maintenance({
    required this.id,
    this.userReportId,
    required this.status,
    required this.maintenanceType,
    required this.title,
    required this.description,
    this.notes,
    this.roomId,
    required this.propertyId,
    this.urlImage,
    this.cost,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    this.priority,
    this.maintenanceRequestId,
    this.propertyName,
    this.roomCode,
    this.roomName,
  });
}
