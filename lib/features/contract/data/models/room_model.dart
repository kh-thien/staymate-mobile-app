import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/room_entity.dart';

part '../../../../generated/features/contract/data/models/room_model.g.dart';

@JsonSerializable()
class RoomModel {
  const RoomModel({
    required this.id,
    required this.propertyId,
    required this.code,
    this.name,
    this.description,
    this.status,
    this.capacity,
    this.currentOccupants,
    required this.monthlyRent,
    this.depositAmount,
    this.areaSqm,
    this.roomType,
    this.amenities,
    this.utilitiesIncluded,
    this.images,
    this.rules,
    required this.createdAt,
  });

  final String id;
  @JsonKey(name: 'property_id')
  final String propertyId;
  final String code;
  final String? name;
  final String? description;
  final String? status;
  final int? capacity;
  @JsonKey(name: 'current_occupants')
  final int? currentOccupants;
  @JsonKey(name: 'monthly_rent')
  final double monthlyRent;
  @JsonKey(name: 'deposit_amount')
  final double? depositAmount;
  @JsonKey(name: 'area_sqm')
  final double? areaSqm;
  @JsonKey(name: 'room_type')
  final String? roomType;
  final Map<String, dynamic>? amenities;
  @JsonKey(name: 'utilities_included')
  final Map<String, dynamic>? utilitiesIncluded;
  final List<String>? images;
  final String? rules;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  factory RoomModel.fromJson(Map<String, dynamic> json) =>
      _$RoomModelFromJson(json);

  Map<String, dynamic> toJson() => _$RoomModelToJson(this);

  // Convert to Entity
  RoomEntity toEntity() {
    return RoomEntity(
      id: id,
      propertyId: propertyId,
      code: code,
      name: name,
      description: description,
      status: status,
      capacity: capacity,
      currentOccupants: currentOccupants,
      monthlyRent: monthlyRent,
      depositAmount: depositAmount,
      areaSqm: areaSqm,
      roomType: roomType,
      amenities: amenities,
      utilitiesIncluded: utilitiesIncluded,
      images: images,
      rules: rules,
      createdAt: createdAt,
    );
  }
}
