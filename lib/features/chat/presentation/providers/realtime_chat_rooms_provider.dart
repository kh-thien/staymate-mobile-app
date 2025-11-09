import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'chat_rooms_provider.dart';

part '../../../../generated/features/chat/presentation/providers/realtime_chat_rooms_provider.g.dart';

/// Provider that listens to realtime updates for chat rooms
/// Updates happen when:
/// - New message sent to any room
/// - Message marked as read
/// - Room updated
@riverpod
Stream<void> realtimeChatRooms(Ref ref) {
  final supabase = Supabase.instance.client;
  final controller = StreamController<void>();

  print('🔥 [RealtimeChatRooms] Setting up realtime subscription...');

  // Subscribe to chat_messages table changes
  final subscription = supabase
      .channel('chat_rooms_updates')
      .onPostgresChanges(
        event: PostgresChangeEvent.insert,
        schema: 'public',
        table: 'chat_messages',
        callback: (payload) {
          print('🔔 [RealtimeChatRooms] New message inserted');
          // Refresh chat rooms list only if current state is not error
          final currentState = ref.read(chatRoomsProvider);
          if (!currentState.hasError) {
          ref.read(chatRoomsProvider.notifier).refresh();
          controller.add(null);
          } else {
            print('⚠️ [RealtimeChatRooms] Skipping refresh due to error state');
          }
        },
      )
      .onPostgresChanges(
        event: PostgresChangeEvent.update,
        schema: 'public',
        table: 'chat_participants',
        callback: (payload) {
          print('🔔 [RealtimeChatRooms] Participant updated (mark as read)');
          print('   Payload: ${payload.newRecord}');
          // Refresh chat rooms list only if current state is not error
          final currentState = ref.read(chatRoomsProvider);
          if (!currentState.hasError) {
          ref.read(chatRoomsProvider.notifier).refresh();
          controller.add(null);
          } else {
            print('⚠️ [RealtimeChatRooms] Skipping refresh due to error state');
          }
        },
      )
      .subscribe();

  // Cleanup
  ref.onDispose(() {
    print('🧹 [RealtimeChatRooms] Cleaning up subscription');
    subscription.unsubscribe();
    controller.close();
  });

  return controller.stream;
}
