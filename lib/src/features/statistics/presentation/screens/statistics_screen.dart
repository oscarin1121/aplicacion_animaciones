import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/animated_reveal.dart';
import '../../../../core/widgets/frosted_glass_card.dart';
import '../../../../core/widgets/weekly_bar_chart_card.dart';
import '../../../zenflow/domain/entities/zenflow_models.dart';
import '../../../zenflow/presentation/providers/zenflow_providers.dart';
import '../../../zenflow/presentation/zenflow_visuals.dart';

class StatisticsScreen extends ConsumerWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statisticsData = ref.watch(statisticsDataProvider);

    return statisticsData.when(
      data: (data) => _StatisticsBody(data: data),
      loading: () => const Center(child: CircularProgressIndicator.adaptive()),
      error: (error, stackTrace) =>
          const Center(child: Text('No pudimos cargar tus estadísticas.')),
    );
  }
}

class _StatisticsBody extends StatelessWidget {
  const _StatisticsBody({required this.data});

  final StatisticsScreenData data;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedReveal(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.title,
                  style: theme.textTheme.displayMedium?.copyWith(
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  data.subtitle,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          AnimatedReveal(
            delay: const Duration(milliseconds: 120),
            child: WeeklyBarChartCard(
              title: 'Weekly Mindfulness',
              bars: data.weeklyBars,
              chartHeight: 180,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          AnimatedReveal(
            delay: const Duration(milliseconds: 220),
            child: _StatisticsCards(data: data),
          ),
          const SizedBox(height: AppSpacing.xl),
          AnimatedReveal(
            delay: const Duration(milliseconds: 320),
            child: _PatternsSection(patterns: data.patterns),
          ),
          const SizedBox(height: AppSpacing.xl),
          AnimatedReveal(
            delay: const Duration(milliseconds: 420),
            child: Center(
              child: Column(
                children: [
                  Icon(
                    Icons.park_outlined,
                    color: AppColors.primary.withValues(alpha: 0.40),
                    size: 34,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    data.quote,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontFamily: 'NotoSerif',
                      fontStyle: FontStyle.italic,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatisticsCards extends StatelessWidget {
  const _StatisticsCards({required this.data});

  final StatisticsScreenData data;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final splitMetrics = constraints.maxWidth > 600;

        return Column(
          children: [
            _HeroMetricCard(summary: data.minutesMetric),
            const SizedBox(height: 18),
            if (splitMetrics)
              Row(
                children: [
                  Expanded(child: _MiniMetricCard(summary: data.streakMetric)),
                  const SizedBox(width: 18),
                  Expanded(
                    child: _MiniMetricCard(summary: data.completedMetric),
                  ),
                ],
              )
            else ...[
              _MiniMetricCard(summary: data.streakMetric),
              const SizedBox(height: 18),
              _MiniMetricCard(summary: data.completedMetric),
            ],
            const SizedBox(height: 18),
            _CommunityCard(community: data.community),
          ],
        );
      },
    );
  }
}

class _HeroMetricCard extends StatelessWidget {
  const _HeroMetricCard({required this.summary});

  final MetricSummary summary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FrostedGlassCard(
      gradient: summary.accent.softGradient,
      showGhostBorder: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(summary.icon.iconData, color: AppColors.onPrimary, size: 28),
          const SizedBox(height: 20),
          Text(
            summary.title.toUpperCase(),
            style: theme.textTheme.labelMedium?.copyWith(
              color: AppColors.onPrimary.withValues(alpha: 0.72),
            ),
          ),
          const SizedBox(height: 20),
          RichText(
            text: TextSpan(
              style: theme.textTheme.displayMedium?.copyWith(
                color: AppColors.onPrimary,
              ),
              children: [
                TextSpan(text: summary.value),
                TextSpan(
                  text: ' ${summary.suffix}',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: AppColors.onPrimary.withValues(alpha: 0.78),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniMetricCard extends StatelessWidget {
  const _MiniMetricCard({required this.summary});

  final MetricSummary summary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FrostedGlassCard(
      backgroundColor: summary.accent == ZenAccent.secondary
          ? AppColors.secondaryContainer.withValues(alpha: 0.78)
          : Colors.white.withValues(alpha: 0.72),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            summary.icon.iconData,
            color: summary.accent.baseColor,
            size: 28,
          ),
          const SizedBox(height: 18),
          Text(
            summary.value,
            style: theme.textTheme.displaySmall?.copyWith(
              fontFamily: 'NotoSerif',
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            summary.title.toUpperCase(),
            style: theme.textTheme.labelMedium?.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
          if (summary.progress < 1) ...[
            const SizedBox(height: 18),
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                value: summary.progress,
                minHeight: 5,
                backgroundColor: AppColors.surfaceContainerHighest,
                valueColor: AlwaysStoppedAnimation<Color>(
                  summary.accent.baseColor,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _CommunityCard extends StatelessWidget {
  const _CommunityCard({required this.community});

  final CommunityHighlight community;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FrostedGlassCard(
      backgroundColor: AppColors.surfaceContainer.withValues(alpha: 0.74),
      child: Row(
        children: [
          const _AvatarStack(),
          const SizedBox(width: 18),
          Expanded(
            child: Text(
              community.description,
              style: theme.textTheme.bodyLarge,
            ),
          ),
        ],
      ),
    );
  }
}

class _AvatarStack extends StatelessWidget {
  const _AvatarStack();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 110,
      height: 44,
      child: Stack(
        children: [
          _avatar(const Color(0xFFDD8B8B), 0),
          _avatar(const Color(0xFF1B1C1F), 24),
          Positioned(
            left: 48,
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryContainer,
                border: Border.all(color: Colors.white, width: 2),
              ),
              alignment: Alignment.center,
              child: const Text(
                '+14',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.onPrimaryContainer,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _avatar(Color color, double left) {
    return Positioned(
      left: left,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          border: Border.all(color: Colors.white, width: 2),
        ),
        child: const Icon(Icons.person_rounded, color: Colors.white, size: 22),
      ),
    );
  }
}

class _PatternsSection extends StatelessWidget {
  const _PatternsSection({required this.patterns});

  final List<DailyPattern> patterns;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Daily Patterns',
          style: theme.textTheme.headlineMedium?.copyWith(
            fontSize: 32,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 18),
        for (var index = 0; index < patterns.length; index++) ...[
          _PatternCard(pattern: patterns[index]),
          if (index != patterns.length - 1) const SizedBox(height: 16),
        ],
      ],
    );
  }
}

class _PatternCard extends StatelessWidget {
  const _PatternCard({required this.pattern});

  final DailyPattern pattern;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FrostedGlassCard(
      backgroundColor: Colors.white.withValues(alpha: 0.78),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: pattern.accent.containerColor.withValues(alpha: 0.70),
            ),
            child: Icon(pattern.icon.iconData, color: pattern.accent.baseColor),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(pattern.title, style: theme.textTheme.titleMedium),
                const SizedBox(height: 4),
                Text(
                  pattern.description,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 18),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                pattern.status,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                pattern.caption.toUpperCase(),
                style: theme.textTheme.labelMedium?.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
