import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/property_entity.dart';

part '../../../../generated/features/contract/data/models/property_model.g.dart';

@JsonSerializable()
class PropertyModel {
  const PropertyModel({
    required this.id,
    required this.ownerId,
    required this.name,
    required this.address,
    this.city,
    this.district,
    this.ward,
    this.latitude,
    this.longitude,
    this.description,
    this.propertyType,
    this.totalFloors,
    this.totalRooms,
    this.amenities,
    this.contactPhone,
    this.contactEmail,
    this.isActive,
    required this.createdAt,
  });

  final String id;
  @JsonKey(name: 'owner_id')
  final String ownerId;
  final String name;
  final String address;
  final String? city;
  final String? district;
  final String? ward;
  final double? latitude;
  final double? longitude;
  final String? description;
  @JsonKey(name: 'property_type')
  final String? propertyType;
  @JsonKey(name: 'total_floors')
  final int? totalFloors;
  @JsonKey(name: 'total_rooms')
  final int? totalRooms;
  final Map<String, dynamic>? amenities;
  @JsonKey(name: 'contact_phone')
  final String? contactPhone;
  @JsonKey(name: 'contact_email')
  final String? contactEmail;
  @JsonKey(name: 'is_active')
  final bool? isActive;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  factory PropertyModel.fromJson(Map<String, dynamic> json) =>
      _$PropertyModelFromJson(json);

  Map<String, dynamic> toJson() => _$PropertyModelToJson(this);

  // Convert to Entity
  PropertyEntity toEntity() {
    return PropertyEntity(
      id: id,
      ownerId: ownerId,
      name: name,
      address: address,
      city: city,
      district: district,
      ward: ward,
      latitude: latitude,
      longitude: longitude,
      description: description,
      propertyType: propertyType,
      totalFloors: totalFloors,
      totalRooms: totalRooms,
      amenities: amenities,
      contactPhone: contactPhone,
      contactEmail: contactEmail,
      isActive: isActive,
      createdAt: createdAt,
    );
  }
}
