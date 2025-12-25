// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../../../../features/chat/data/models/message_reaction_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageReactionModel _$MessageReactionModelFromJson(
  Map<String, dynamic> json,
) => MessageReactionModel(
  id: json['id'] as String,
  messageId: json['message_id'] as String,
  userId: json['user_id'] as String,
  reaction: json['reaction'] as String,
  createdAt: DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$MessageReactionModelToJson(
  MessageReactionModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'message_id': instance.messageId,
  'user_id': instance.userId,
  'reaction': instance.reaction,
  'created_at': instance.createdAt.toIso8601String(),
};
