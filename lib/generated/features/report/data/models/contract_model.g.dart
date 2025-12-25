// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../../../../features/report/data/models/contract_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContractModel _$ContractModelFromJson(Map<String, dynamic> json) =>
    ContractModel(
      id: json['id'] as String,
      roomId: json['room_id'] as String?,
      tenantId: json['tenant_id'] as String?,
      landlordId: json['landlord_id'] as String?,
      contractNumber: json['contract_number'] as String?,
      status: json['status'] as String,
      startDate: json['start_date'] == null
          ? null
          : DateTime.parse(json['start_date'] as String),
      endDate: json['end_date'] == null
          ? null
          : DateTime.parse(json['end_date'] as String),
      propertyId: json['property_id'] as String?,
      roomCode: json['room_code'] as String?,
      roomName: json['room_name'] as String?,
      propertyName: json['property_name'] as String?,
    );

Map<String, dynamic> _$ContractModelToJson(ContractModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'room_id': instance.roomId,
      'tenant_id': instance.tenantId,
      'landlord_id': instance.landlordId,
      'contract_number': instance.contractNumber,
      'status': instance.status,
      'start_date': instance.startDate?.toIso8601String(),
      'end_date': instance.endDate?.toIso8601String(),
      'property_id': instance.propertyId,
      'room_code': instance.roomCode,
      'room_name': instance.roomName,
      'property_name': instance.propertyName,
    };
