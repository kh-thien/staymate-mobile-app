// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../../../../features/chat/presentation/providers/selected_room_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Simple state provider for the currently selected chat room

@ProviderFor(SelectedRoom)
const selectedRoomProvider = SelectedRoomProvider._();

/// Simple state provider for the currently selected chat room
final class SelectedRoomProvider
    extends $NotifierProvider<SelectedRoom, ChatRoom?> {
  /// Simple state provider for the currently selected chat room
  const SelectedRoomProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedRoomProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedRoomHash();

  @$internal
  @override
  SelectedRoom create() => SelectedRoom();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ChatRoom? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ChatRoom?>(value),
    );
  }
}

String _$selectedRoomHash() => r'3ab462fbf6131f5d60279b2db24b61794f6eeee0';

/// Simple state provider for the currently selected chat room

abstract class _$SelectedRoom extends $Notifier<ChatRoom?> {
  ChatRoom? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<ChatRoom?, ChatRoom?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ChatRoom?, ChatRoom?>,
              ChatRoom?,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
