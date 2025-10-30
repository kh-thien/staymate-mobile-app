// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../../../../features/chat/data/models/chat_room_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatRoomModel _$ChatRoomModelFromJson(Map<String, dynamic> json) =>
    ChatRoomModel(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      propertyId: json['property_id'] as String,
      roomId: json['room_id'] as String?,
      contractId: json['contract_id'] as String?,
      createdBy: json['created_by'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      isActive: json['is_active'] as bool,
      isActivated: json['is_activated'] as bool,
      roomCode: json['room_code'] as String?,
      participants: (json['chat_participants'] as List<dynamic>?)
          ?.map((e) => ChatParticipantModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      messages: (json['chat_messages'] as List<dynamic>?)
          ?.map((e) => ChatMessageModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      room: json['rooms'] == null
          ? null
          : RoomInfoModel.fromJson(json['rooms'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ChatRoomModelToJson(
  ChatRoomModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'type': instance.type,
  'property_id': instance.propertyId,
  'room_id': instance.roomId,
  'contract_id': instance.contractId,
  'created_by': instance.createdBy,
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
  'is_active': instance.isActive,
  'is_activated': instance.isActivated,
  'room_code': instance.roomCode,
  'chat_participants': instance.participants?.map((e) => e.toJson()).toList(),
  'chat_messages': instance.messages?.map((e) => e.toJson()).toList(),
  'rooms': instance.room?.toJson(),
};
