// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../../../../features/invoice/data/models/payment_account_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentAccountModel _$PaymentAccountModelFromJson(Map<String, dynamic> json) =>
    PaymentAccountModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      bankCode: json['bank_code'] as String,
      bankName: json['bank_name'] as String,
      accountNumber: json['account_number'] as String,
      accountHolder: json['account_holder'] as String,
      branch: json['branch'] as String?,
      isDefault: json['is_default'] as bool?,
      isActive: json['is_active'] as bool?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      deletedAt: json['deleted_at'] == null
          ? null
          : DateTime.parse(json['deleted_at'] as String),
      acqId: json['acq_id'] as String?,
    );

Map<String, dynamic> _$PaymentAccountModelToJson(
  PaymentAccountModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'user_id': instance.userId,
  'bank_code': instance.bankCode,
  'bank_name': instance.bankName,
  'account_number': instance.accountNumber,
  'account_holder': instance.accountHolder,
  'branch': instance.branch,
  'is_default': instance.isDefault,
  'is_active': instance.isActive,
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
  'deleted_at': instance.deletedAt?.toIso8601String(),
  'acq_id': instance.acqId,
};
