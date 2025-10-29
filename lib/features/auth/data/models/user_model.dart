import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/user.dart';

part '../../../../generated/features/auth/data/models/user_model.g.dart';

@JsonSerializable()
class UserModel {
  const UserModel({
    required this.id,
    required this.email,
    this.fullName,
    this.phoneNumber,
    this.avatar,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String email;
  @JsonKey(name: 'full_name')
  final String? fullName;
  @JsonKey(name: 'phone_number')
  final String? phoneNumber;
  final String? avatar;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  // Convert từ Supabase User
  factory UserModel.fromSupabaseUser(
    String id,
    String email,
    Map<String, dynamic>? metadata,
    DateTime createdAt,
    DateTime updatedAt,
  ) {
    return UserModel(
      id: id,
      email: email,
      fullName: metadata?['full_name'] as String?,
      phoneNumber: metadata?['phone_number'] as String?,
      avatar: metadata?['avatar'] as String?,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  // Convert to Entity
  User toEntity() {
    return User(
      id: id,
      email: email,
      fullName: fullName,
      phoneNumber: phoneNumber,
      avatar: avatar,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  // Convert from Entity
  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      email: user.email,
      fullName: user.fullName,
      phoneNumber: user.phoneNumber,
      avatar: user.avatar,
      createdAt: user.createdAt,
      updatedAt: user.updatedAt,
    );
  }
}
