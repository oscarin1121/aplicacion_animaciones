import 'package:flutter/material.dart';

import '../../features/zenflow/domain/entities/zenflow_models.dart';
import '../../features/zenflow/presentation/zenflow_visuals.dart';
import '../theme/app_colors.dart';
import 'frosted_glass_card.dart';

class WeeklyBarChartCard extends StatelessWidget {
  const WeeklyBarChartCard({
    super.key,
    required this.title,
    required this.bars,
    this.subtitle,
    this.chartHeight = 170,
  });

  final String title;
  final String? subtitle;
  final List<WeeklyBar> bars;
  final double chartHeight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FrostedGlassCard(
      padding: const EdgeInsets.all(28),
      backgroundColor: AppColors.surfaceLowest.withValues(alpha: 0.74),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.headlineMedium?.copyWith(fontSize: 28),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 8),
            Text(
              subtitle!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ],
          const SizedBox(height: 28),
          SizedBox(
            height: chartHeight,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (var index = 0; index < bars.length; index++) ...[
                  if (index != 0) const SizedBox(width: 10),
                  Expanded(
                    child: _ChartBar(
                      bar: bars[index],
                      height: chartHeight,
                      index: index,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ChartBar extends StatelessWidget {
  const _ChartBar({
    required this.bar,
    required this.height,
    required this.index,
  });

  final WeeklyBar bar;
  final double height;
  final int index;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const labelSectionHeight = 28.0;
    const labelGap = 10.0;
    final availableBarHeight = (height - labelSectionHeight - labelGap).clamp(
      24.0,
      double.infinity,
    );

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: bar.value),
      duration: Duration(milliseconds: 720 + (index * 70)),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        final clampedHeight = value.clamp(0.12, 1.0) * availableBarHeight;

        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: clampedHeight,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(999),
                    color: bar.highlighted
                        ? bar.accent.baseColor
                        : bar.accent.containerColor.withValues(alpha: 0.92),
                    boxShadow: bar.highlighted
                        ? [
                            BoxShadow(
                              color: bar.accent.baseColor.withValues(
                                alpha: 0.22,
                              ),
                              blurRadius: 18,
                              spreadRadius: -4,
                              offset: const Offset(0, 12),
                            ),
                          ]
                        : null,
                  ),
                ),
              ),
            ),
            const SizedBox(height: labelGap),
            SizedBox(
              height: labelSectionHeight,
              child: Center(
                child: Text(
                  bar.label,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: bar.highlighted
                        ? AppColors.primary
                        : AppColors.outline,
                    fontWeight: bar.highlighted
                        ? FontWeight.w700
                        : FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
