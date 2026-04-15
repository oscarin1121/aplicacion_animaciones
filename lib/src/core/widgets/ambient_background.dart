import 'dart:ui';

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class AmbientBackground extends StatelessWidget {
  const AmbientBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(color: AppColors.surface),
          ),
        ),
        const Positioned(
          top: -120,
          left: -80,
          child: _BlurBlob(color: AppColors.primaryContainer, size: 280),
        ),
        const Positioned(
          top: 220,
          right: -110,
          child: _BlurBlob(color: AppColors.secondaryContainer, size: 260),
        ),
        const Positioned(
          bottom: -120,
          left: 24,
          child: _BlurBlob(color: AppColors.tertiaryContainer, size: 320),
        ),
        Positioned.fill(
          child: IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.topCenter,
                  radius: 1.15,
                  colors: [
                    Colors.white.withValues(alpha: 0.78),
                    Colors.white.withValues(alpha: 0.18),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ),
        child,
      ],
    );
  }
}

class _BlurBlob extends StatelessWidget {
  const _BlurBlob({required this.color, required this.size});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withValues(alpha: 0.42),
        ),
      ),
    );
  }
}
