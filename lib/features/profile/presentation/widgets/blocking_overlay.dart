import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/constants/app_styles.dart';

class BlockingOverlay extends StatefulWidget {
  const BlockingOverlay({
    super.key,
    required this.isDark,
    this.message,
    this.progress,
  });

  final bool isDark;
  final String? message;
  final double? progress; // 0.0 to 1.0

  @override
  State<BlockingOverlay> createState() => _BlockingOverlayState();
}

class _BlockingOverlayState extends State<BlockingOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final progress = widget.progress ?? 0.0;
    final progressPercent = (progress * 100).clamp(0.0, 100.0).toInt();
    final mediaQuery = MediaQuery.of(context);

    return Material(
      color: Colors.transparent,
      child: AbsorbPointer(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          width: mediaQuery.size.width,
          height: mediaQuery.size.height,
          color: Colors.black.withOpacity(widget.isDark ? 0.7 : 0.5),
          child: Center(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 32),
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: widget.isDark
                    ? AppColors.surfaceDarkElevated
                    : Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Animated delete icon
                  AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return Transform.rotate(
                        angle: _animationController.value * 2 * math.pi * 0.1,
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.redAccent.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.delete_outline_rounded,
                            size: 48,
                            color: Colors.redAccent,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  // Progress indicator
                  SizedBox(
                    height: 6,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(3),
                      child: LinearProgressIndicator(
                        value: progress,
                        backgroundColor: widget.isDark
                            ? AppColors.dividerDark
                            : Colors.grey[200],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.redAccent,
                        ),
                        minHeight: 6,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Progress percentage
                  Text(
                    '$progressPercent%',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: widget.isDark
                          ? AppColors.textPrimaryDark
                          : AppColors.textPrimary,
                    ),
                  ),
                  if (widget.message != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      widget.message!,
                      style: TextStyle(
                        fontSize: 14,
                        color: widget.isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
