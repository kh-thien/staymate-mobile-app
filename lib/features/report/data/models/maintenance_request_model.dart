import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/maintenance_request.dart';

part '../../../../generated/features/report/data/models/maintenance_request_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class MaintenanceRequestModel {
  final String id;
  final String reportedBy;
  final String description;
  final String? propertiesId;
  final String? roomId;
  final String? urlReport;
  @JsonKey(unknownEnumValue: MaintenanceRequestStatus.pending)
  final MaintenanceRequestStatus maintenanceRequestsStatus;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  // Join fields
  final String? propertyName;
  final String? roomCode;
  final String? roomName;

  const MaintenanceRequestModel({
    required this.id,
    required this.reportedBy,
    required this.description,
    this.propertiesId,
    this.roomId,
    this.urlReport,
    required this.maintenanceRequestsStatus,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    this.propertyName,
    this.roomCode,
    this.roomName,
  });

  factory MaintenanceRequestModel.fromJson(Map<String, dynamic> json) =>
      _$MaintenanceRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$MaintenanceRequestModelToJson(this);

  MaintenanceRequest toEntity() {
    return MaintenanceRequest(
      id: id,
      reportedBy: reportedBy,
      description: description,
      propertiesId: propertiesId,
      roomId: roomId,
      urlReport: urlReport,
      status: maintenanceRequestsStatus,
      createdAt: createdAt,
      updatedAt: updatedAt,
      deletedAt: deletedAt,
      propertyName: propertyName,
      roomCode: roomCode,
      roomName: roomName,
    );
  }
}
