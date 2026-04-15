import 'dart:ui';

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

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeData = ref.watch(homeDataProvider);

    return homeData.when(
      data: (data) => _HomeBody(data: data),
      loading: () => const Center(child: CircularProgressIndicator.adaptive()),
      error: (error, stackTrace) => const Center(
        child: Text('No pudimos cargar la experiencia principal.'),
      ),
    );
  }
}

class _HomeBody extends StatelessWidget {
  const _HomeBody({required this.data});

  final HomeScreenData data;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedReveal(
            child: _BreathingHero(
              title: data.heroTitle,
              subtitle: data.heroSubtitle,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          AnimatedReveal(
            delay: const Duration(milliseconds: 120),
            child: _RitualFeatureCard(ritual: data.ritual),
          ),
          const SizedBox(height: AppSpacing.xl),
          AnimatedReveal(
            delay: const Duration(milliseconds: 220),
            child: _CategorySection(categories: data.categories),
          ),
          const SizedBox(height: AppSpacing.xl),
          AnimatedReveal(
            delay: const Duration(milliseconds: 320),
            child: _HomeInsightsSection(data: data),
          ),
        ],
      ),
    );
  }
}

class _BreathingHero extends StatefulWidget {
  const _BreathingHero({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  State<_BreathingHero> createState() => _BreathingHeroState();
}

class _BreathingHeroState extends State<_BreathingHero>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Text(
          widget.title,
          textAlign: TextAlign.center,
          style: theme.textTheme.displayMedium?.copyWith(
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          widget.subtitle,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        SizedBox(
          width: 240,
          height: 240,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              final progress = _controller.value;
              final scale = _scaleFor(progress);
              final label = _labelFor(progress);

              return Stack(
                alignment: Alignment.center,
                children: [
                  Transform.scale(
                    scale: 1.1 + (progress * 0.12),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primaryContainer.withValues(
                          alpha: 0.16,
                        ),
                      ),
                    ),
                  ),
                  Transform.scale(
                    scale: 0.94 + (progress * 0.08),
                    child: Container(
                      width: 206,
                      height: 206,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.tertiaryContainer.withValues(
                          alpha: 0.20,
                        ),
                      ),
                    ),
                  ),
                  Transform.scale(
                    scale: scale,
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.92),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.shadow.withValues(alpha: 0.9),
                            blurRadius: 36,
                            spreadRadius: -8,
                            offset: const Offset(0, 20),
                          ),
                        ],
                      ),
                      child: Center(
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 500),
                          child: Text(
                            label,
                            key: ValueKey(label),
                            style: theme.textTheme.headlineMedium?.copyWith(
                              fontStyle: FontStyle.italic,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  double _scaleFor(double progress) {
    if (progress < 0.4) {
      return lerpDouble(0.88, 1.06, progress / 0.4)!;
    }
    if (progress < 0.6) {
      return 1.06;
    }
    return lerpDouble(1.06, 0.9, (progress - 0.6) / 0.4)!;
  }

  String _labelFor(double progress) {
    if (progress < 0.4) {
      return 'Inhale';
    }
    if (progress < 0.6) {
      return 'Hold';
    }
    return 'Exhale';
  }
}

class _RitualFeatureCard extends StatelessWidget {
  const _RitualFeatureCard({required this.ritual});

  final DailyRitual ritual;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 620;

        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(38),
            gradient: const LinearGradient(
              colors: [AppColors.primary, AppColors.primaryDim],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.18),
                blurRadius: 56,
                spreadRadius: -12,
                offset: const Offset(0, 28),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: isWide
                ? Row(
                    children: [
                      Expanded(child: _RitualText(ritual: ritual)),
                      const SizedBox(width: 24),
                      Expanded(
                        child: _RitualImage(imageAsset: ritual.imageAsset),
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _RitualText(ritual: ritual),
                      const SizedBox(height: 24),
                      _RitualImage(imageAsset: ritual.imageAsset),
                    ],
                  ),
          ),
        );
      },
    );
  }
}

class _RitualText extends StatelessWidget {
  const _RitualText({required this.ritual});

