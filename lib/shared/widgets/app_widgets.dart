import 'package:flutter/material.dart';
import '../../core/constants/app_styles.dart';

class LoadingWidget extends StatelessWidget {
  final String? message;
  final Color? color;
  final double size;

  const LoadingWidget({Key? key, this.message, this.color, this.size = 24.0})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              color: color ?? AppColors.primary,
              strokeWidth: 2.0,
            ),
          ),
          if (message != null) ...[
            const SizedBox(height: AppSizes.paddingM),
            Text(
              message!,
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}

class ErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  final IconData icon;

  const ErrorWidget({
    Key? key,
    required this.message,
    this.onRetry,
    this.icon = Icons.error_outline,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: AppSizes.iconXL, color: AppColors.error),
          const SizedBox(height: AppSizes.paddingM),
          Text(
            message,
            style: AppTextStyles.bodyMedium,
            textAlign: TextAlign.center,
          ),
          if (onRetry != null) ...[
            const SizedBox(height: AppSizes.paddingL),
            ElevatedButton(onPressed: onRetry, child: const Text('Thử lại')),
          ],
        ],
      ),
    );
  }
}

class EmptyWidget extends StatelessWidget {
  final String message;
  final IconData icon;
  final VoidCallback? onRefresh;

  const EmptyWidget({
    Key? key,
    required this.message,
    this.icon = Icons.inbox_outlined,
    this.onRefresh,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: AppSizes.iconXL * 2, color: AppColors.textSecondary),
          const SizedBox(height: AppSizes.paddingL),
          Text(
            message,
            style: AppTextStyles.bodyLarge,
            textAlign: TextAlign.center,
          ),
          if (onRefresh != null) ...[
            const SizedBox(height: AppSizes.paddingL),
            TextButton(onPressed: onRefresh, child: const Text('Làm mới')),
          ],
        ],
      ),
    );
  }
}
