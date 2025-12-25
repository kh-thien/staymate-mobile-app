// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../../../../features/contract/data/models/tenant_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TenantModel _$TenantModelFromJson(Map<String, dynamic> json) => TenantModel(
  id: json['id'] as String,
  roomId: json['room_id'] as String?,
  fullname: json['fullname'] as String,
  userId: json['user_id'] as String?,
  phone: json['phone'] as String?,
  email: json['email'] as String?,
  isActive: json['is_active'] as bool? ?? true,
  createdAt: DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$TenantModelToJson(TenantModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'room_id': instance.roomId,
      'fullname': instance.fullname,
      'user_id': instance.userId,
      'phone': instance.phone,
      'email': instance.email,
      'is_active': instance.isActive,
      'created_at': instance.createdAt.toIso8601String(),
    };
