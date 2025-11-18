import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/ui_constants.dart';
import '../../../../core/services/locale_provider.dart';
import '../../../../core/localization/app_localizations_helper.dart';
import '../providers/chat_rooms_provider.dart';
import '../providers/unread_count_provider.dart';
import '../providers/realtime_chat_rooms_provider.dart';
import '../widgets/chat_room_card.dart';
import '../widgets/chat_empty_state.dart';
import '../../../../shared/widgets/skeleton_loader.dart';
import '../../../../shared/providers/app_bar_provider.dart';


/// Chat list page showing all chat rooms
class ChatListPage extends HookConsumerWidget {
  const ChatListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final languageCode = ref.watch(appLocaleProvider).languageCode;

    // Manage AppBar State
    useEffect(() {
      final notifier = ref.read(appBarProvider.notifier);
      // Use a small delay to ensure this runs after any cleanup from previous page
      Future.microtask(() {
        notifier.updateTitle(
          AppLocalizationsHelper.translate('chat', languageCode),
        );
      });
      // Don't reset in cleanup - let the next page set its own title
      return null;
    }, const []);

    final roomsAsync = ref.watch(chatRoomsProvider);
    // Keep provider active for badge updates
    ref.watch(unreadCountProvider);

    // Listen to realtime updates for chat rooms
    ref.listen<AsyncValue<void>>(realtimeChatRoomsProvider, (previous, next) {
      print('🔔 [ChatListPage] Realtime update detected');
    });

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          child: roomsAsync.when(
            data: (rooms) {
              final locale = ref.watch(appLocaleProvider);
              final languageCode = locale.languageCode;
              
              if (rooms.isEmpty) {
                return ChatEmptyState(
                  message: AppLocalizationsHelper.translate('noConversationsYet', languageCode),
                  onRefresh: () => ref.invalidate(chatRoomsProvider),
                );
              }

              return RefreshIndicator(
                onRefresh: () async {
                  ref.invalidate(chatRoomsProvider);
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    8,
                    20,
                    8,
                    UIConstants.contentBottomPadding,
                  ),
                  child: ListView.builder(
                    itemCount: rooms.length,
                    itemBuilder: (context, index) {
                      final room = rooms[index];
                      return ChatRoomCard(
                        room: room,
                        onTap: () {
                          context.go('/chat/${room.id}');
                        },
                      );
                    },
                  ),
                ),
              );
            },
                        loading: () => ListView.builder(
              padding: const EdgeInsets.fromLTRB(
                8,
                20,
                8,
                UIConstants.contentBottomPadding,
              ),
              itemCount: 8, // Display 8 skeleton items while loading
              itemBuilder: (context, index) => const ChatRoomCardSkeleton(),
            ),
            error: (error, stack) {
              final locale = ref.watch(appLocaleProvider);
              final languageCode = locale.languageCode;
              
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline_rounded,
                        size: 64,
                        color: Colors.red.shade400,
                      ),
                      const SizedBox(height: 16),
                      SelectableText.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: '${AppLocalizationsHelper.translate('error', languageCode)}: ',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                                fontSize: 16,
                              ),
                            ),
                            TextSpan(
                              text: error.toString(),
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: () {
                          ref.invalidate(chatRoomsProvider);
                        },
                        icon: const Icon(Icons.refresh_rounded),
                        label: Text(
                          AppLocalizationsHelper.translate('tryAgain', languageCode),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
