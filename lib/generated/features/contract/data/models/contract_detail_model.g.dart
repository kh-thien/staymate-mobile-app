// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../../../../features/contract/data/models/contract_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContractDetailModel _$ContractDetailModelFromJson(
  Map<String, dynamic> json,
) => ContractDetailModel(
  contract: ContractModel.fromJson(json['contract'] as Map<String, dynamic>),
  room: json['room'] == null
      ? null
      : RoomModel.fromJson(json['room'] as Map<String, dynamic>),
  property: json['property'] == null
      ? null
      : PropertyModel.fromJson(json['property'] as Map<String, dynamic>),
  tenant: json['tenant'] == null
      ? null
      : TenantModel.fromJson(json['tenant'] as Map<String, dynamic>),
  files:
      (json['files'] as List<dynamic>?)
          ?.map((e) => ContractFileModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$ContractDetailModelToJson(
  ContractDetailModel instance,
) => <String, dynamic>{
  'contract': instance.contract,
  'room': instance.room,
  'property': instance.property,
  'tenant': instance.tenant,
  'files': instance.files,
};
