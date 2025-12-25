import 'package:json_annotation/json_annotation.dart';

enum MaintenanceRequestStatus {
  @JsonValue('PENDING')
  pending,
  @JsonValue('APPROVED')
  approved,
  @JsonValue('REJECTED')
  rejected,
  @JsonValue('CANCELLED')
  cancelled,
}

class MaintenanceRequest {
  final String id;
  final String reportedBy;
  final String description;
  final String? propertiesId;
  final String? roomId;
  final String? urlReport;
  final MaintenanceRequestStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  // Additional fields from joins
  final String? propertyName;
  final String? roomCode;
  final String? roomName;

  const MaintenanceRequest({
    required this.id,
    required this.reportedBy,
    required this.description,
    this.propertiesId,
    this.roomId,
    this.urlReport,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    this.propertyName,
    this.roomCode,
    this.roomName,
  });

  String get statusText {
    switch (status) {
      case MaintenanceRequestStatus.pending:
        return 'Đang chờ';
      case MaintenanceRequestStatus.approved:
        return 'Đã duyệt';
      case MaintenanceRequestStatus.rejected:
        return 'Từ chối';
      case MaintenanceRequestStatus.cancelled:
        return 'Đã hủy';
    }
  }
}
