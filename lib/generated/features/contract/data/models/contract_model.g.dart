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
      landlordId: json['landlord_id'] as String?,
      contractNumber: json['contract_number'] as String?,
      status: json['status'] as String,
      contractType: json['contract_type'] as String?,
      startDate: json['start_date'] == null
          ? null
          : DateTime.parse(json['start_date'] as String),
      endDate: json['end_date'] == null
          ? null
          : DateTime.parse(json['end_date'] as String),
      monthlyRent: (json['monthly_rent'] as num).toDouble(),
      deposit: (json['deposit'] as num?)?.toDouble() ?? 0.0,
      paymentCycle: json['payment_cycle'] as String?,
      paymentFrequency: (json['payment_frequency'] as num?)?.toInt(),
      paymentDayType: json['payment_day_type'] as String?,
      paymentDay: (json['payment_day'] as num?)?.toInt(),
      paymentDays: json['payment_days'] as List<dynamic>?,
      autoRenewal: json['auto_renewal'] as bool?,
      noticePeriodDays: (json['notice_period_days'] as num?)?.toInt(),
      specialTerms: json['special_terms'] as String?,
      signedByTenant: json['signed_by_tenant'] as bool?,
      signedByLandlord: json['signed_by_landlord'] as bool?,
      signedAt: json['signed_at'] == null
          ? null
          : DateTime.parse(json['signed_at'] as String),
      terminationReason: $enumDecodeNullable(
        _$TerminationReasonEnumMap,
        json['termination_reason'],
      ),
      terminationNote: json['termination_note'] as String?,
      isEarlyTermination: json['is_early_termination'] as bool?,
      terms: json['terms'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      roomCode: json['room_code'] as String?,
      roomName: json['room_name'] as String?,
      propertyAddress: json['property_address'] as String?,
      propertyWard: json['property_ward'] as String?,
      propertyCity: json['property_city'] as String?,
      propertyName: json['property_name'] as String?,
    );

Map<String, dynamic> _$ContractModelToJson(
  ContractModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'room_id': instance.roomId,
  'tenant_id': instance.tenantId,
  'landlord_id': instance.landlordId,
  'contract_number': instance.contractNumber,
  'status': instance.status,
  'contract_type': instance.contractType,
  'start_date': instance.startDate?.toIso8601String(),
  'end_date': instance.endDate?.toIso8601String(),
  'monthly_rent': instance.monthlyRent,
  'deposit': instance.deposit,
  'payment_cycle': instance.paymentCycle,
  'payment_frequency': instance.paymentFrequency,
  'payment_day_type': instance.paymentDayType,
  'payment_day': instance.paymentDay,
  'payment_days': instance.paymentDays,
  'auto_renewal': instance.autoRenewal,
  'notice_period_days': instance.noticePeriodDays,
  'special_terms': instance.specialTerms,
  'signed_by_tenant': instance.signedByTenant,
  'signed_by_landlord': instance.signedByLandlord,
  'signed_at': instance.signedAt?.toIso8601String(),
  'termination_reason': _$TerminationReasonEnumMap[instance.terminationReason],
  'termination_note': instance.terminationNote,
  'is_early_termination': instance.isEarlyTermination,
  'terms': instance.terms,
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt?.toIso8601String(),
};

const _$TerminationReasonEnumMap = {
  TerminationReason.expired: 'EXPIRED',
  TerminationReason.violation: 'VIOLATION',
  TerminationReason.tenantRequest: 'TENANT_REQUEST',
  TerminationReason.landlordRequest: 'LANDLORD_REQUEST',
  TerminationReason.other: 'OTHER',
};
