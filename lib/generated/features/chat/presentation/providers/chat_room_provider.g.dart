// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../../../../features/chat/presentation/providers/chat_room_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider to get a specific chat room by ID from the rooms list

@ProviderFor(chatRoom)
const chatRoomProvider = ChatRoomFamily._();

/// Provider to get a specific chat room by ID from the rooms list

final class ChatRoomProvider
    extends $FunctionalProvider<ChatRoom?, ChatRoom?, ChatRoom?>
    with $Provider<ChatRoom?> {
  /// Provider to get a specific chat room by ID from the rooms list
  const ChatRoomProvider._({
    required ChatRoomFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'chatRoomProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$chatRoomHash();

  @override
  String toString() {
    return r'chatRoomProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<ChatRoom?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ChatRoom? create(Ref ref) {
    final argument = this.argument as String;
    return chatRoom(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ChatRoom? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ChatRoom?>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ChatRoomProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$chatRoomHash() => r'8a93d21f4b08a265844933bde226e2edd3974d56';

/// Provider to get a specific chat room by ID from the rooms list

final class ChatRoomFamily extends $Family
    with $FunctionalFamilyOverride<ChatRoom?, String> {
  const ChatRoomFamily._()
    : super(
        retry: null,
        name: r'chatRoomProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Provider to get a specific chat room by ID from the rooms list

  ChatRoomProvider call(String roomId) =>
      ChatRoomProvider._(argument: roomId, from: this);

  @override
  String toString() => r'chatRoomProvider';
}
