// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../../../../features/chat/presentation/providers/realtime_messages_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(realtimeMessages)
const realtimeMessagesProvider = RealtimeMessagesFamily._();

final class RealtimeMessagesProvider
    extends
        $FunctionalProvider<
          AsyncValue<ChatMessage>,
          ChatMessage,
          Stream<ChatMessage>
        >
    with $FutureModifier<ChatMessage>, $StreamProvider<ChatMessage> {
  const RealtimeMessagesProvider._({
    required RealtimeMessagesFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'realtimeMessagesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$realtimeMessagesHash();

  @override
  String toString() {
    return r'realtimeMessagesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<ChatMessage> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<ChatMessage> create(Ref ref) {
    final argument = this.argument as String;
    return realtimeMessages(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is RealtimeMessagesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$realtimeMessagesHash() => r'693c9eab76f76e29e82ba51391144f6ac44b8fb1';

final class RealtimeMessagesFamily extends $Family
    with $FunctionalFamilyOverride<Stream<ChatMessage>, String> {
  const RealtimeMessagesFamily._()
    : super(
        retry: null,
        name: r'realtimeMessagesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  RealtimeMessagesProvider call(String roomId) =>
      RealtimeMessagesProvider._(argument: roomId, from: this);

  @override
  String toString() => r'realtimeMessagesProvider';
}
