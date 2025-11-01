import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/maintenance.dart';

part '../../../../generated/features/report/data/models/maintenance_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class MaintenanceModel {
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

  const MaintenanceModel({
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

  factory MaintenanceModel.fromJson(Map<String, dynamic> json) =>
      _$MaintenanceModelFromJson(json);

  Map<String, dynamic> toJson() => _$MaintenanceModelToJson(this);

  Maintenance toEntity() {
    return Maintenance(
      id: id,
      userReportId: userReportId,
      status: status,
      maintenanceType: maintenanceType,
      title: title,
      description: description,
      notes: notes,
      roomId: roomId,
      propertyId: propertyId,
      urlImage: urlImage,
      cost: cost,
      createdAt: createdAt,
      updatedAt: updatedAt,
      deletedAt: deletedAt,
      priority: priority,
      maintenanceRequestId: maintenanceRequestId,
      propertyName: propertyName,
      roomCode: roomCode,
      roomName: roomName,
    );
  }
}
