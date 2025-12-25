import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/services/connectivity_service.dart';
import '../../core/services/locale_provider.dart';
import '../../core/localization/app_localizations_helper.dart';

/// Widget hiển thị snackbar cố định ở trên cùng khi mất kết nối mạng
class ConnectivitySnackbar extends ConsumerStatefulWidget {
  final Widget child;

  const ConnectivitySnackbar({
    super.key,
    required this.child,
  });

  @override
  ConsumerState<ConnectivitySnackbar> createState() =>
      _ConnectivitySnackbarState();
}

class _ConnectivitySnackbarState
    extends ConsumerState<ConnectivitySnackbar> {
  bool _showSnackbar = false;
  String _message = '';
  Color _snackbarColor = Colors.green;
  Timer? _hideTimer;

  void _showConnectionSnackbar(String message, Color color, bool autoHide) {
    if (!mounted) return;

    setState(() {
      _message = message;
      _snackbarColor = color;
      _showSnackbar = true;
    });

    if (autoHide) {
      _hideTimer?.cancel();
      _hideTimer = Timer(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _showSnackbar = false;
          });
        }
      });
    } else {
      // Nếu không autoHide, hủy timer nếu có
      _hideTimer?.cancel();
    }
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = ref.watch(appLocaleProvider);
    final languageCode = locale.languageCode;

    // Listen to changes and handle side effects
    // ref.listen can only be called in build method
    ref.listen<AsyncValue<bool>>(
      connectivityStreamProvider,
      (previous, next) {
        next.whenData((isConnected) {
          // Lần đầu tiên (previous == null) - kiểm tra trạng thái ban đầu
          if (previous == null) {
            if (!isConnected && mounted) {
              _showConnectionSnackbar(
                AppLocalizationsHelper.translate('networkError', languageCode),
                Colors.red,
                false,
              );
            }
            return;
          }

          // Kiểm tra thay đổi trạng thái
          previous.whenData((wasConnected) {
            if (wasConnected != isConnected && mounted) {
              if (!isConnected) {
                // Mất kết nối - hiển thị snackbar "Lỗi kết nối mạng"
                _showConnectionSnackbar(
                  AppLocalizationsHelper.translate('networkError', languageCode),
                  Colors.red,
                  false,
                );
              } else {
                // Có kết nối trở lại - hiển thị "Đã kết nối lại" rồi ẩn sau 2 giây
                _showConnectionSnackbar(
                  AppLocalizationsHelper.translate('reconnected', languageCode),
                  Colors.green,
                  true,
                );
              }
            }
          });
        });
      },
    );

    final mediaQuery = MediaQuery.of(context);
    final topPadding = mediaQuery.padding.top;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        widget.child,
        if (_showSnackbar)
          Positioned(
            top: topPadding + 8,
            left: 16,
            right: 16,
            child: Material(
              color: Colors.transparent,
              elevation: 6,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: _snackbarColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(
                      _snackbarColor == Colors.red
                          ? Icons.wifi_off_rounded
                          : Icons.wifi_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _message,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
