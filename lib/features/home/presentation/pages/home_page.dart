import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../core/services/locale_provider.dart';
import '../../../../shared/providers/app_bar_provider.dart';
import '../widgets/home_greeting_card.dart';
import '../widgets/home_summary_row.dart';
import '../widgets/home_quick_actions.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final animationController = useAnimationController(
      duration: const Duration(milliseconds: 700),
    );
    final fadeAnimation = useMemoized(
      () => Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: animationController,
          curve: Curves.easeInOut,
        ),
      ),
      [animationController],
    );
    final slideAnimation = useMemoized(
      () => Tween<Offset>(
        begin: const Offset(0, 0.1),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: animationController,
          curve: Curves.easeOut,
        ),
      ),
      [animationController],
    );

    useEffect(() {
      final notifier = ref.read(appBarProvider.notifier);
      Future.microtask(notifier.reset);
      animationController.forward();
      return null;
    }, const []);

    final languageCode = ref.watch(appLocaleProvider).languageCode;

    return FadeTransition(
      opacity: fadeAnimation,
      child: SlideTransition(
        position: slideAnimation,
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(28),
              topRight: Radius.circular(28),
            ),
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(28),
              topRight: Radius.circular(28),
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HomeGreetingCard(languageCode: languageCode),
                  const SizedBox(height: 20),
                  HomeSummaryRow(languageCode: languageCode),
                  const SizedBox(height: 24),
                  HomeQuickActions(languageCode: languageCode),
                  const SizedBox(height: 120),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
