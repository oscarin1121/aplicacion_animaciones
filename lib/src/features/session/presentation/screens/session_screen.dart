import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/animated_reveal.dart';
import '../../../../core/widgets/frosted_glass_card.dart';
import '../providers/session_controller.dart';

class SessionScreen extends ConsumerWidget {
  const SessionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(sessionControllerProvider);

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight - 12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedReveal(
                  child: Column(
                    children: [
                      Text(
                        state.preset.subtitle.toUpperCase(),
                        style: Theme.of(context).textTheme.labelMedium
                            ?.copyWith(
                              color: AppColors.primary.withValues(alpha: 0.34),
                            ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        state.preset.title,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.displayMedium
                            ?.copyWith(color: AppColors.onSurface),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xxl),
                AnimatedReveal(
                  delay: const Duration(milliseconds: 120),
                  child: _SessionOrb(state: state),
                ),
                const SizedBox(height: AppSpacing.xl),
                AnimatedReveal(
                  delay: const Duration(milliseconds: 220),
                  child: _ControlPanel(state: state),
                ),
                const SizedBox(height: AppSpacing.lg),
                AnimatedReveal(
                  delay: const Duration(milliseconds: 320),
                  child: _StatusChips(state: state),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SessionOrb extends StatelessWidget {
  const _SessionOrb({required this.state});

  final SessionViewState state;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scale = state.isPlaying ? 0.88 + (state.breathProgress * 0.18) : 0.92;

    return SizedBox(
      width: 330,
      height: 330,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 900),
            width: 300 * scale,
            height: 300 * scale,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.08),
              ),
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 900),
            width: 248 * scale,
            height: 248 * scale,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.12),
              ),
            ),
          ),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.9, end: scale),
            duration: const Duration(milliseconds: 900),
            curve: Curves.easeInOutCubic,
            builder: (context, animatedScale, child) {
              return Transform.scale(scale: animatedScale, child: child);
            },
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [AppColors.primaryContainer, AppColors.surfaceLowest],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.16),
                    blurRadius: 70,
                    spreadRadius: -18,
                    offset: const Offset(0, 30),
                  ),
                ],
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      state.remainingLabel,
                      style: theme.textTheme.displayMedium?.copyWith(
                        color: AppColors.onPrimaryContainer.withValues(
                          alpha: 0.78,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      state.phaseLabel.toUpperCase(),
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: AppColors.primary.withValues(alpha: 0.48),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ControlPanel extends ConsumerWidget {
  const _ControlPanel({required this.state});

  final SessionViewState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FrostedGlassCard(
      borderRadius: 42,
      padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 22),
      backgroundColor: Colors.white.withValues(alpha: 0.74),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  ref.read(sessionControllerProvider.notifier).toggleSound();
                },
                icon: Icon(
                  state.isSoundEnabled
                      ? Icons.volume_up_rounded
                      : Icons.volume_off_rounded,
                  color: AppColors.onSurfaceVariant,
                  size: 32,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryContainer],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.18),
                      blurRadius: 32,
                      spreadRadius: -8,
                      offset: const Offset(0, 18),
                    ),
                  ],
                ),
                child: IconButton(
                  onPressed: () {
                    ref
                        .read(sessionControllerProvider.notifier)
                        .togglePlayPause();
                  },
                  icon: Icon(
                    state.isPlaying
                        ? Icons.pause_rounded
                        : Icons.play_arrow_rounded,
                    color: Colors.white,
                    size: 42,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  ref.read(sessionControllerProvider.notifier).stop();
                },
                icon: const Icon(
                  Icons.stop_circle_rounded,
                  color: AppColors.onSurfaceVariant,
                  size: 32,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: state.sessionProgress,
              minHeight: 6,
              backgroundColor: AppColors.surfaceContainerHighest,
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusChips extends StatelessWidget {
  const _StatusChips({required this.state});

  final SessionViewState state;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 14,
      runSpacing: 14,
      children: [
        _StatusChip(
          color: AppColors.tertiaryContainer.withValues(alpha: 0.82),
          foreground: AppColors.onTertiaryContainer,
          label: 'FOCUS PHASE',
          leading: const Icon(
            Icons.circle,
            size: 10,
            color: AppColors.tertiary,
          ),
        ),
        _StatusChip(
          color: AppColors.secondaryContainer.withValues(alpha: 0.82),
          foreground: AppColors.onSecondaryContainer,
          label: '${state.preset.bpm} BPM',
          leading: Text(
            '•',
            style: theme.textTheme.titleLarge?.copyWith(
              color: AppColors.onSecondaryContainer,
            ),
          ),
        ),
      ],
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({
    required this.color,
    required this.foreground,
    required this.label,
    required this.leading,
  });

  final Color color;
  final Color foreground;
  final String label;
  final Widget leading;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          leading,
          const SizedBox(width: 10),
          Text(
            label,
            style: theme.textTheme.labelLarge?.copyWith(color: foreground),
          ),
        ],
      ),
    );
  }
}
