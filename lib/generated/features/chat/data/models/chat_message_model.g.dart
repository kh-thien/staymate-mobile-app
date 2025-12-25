// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../../../../features/chat/data/models/chat_message_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatMessageModel _$ChatMessageModelFromJson(Map<String, dynamic> json) =>
    ChatMessageModel(
      id: json['id'] as String,
      roomId: json['room_id'] as String,
      senderId: json['sender_id'] as String,
      senderType: json['sender_type'] as String,
      content: json['content'] as String,
      messageType: json['message_type'] as String,
      fileUrl: json['file_url'] as String?,
      fileName: json['file_name'] as String?,
      fileSize: (json['file_size'] as num?)?.toInt(),
      replyTo: json['reply_to'] as String?,
      isEdited: json['is_edited'] as bool,
      editedAt: json['edited_at'] == null
          ? null
          : DateTime.parse(json['edited_at'] as String),
      isDeleted: json['is_deleted'] as bool,
      deletedAt: json['deleted_at'] == null
          ? null
          : DateTime.parse(json['deleted_at'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      replyToMessage: json['reply_to_message'] == null
          ? null
          : ChatMessageModel.fromJson(
              json['reply_to_message'] as Map<String, dynamic>,
            ),
      reactions: (json['message_reactions'] as List<dynamic>?)
          ?.map((e) => MessageReactionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ChatMessageModelToJson(ChatMessageModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'room_id': instance.roomId,
      'sender_id': instance.senderId,
      'sender_type': instance.senderType,
      'content': instance.content,
      'message_type': instance.messageType,
      'file_url': instance.fileUrl,
      'file_name': instance.fileName,
      'file_size': instance.fileSize,
      'reply_to': instance.replyTo,
      'is_edited': instance.isEdited,
      'edited_at': instance.editedAt?.toIso8601String(),
      'is_deleted': instance.isDeleted,
      'deleted_at': instance.deletedAt?.toIso8601String(),
      'created_at': instance.createdAt.toIso8601String(),
      'reply_to_message': instance.replyToMessage?.toJson(),
      'message_reactions': instance.reactions?.map((e) => e.toJson()).toList(),
    };
