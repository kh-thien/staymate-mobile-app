import 'package:flutter/material.dart';
import '../../core/constants/app_styles.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final ButtonType type;
  final ButtonSize size;
  final Widget? icon;

  const CustomButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.type = ButtonType.primary,
    this.size = ButtonSize.medium,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget child = isLoading
        ? SizedBox(
            width: _getIconSize(),
            height: _getIconSize(),
            child: const CircularProgressIndicator(strokeWidth: 2),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                icon!,
                const SizedBox(width: AppSizes.paddingS),
              ],
              Text(text, style: _getTextStyle()),
            ],
          );

    switch (type) {
      case ButtonType.primary:
        return ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            padding: _getPadding(),
            minimumSize: Size(0, _getHeight()),
          ),
          child: child,
        );
      case ButtonType.secondary:
        return OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            padding: _getPadding(),
            minimumSize: Size(0, _getHeight()),
          ),
          child: child,
        );
      case ButtonType.text:
        return TextButton(
          onPressed: isLoading ? null : onPressed,
          style: TextButton.styleFrom(
            padding: _getPadding(),
            minimumSize: Size(0, _getHeight()),
          ),
          child: child,
        );
    }
  }

  EdgeInsets _getPadding() {
    switch (size) {
      case ButtonSize.small:
        return const EdgeInsets.symmetric(
          horizontal: AppSizes.paddingM,
          vertical: AppSizes.paddingS,
        );
      case ButtonSize.medium:
        return const EdgeInsets.symmetric(
          horizontal: AppSizes.paddingL,
          vertical: AppSizes.paddingM,
        );
      case ButtonSize.large:
        return const EdgeInsets.symmetric(
          horizontal: AppSizes.paddingXL,
          vertical: AppSizes.paddingL,
        );
    }
  }

  double _getHeight() {
    switch (size) {
      case ButtonSize.small:
        return 36;
      case ButtonSize.medium:
        return 48;
      case ButtonSize.large:
        return 56;
    }
  }

  double _getIconSize() {
    switch (size) {
      case ButtonSize.small:
        return AppSizes.iconS;
      case ButtonSize.medium:
        return AppSizes.iconM;
      case ButtonSize.large:
        return AppSizes.iconL;
    }
  }

  TextStyle _getTextStyle() {
    switch (size) {
      case ButtonSize.small:
        return AppTextStyles.bodySmall;
      case ButtonSize.medium:
        return AppTextStyles.bodyMedium;
      case ButtonSize.large:
        return AppTextStyles.bodyLarge;
    }
  }
}

enum ButtonType { primary, secondary, text }

enum ButtonSize { small, medium, large }
