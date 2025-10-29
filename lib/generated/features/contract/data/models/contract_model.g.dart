// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../../../../features/contract/data/models/contract_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContractModel _$ContractModelFromJson(Map<String, dynamic> json) =>
    ContractModel(
      id: json['id'] as String,
      roomId: json['room_id'] as String,
      tenantId: json['tenant_id'] as String?,
      contractNumber: json['contract_number'] as String?,
      status: json['status'] as String,
      startDate: json['start_date'] == null
          ? null
          : DateTime.parse(json['start_date'] as String),
      endDate: json['end_date'] == null
          ? null
          : DateTime.parse(json['end_date'] as String),
      monthlyRent: (json['monthly_rent'] as num).toDouble(),
      deposit: (json['deposit'] as num?)?.toDouble() ?? 0.0,
      paymentCycle: json['payment_cycle'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$ContractModelToJson(ContractModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'room_id': instance.roomId,
      'tenant_id': instance.tenantId,
      'contract_number': instance.contractNumber,
      'status': instance.status,
      'start_date': instance.startDate?.toIso8601String(),
      'end_date': instance.endDate?.toIso8601String(),
      'monthly_rent': instance.monthlyRent,
      'deposit': instance.deposit,
      'payment_cycle': instance.paymentCycle,
      'created_at': instance.createdAt.toIso8601String(),
    };
