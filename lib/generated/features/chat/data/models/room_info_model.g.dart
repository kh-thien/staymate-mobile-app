// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../../../../features/chat/data/models/room_info_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RoomInfoModel _$RoomInfoModelFromJson(Map<String, dynamic> json) =>
    RoomInfoModel(
      id: json['id'] as String,
      code: json['code'] as String,
      name: json['name'] as String?,
      propertyId: json['property_id'] as String,
      properties: json['properties'] == null
          ? null
          : PropertyInfoModel.fromJson(
              json['properties'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$RoomInfoModelToJson(RoomInfoModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'name': instance.name,
      'property_id': instance.propertyId,
    };
