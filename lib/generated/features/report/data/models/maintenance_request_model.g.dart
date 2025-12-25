// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../../../../features/report/data/models/maintenance_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MaintenanceRequestModel _$MaintenanceRequestModelFromJson(
  Map<String, dynamic> json,
) => MaintenanceRequestModel(
  id: json['id'] as String,
  reportedBy: json['reported_by'] as String,
  description: json['description'] as String,
  propertiesId: json['properties_id'] as String?,
  roomId: json['room_id'] as String?,
  urlReport: json['url_report'] as String?,
  maintenanceRequestsStatus: $enumDecode(
    _$MaintenanceRequestStatusEnumMap,
    json['maintenance_requests_status'],
    unknownValue: MaintenanceRequestStatus.pending,
  ),
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
  deletedAt: json['deleted_at'] == null
      ? null
      : DateTime.parse(json['deleted_at'] as String),
  propertyName: json['property_name'] as String?,
  roomCode: json['room_code'] as String?,
  roomName: json['room_name'] as String?,
);

Map<String, dynamic> _$MaintenanceRequestModelToJson(
  MaintenanceRequestModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'reported_by': instance.reportedBy,
  'description': instance.description,
  'properties_id': instance.propertiesId,
  'room_id': instance.roomId,
  'url_report': instance.urlReport,
  'maintenance_requests_status':
      _$MaintenanceRequestStatusEnumMap[instance.maintenanceRequestsStatus]!,
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
  'deleted_at': instance.deletedAt?.toIso8601String(),
  'property_name': instance.propertyName,
  'room_code': instance.roomCode,
  'room_name': instance.roomName,
};

const _$MaintenanceRequestStatusEnumMap = {
  MaintenanceRequestStatus.pending: 'PENDING',
  MaintenanceRequestStatus.approved: 'APPROVED',
  MaintenanceRequestStatus.rejected: 'REJECTED',
  MaintenanceRequestStatus.cancelled: 'CANCELLED',
};
