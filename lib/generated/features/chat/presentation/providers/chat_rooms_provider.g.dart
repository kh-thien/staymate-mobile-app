// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../../../../features/chat/presentation/providers/chat_rooms_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ChatRooms)
const chatRoomsProvider = ChatRoomsProvider._();

final class ChatRoomsProvider
    extends $AsyncNotifierProvider<ChatRooms, List<ChatRoom>> {
  const ChatRoomsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chatRoomsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chatRoomsHash();

  @$internal
  @override
  ChatRooms create() => ChatRooms();
}

String _$chatRoomsHash() => r'ca74eda6f96498fe320fe49df167a75ddc1b2431';

abstract class _$ChatRooms extends $AsyncNotifier<List<ChatRoom>> {
  FutureOr<List<ChatRoom>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<List<ChatRoom>>, List<ChatRoom>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<ChatRoom>>, List<ChatRoom>>,
              AsyncValue<List<ChatRoom>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
