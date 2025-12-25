import 'dart:ui';
import 'package:flutter/material.dart';

/// Glassmorphism widget - Tạo hiệu ứng kính mờ giống iOS
/// 
/// Sử dụng:
/// ```dart
/// GlassmorphismWidget(
///   blur: 10.0,
///   opacity: 0.2,
///   child: YourContent(),
/// )
/// ```
class GlassmorphismWidget extends StatelessWidget {
  const GlassmorphismWidget({
    super.key,
    required this.child,
    this.blur = 10.0,
    this.opacity = 0.2,
    this.borderRadius,
    this.borderColor,
    this.borderWidth = 1.0,
    this.gradient,
  });

  /// Widget con bên trong
  final Widget child;

  /// Độ blur (mờ) - giá trị càng cao càng mờ
  /// Khuyến nghị: 5.0 - 20.0
  final double blur;

  /// Độ trong suốt của background (0.0 - 1.0)
  /// Khuyến nghị: 0.1 - 0.3
  final double opacity;

  /// Border radius cho góc bo tròn
  final BorderRadius? borderRadius;

  /// Màu viền (tùy chọn)
  final Color? borderColor;

  /// Độ dày viền
  final double borderWidth;

  /// Gradient tùy chỉnh (tùy chọn)
  /// Nếu không có, sẽ dùng màu trắng với opacity
  final Gradient? gradient;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          decoration: BoxDecoration(
            gradient: gradient ??
                LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withOpacity(opacity),
                    Colors.white.withOpacity(opacity * 0.8),
                  ],
                ),
            borderRadius: borderRadius ?? BorderRadius.circular(20),
            border: borderColor != null
                ? Border.all(
                    color: borderColor!,
                    width: borderWidth,
                  )
                : null,
          ),
          child: child,
        ),
      ),
    );
  }
}

/// Glassmorphism card - Card với hiệu ứng kính mờ
class GlassmorphismCard extends StatelessWidget {
  const GlassmorphismCard({
    super.key,
    required this.child,
    this.blur = 10.0,
    this.opacity = 0.2,
    this.borderRadius,
    this.borderColor,
    this.borderWidth = 1.0,
    this.padding,
    this.margin,
    this.onTap,
  });

  final Widget child;
  final double blur;
  final double opacity;
  final BorderRadius? borderRadius;
  final Color? borderColor;
  final double borderWidth;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    Widget content = GlassmorphismWidget(
      blur: blur,
      opacity: opacity,
      borderRadius: borderRadius,
      borderColor: borderColor,
      borderWidth: borderWidth,
      child: padding != null
          ? Padding(
              padding: padding!,
              child: child,
            )
          : child,
    );

    if (margin != null) {
      content = Padding(
        padding: margin!,
        child: content,
      );
    }

    if (onTap != null) {
      content = InkWell(
        onTap: onTap,
        borderRadius: borderRadius ?? BorderRadius.circular(20),
        child: content,
      );
    }

    return content;
  }
}

/// Glassmorphism button - Button với hiệu ứng kính mờ
class GlassmorphismButton extends StatelessWidget {
  const GlassmorphismButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.blur = 10.0,
    this.opacity = 0.2,
    this.borderRadius,
    this.padding,
    this.minSize,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final double blur;
  final double opacity;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;
  final Size? minSize;

  @override
  Widget build(BuildContext context) {
    return GlassmorphismWidget(
      blur: blur,
      opacity: opacity,
      borderRadius: borderRadius,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: borderRadius ?? BorderRadius.circular(20),
          child: Container(
            constraints: minSize != null
                ? BoxConstraints(minWidth: minSize!.width, minHeight: minSize!.height)
                : null,
            padding: padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: child,
          ),
        ),
      ),
    );
  }
}

