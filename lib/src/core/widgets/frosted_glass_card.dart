import 'dart:ui';

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class FrostedGlassCard extends StatelessWidget {
  const FrostedGlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(24),
    this.backgroundColor,
    this.gradient,
    this.borderRadius = 32,
    this.showGhostBorder = true,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? backgroundColor;
  final Gradient? gradient;
  final double borderRadius;
  final bool showGhostBorder;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(borderRadius);

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: radius,
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 56,
            spreadRadius: -12,
            offset: Offset(0, 28),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: radius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: backgroundColor ?? Colors.white.withValues(alpha: 0.68),
              gradient: gradient,
              borderRadius: radius,
              border: showGhostBorder
                  ? Border.all(
                      color: AppColors.outlineVariant.withValues(alpha: 0.15),
                    )
                  : null,
            ),
            child: Padding(padding: padding, child: child),
          ),
        ),
      ),
    );
  }
}
