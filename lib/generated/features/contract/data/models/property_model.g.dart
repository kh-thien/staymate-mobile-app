// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../../../../features/contract/data/models/property_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PropertyModel _$PropertyModelFromJson(Map<String, dynamic> json) =>
    PropertyModel(
      id: json['id'] as String,
      ownerId: json['owner_id'] as String,
      name: json['name'] as String,
      address: json['address'] as String,
      city: json['city'] as String?,
      district: json['district'] as String?,
      ward: json['ward'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      description: json['description'] as String?,
      propertyType: json['property_type'] as String?,
      totalFloors: (json['total_floors'] as num?)?.toInt(),
      totalRooms: (json['total_rooms'] as num?)?.toInt(),
      amenities: json['amenities'] as Map<String, dynamic>?,
      contactPhone: json['contact_phone'] as String?,
      contactEmail: json['contact_email'] as String?,
      isActive: json['is_active'] as bool?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$PropertyModelToJson(PropertyModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'owner_id': instance.ownerId,
      'name': instance.name,
      'address': instance.address,
      'city': instance.city,
      'district': instance.district,
      'ward': instance.ward,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'description': instance.description,
      'property_type': instance.propertyType,
      'total_floors': instance.totalFloors,
      'total_rooms': instance.totalRooms,
      'amenities': instance.amenities,
      'contact_phone': instance.contactPhone,
      'contact_email': instance.contactEmail,
      'is_active': instance.isActive,
      'created_at': instance.createdAt.toIso8601String(),
    };
