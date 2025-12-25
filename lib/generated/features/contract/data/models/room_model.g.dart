// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../../../../features/contract/data/models/room_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RoomModel _$RoomModelFromJson(Map<String, dynamic> json) => RoomModel(
  id: json['id'] as String,
  propertyId: json['property_id'] as String,
  code: json['code'] as String,
  name: json['name'] as String?,
  description: json['description'] as String?,
  status: json['status'] as String?,
  capacity: (json['capacity'] as num?)?.toInt(),
  currentOccupants: (json['current_occupants'] as num?)?.toInt(),
  monthlyRent: (json['monthly_rent'] as num).toDouble(),
  depositAmount: (json['deposit_amount'] as num?)?.toDouble(),
  areaSqm: (json['area_sqm'] as num?)?.toDouble(),
  roomType: json['room_type'] as String?,
  amenities: json['amenities'] as Map<String, dynamic>?,
  utilitiesIncluded: json['utilities_included'] as Map<String, dynamic>?,
  images: (json['images'] as List<dynamic>?)?.map((e) => e as String).toList(),
  rules: json['rules'] as String?,
  createdAt: DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$RoomModelToJson(RoomModel instance) => <String, dynamic>{
  'id': instance.id,
  'property_id': instance.propertyId,
  'code': instance.code,
  'name': instance.name,
  'description': instance.description,
  'status': instance.status,
  'capacity': instance.capacity,
  'current_occupants': instance.currentOccupants,
  'monthly_rent': instance.monthlyRent,
  'deposit_amount': instance.depositAmount,
  'area_sqm': instance.areaSqm,
  'room_type': instance.roomType,
  'amenities': instance.amenities,
  'utilities_included': instance.utilitiesIncluded,
  'images': instance.images,
  'rules': instance.rules,
  'created_at': instance.createdAt.toIso8601String(),
};
