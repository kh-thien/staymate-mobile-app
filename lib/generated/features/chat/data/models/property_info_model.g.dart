// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../../../../features/chat/data/models/property_info_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PropertyInfoModel _$PropertyInfoModelFromJson(Map<String, dynamic> json) =>
    PropertyInfoModel(
      id: json['id'] as String,
      name: json['name'] as String,
      address: json['address'] as String,
      city: json['city'] as String?,
      ward: json['ward'] as String?,
      district: json['district'] as String?,
      ownerId: json['owner_id'] as String,
      owner: json['owner'] == null
          ? null
          : UserInfoModel.fromJson(json['owner'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PropertyInfoModelToJson(PropertyInfoModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'address': instance.address,
      'city': instance.city,
      'ward': instance.ward,
      'district': instance.district,
      'owner_id': instance.ownerId,
    };
