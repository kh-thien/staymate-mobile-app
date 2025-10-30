// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../../../../features/chat/presentation/providers/chat_messages_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ChatMessages)
const chatMessagesProvider = ChatMessagesFamily._();

final class ChatMessagesProvider
    extends $AsyncNotifierProvider<ChatMessages, List<ChatMessage>> {
  const ChatMessagesProvider._({
    required ChatMessagesFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'chatMessagesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$chatMessagesHash();

  @override
  String toString() {
    return r'chatMessagesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ChatMessages create() => ChatMessages();

  @override
  bool operator ==(Object other) {
    return other is ChatMessagesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$chatMessagesHash() => r'578221775a04014f28ebad9e24e9e1f899bfa763';

final class ChatMessagesFamily extends $Family
    with
        $ClassFamilyOverride<
          ChatMessages,
          AsyncValue<List<ChatMessage>>,
          List<ChatMessage>,
          FutureOr<List<ChatMessage>>,
          String
        > {
  const ChatMessagesFamily._()
    : super(
        retry: null,
        name: r'chatMessagesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ChatMessagesProvider call(String roomId) =>
      ChatMessagesProvider._(argument: roomId, from: this);

  @override
  String toString() => r'chatMessagesProvider';
}

abstract class _$ChatMessages extends $AsyncNotifier<List<ChatMessage>> {
  late final _$args = ref.$arg as String;
  String get roomId => _$args;

  FutureOr<List<ChatMessage>> build(String roomId);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref =
        this.ref as $Ref<AsyncValue<List<ChatMessage>>, List<ChatMessage>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<ChatMessage>>, List<ChatMessage>>,
              AsyncValue<List<ChatMessage>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
