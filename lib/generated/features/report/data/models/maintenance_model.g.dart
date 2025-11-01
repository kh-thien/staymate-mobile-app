// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../../../../features/report/data/models/maintenance_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MaintenanceModel _$MaintenanceModelFromJson(Map<String, dynamic> json) =>
    MaintenanceModel(
      id: json['id'] as String,
      userReportId: json['user_report_id'] as String?,
      status: json['status'] as String,
      maintenanceType: json['maintenance_type'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      notes: json['notes'] as String?,
      roomId: json['room_id'] as String?,
      propertyId: json['property_id'] as String,
      urlImage: json['url_image'] as String?,
      cost: (json['cost'] as num?)?.toDouble(),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      deletedAt: json['deleted_at'] == null
          ? null
          : DateTime.parse(json['deleted_at'] as String),
      priority: json['priority'] as String?,
      maintenanceRequestId: json['maintenance_request_id'] as String?,
      propertyName: json['property_name'] as String?,
      roomCode: json['room_code'] as String?,
      roomName: json['room_name'] as String?,
    );

Map<String, dynamic> _$MaintenanceModelToJson(MaintenanceModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_report_id': instance.userReportId,
      'status': instance.status,
      'maintenance_type': instance.maintenanceType,
      'title': instance.title,
      'description': instance.description,
      'notes': instance.notes,
      'room_id': instance.roomId,
      'property_id': instance.propertyId,
      'url_image': instance.urlImage,
      'cost': instance.cost,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'deleted_at': instance.deletedAt?.toIso8601String(),
      'priority': instance.priority,
      'maintenance_request_id': instance.maintenanceRequestId,
      'property_name': instance.propertyName,
      'room_code': instance.roomCode,
      'room_name': instance.roomName,
    };
