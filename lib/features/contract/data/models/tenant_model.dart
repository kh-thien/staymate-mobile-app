import 'package:json_annotation/json_annotation.dart';
import '../../../auth/domain/entities/user.dart';

part '../../../../generated/features/contract/data/models/tenant_model.g.dart';

@JsonSerializable()
class TenantModel {
  const TenantModel({
    required this.id,
    required this.roomId,
    required this.fullname,
    this.userId,
    this.phone,
    this.email,
    this.isActive = true,
    required this.createdAt,
  });

  final String id;
  @JsonKey(name: 'room_id')
  final String roomId;
  final String fullname;
  @JsonKey(name: 'user_id')
  final String? userId;
  final String? phone;
  final String? email;
  @JsonKey(name: 'is_active')
  final bool isActive;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  factory TenantModel.fromJson(Map<String, dynamic> json) =>
      _$TenantModelFromJson(json);

  Map<String, dynamic> toJson() => _$TenantModelToJson(this);

  // Convert to User Entity
  User toEntity() {
    return User(
      id: id,
      email: email ?? '',
      fullName: fullname,
      phoneNumber: phone,
      avatar: null,
      createdAt: createdAt,
      updatedAt: createdAt,
    );
  }
}
