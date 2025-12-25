// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../../../../features/chat/presentation/providers/realtime_chat_rooms_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider that listens to realtime updates for chat rooms
/// Updates happen when:
/// - New message sent to any room
/// - Message marked as read
/// - Room updated

@ProviderFor(realtimeChatRooms)
const realtimeChatRoomsProvider = RealtimeChatRoomsProvider._();

/// Provider that listens to realtime updates for chat rooms
/// Updates happen when:
/// - New message sent to any room
/// - Message marked as read
/// - Room updated

final class RealtimeChatRoomsProvider
    extends $FunctionalProvider<AsyncValue<void>, void, Stream<void>>
    with $FutureModifier<void>, $StreamProvider<void> {
  /// Provider that listens to realtime updates for chat rooms
  /// Updates happen when:
  /// - New message sent to any room
  /// - Message marked as read
  /// - Room updated
  const RealtimeChatRoomsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'realtimeChatRoomsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$realtimeChatRoomsHash();

  @$internal
  @override
  $StreamProviderElement<void> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<void> create(Ref ref) {
    return realtimeChatRooms(ref);
  }
}

String _$realtimeChatRoomsHash() => r'e634aa0772637ee886a6372d6fc3090e0d68a558';