  final DailyRitual ritual;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.18),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.star_rounded,
                color: AppColors.onPrimary,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                'DAILY RITUAL',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: AppColors.onPrimary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Text(
          ritual.title,
          style: theme.textTheme.headlineLarge?.copyWith(
            color: AppColors.onPrimary,
            height: 1.08,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          ritual.description,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: AppColors.onPrimary.withValues(alpha: 0.82),
          ),
        ),
        const SizedBox(height: 24),
        FilledButton(
          onPressed: () {},
          style: FilledButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: AppColors.primary,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.play_arrow_rounded),
              const SizedBox(width: 8),
              Text(ritual.callToAction),
            ],
          ),
        ),
      ],
    );
  }
}

class _RitualImage extends StatelessWidget {
  const _RitualImage({required this.imageAsset});

  final String imageAsset;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: AspectRatio(
        aspectRatio: 0.92,
        child: Image.asset(imageAsset, fit: BoxFit.cover),
      ),
    );
  }
}

class _CategorySection extends ConsumerWidget {
  const _CategorySection({required this.categories});

  final List<FocusCategory> categories;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedId = ref.watch(selectedCategoryIdProvider);
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Explore States',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontSize: 30,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Find what your mind needs today',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            TextButton(onPressed: () {}, child: const Text('View All')),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 154,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            separatorBuilder: (context, index) => const SizedBox(width: 18),
            itemBuilder: (context, index) {
              final category = categories[index];
              final isSelected = selectedId == category.id;

              return _CategoryCard(
                category: category,
                isSelected: isSelected,
                onTap: () {
                  ref
                      .read(selectedCategoryIdProvider.notifier)
                      .select(category.id);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  final FocusCategory category;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 320),
      width: 148,
      decoration: BoxDecoration(
        color: isSelected
            ? category.accent.containerColor.withValues(alpha: 0.48)
            : AppColors.surfaceContainerLow.withValues(alpha: 0.78),
        borderRadius: BorderRadius.circular(32),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: category.accent.baseColor.withValues(alpha: 0.12),
                  blurRadius: 28,
                  spreadRadius: -8,
                  offset: const Offset(0, 14),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(32),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 320),
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: category.accent.containerColor.withValues(
                      alpha: 0.72,
                    ),
                  ),
                  child: Icon(
                    category.icon.iconData,
                    color: category.accent.baseColor,
                  ),
                ),
                const Spacer(),
                Text(category.title, style: theme.textTheme.titleMedium),
                const SizedBox(height: 6),
                Text(
                  '${category.sessions} SESSIONS',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HomeInsightsSection extends StatelessWidget {
  const _HomeInsightsSection({required this.data});

  final HomeScreenData data;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 720;

        return isWide
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 7,
                    child: WeeklyBarChartCard(
                      title: 'Weekly Mindfulness',
                      bars: data.weeklyBars,
                      chartHeight: 130,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(flex: 4, child: _SummaryCard(summary: data.summary)),
                ],
              )
            : Column(
                children: [
                  WeeklyBarChartCard(
                    title: 'Weekly Mindfulness',
                    bars: data.weeklyBars,
                    chartHeight: 130,
                  ),
                  const SizedBox(height: 20),
                  _SummaryCard(summary: data.summary),
                ],
              );
      },
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.summary});

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
          Icon(
            summary.icon.iconData,
            color: summary.accent.foregroundColor,
            size: 28,
          ),
          const SizedBox(height: 26),
          RichText(
            text: TextSpan(
              style: theme.textTheme.displaySmall?.copyWith(
                fontFamily: 'NotoSerif',
                color: summary.accent.foregroundColor,
              ),
              children: [
                TextSpan(text: summary.value),
                TextSpan(
                  text: ' ${summary.suffix}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: summary.accent.foregroundColor.withValues(
                      alpha: 0.82,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            summary.title.toUpperCase(),
            style: theme.textTheme.labelMedium?.copyWith(
              color: summary.accent.foregroundColor.withValues(alpha: 0.78),
            ),
          ),
          const SizedBox(height: 18),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: summary.progress,
              minHeight: 6,
              backgroundColor: summary.accent.foregroundColor.withValues(
                alpha: 0.10,
              ),
              valueColor: AlwaysStoppedAnimation<Color>(
                summary.accent.foregroundColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
