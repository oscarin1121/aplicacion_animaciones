import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../domain/entities/zenflow_models.dart';

extension ZenAccentX on ZenAccent {
  Color get baseColor {
    switch (this) {
      case ZenAccent.primary:
        return AppColors.primary;
      case ZenAccent.secondary:
        return AppColors.secondary;
      case ZenAccent.tertiary:
        return AppColors.tertiary;
      case ZenAccent.neutral:
        return AppColors.onSurfaceVariant;
    }
  }

  Color get containerColor {
    switch (this) {
      case ZenAccent.primary:
        return AppColors.primaryContainer;
      case ZenAccent.secondary:
        return AppColors.secondaryContainer;
      case ZenAccent.tertiary:
        return AppColors.tertiaryContainer;
      case ZenAccent.neutral:
        return AppColors.surfaceContainerHigh;
    }
  }

  Color get foregroundColor {
    switch (this) {
      case ZenAccent.primary:
        return AppColors.onPrimaryContainer;
      case ZenAccent.secondary:
        return AppColors.onSecondaryContainer;
      case ZenAccent.tertiary:
        return AppColors.onTertiaryContainer;
      case ZenAccent.neutral:
        return AppColors.onSurface;
    }
  }

  LinearGradient get softGradient {
    switch (this) {
      case ZenAccent.primary:
        return const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryContainer],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case ZenAccent.secondary:
        return const LinearGradient(
          colors: [Color(0xFFE7D8FA), AppColors.secondaryContainer],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case ZenAccent.tertiary:
        return const LinearGradient(
          colors: [Color(0xFFC2F5D1), AppColors.tertiaryContainer],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case ZenAccent.neutral:
        return const LinearGradient(
          colors: [AppColors.surfaceContainer, AppColors.surfaceContainerHigh],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
    }
  }
}

extension ZenIconTokenX on ZenIconToken {
  IconData get iconData {
    switch (this) {
      case ZenIconToken.focus:
        return Icons.center_focus_weak_rounded;
      case ZenIconToken.sleep:
        return Icons.nightlight_round;
      case ZenIconToken.anxiety:
        return Icons.air_rounded;
      case ZenIconToken.growth:
        return Icons.spa_rounded;
      case ZenIconToken.timer:
        return Icons.timer_outlined;
      case ZenIconToken.streak:
        return Icons.local_fire_department_rounded;
      case ZenIconToken.completed:
        return Icons.task_alt_rounded;
      case ZenIconToken.sunrise:
        return Icons.wb_sunny_outlined;
      case ZenIconToken.moon:
        return Icons.bedtime_rounded;
      case ZenIconToken.sparkles:
        return Icons.auto_awesome_rounded;
      case ZenIconToken.sleepTimer:
        return Icons.timer_rounded;
      case ZenIconToken.soundWave:
        return Icons.graphic_eq_rounded;
    }
  }
}
