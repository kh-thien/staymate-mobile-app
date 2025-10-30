// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../../../../features/chat/data/models/chat_participant_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatParticipantModel _$ChatParticipantModelFromJson(
  Map<String, dynamic> json,
) => ChatParticipantModel(
  id: json['id'] as String,
  roomId: json['room_id'] as String,
  userId: json['user_id'] as String,
  userType: json['user_type'] as String,
  joinedAt: DateTime.parse(json['joined_at'] as String),
  lastReadAt: DateTime.parse(json['last_read_at'] as String),
  isActive: json['is_active'] as bool,
  lastSeenAt: json['last_seen_at'] == null
      ? null
      : DateTime.parse(json['last_seen_at'] as String),
  isOnline: json['is_online'] as bool,
);

Map<String, dynamic> _$ChatParticipantModelToJson(
  ChatParticipantModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'room_id': instance.roomId,
  'user_id': instance.userId,
  'user_type': instance.userType,
  'joined_at': instance.joinedAt.toIso8601String(),
  'last_read_at': instance.lastReadAt.toIso8601String(),
  'is_active': instance.isActive,
  'last_seen_at': instance.lastSeenAt?.toIso8601String(),
  'is_online': instance.isOnline,
};
