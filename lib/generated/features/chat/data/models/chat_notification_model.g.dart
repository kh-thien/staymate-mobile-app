// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../../../../features/chat/data/models/chat_notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatNotificationModel _$ChatNotificationModelFromJson(
  Map<String, dynamic> json,
) => ChatNotificationModel(
  id: json['id'] as String,
  userId: json['user_id'] as String,
  roomId: json['room_id'] as String,
  messageId: json['message_id'] as String,
  type: json['type'] as String,
  isRead: json['is_read'] as bool,
  createdAt: DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$ChatNotificationModelToJson(
  ChatNotificationModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'user_id': instance.userId,
  'room_id': instance.roomId,
  'message_id': instance.messageId,
  'type': instance.type,
  'is_read': instance.isRead,
  'created_at': instance.createdAt.toIso8601String(),
};
