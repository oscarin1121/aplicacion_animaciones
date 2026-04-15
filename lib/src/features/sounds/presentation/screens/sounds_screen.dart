import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/animated_reveal.dart';
import '../../../zenflow/domain/entities/zenflow_models.dart';
import '../../../zenflow/presentation/providers/zenflow_providers.dart';
import '../../../zenflow/presentation/zenflow_visuals.dart';

class SoundsScreen extends ConsumerWidget {
  const SoundsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final soundsData = ref.watch(soundsDataProvider);

    return soundsData.when(
      data: (data) => _SoundsBody(data: data),
      loading: () => const Center(child: CircularProgressIndicator.adaptive()),
      error: (error, stackTrace) => const Center(
        child: Text('No pudimos abrir el explorador de sonidos.'),
      ),
    );
  }
}

class _SoundsBody extends ConsumerWidget {
  const _SoundsBody({required this.data});

  final SoundsScreenData data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final activeSoundId = ref.watch(activeSoundIdProvider);

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
                const SizedBox(height: 8),
                Text(
                  data.subtitle.toUpperCase(),
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          for (var index = 0; index < data.sounds.length; index++) ...[
            AnimatedReveal(
              delay: Duration(milliseconds: 100 * (index + 1)),
              child: _SoundCard(
                sound: data.sounds[index],
                isActive: activeSoundId == data.sounds[index].id,
                onTap: () {
                  ref
                      .read(activeSoundIdProvider.notifier)
                      .select(data.sounds[index].id);
                },
              ),
            ),
            if (index != data.sounds.length - 1)
              const SizedBox(height: AppSpacing.lg),
          ],
          const SizedBox(height: AppSpacing.xl),
          AnimatedReveal(
            delay: const Duration(milliseconds: 420),
            child: _FeatureCards(cards: data.featureCards),
          ),
        ],
      ),
    );
  }
}

class _SoundCard extends StatelessWidget {
  const _SoundCard({
    required this.sound,
    required this.isActive,
    required this.onTap,
  });

  final Soundscape sound;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedScale(
      duration: const Duration(milliseconds: 320),
      scale: isActive ? 1 : 0.985,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 320),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(36),
          boxShadow: [
            BoxShadow(
              color: isActive
                  ? sound.accent.baseColor.withValues(alpha: 0.20)
                  : AppColors.shadow,
              blurRadius: isActive ? 44 : 32,
              spreadRadius: -10,
              offset: const Offset(0, 20),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(36),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(36),
              child: SizedBox(
                height: 148,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(sound.imageAsset, fit: BoxFit.cover),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withValues(alpha: 0.02),
                            Colors.black.withValues(alpha: 0.58),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(22),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  sound.title,
                                  style: theme.textTheme.headlineMedium
                                      ?.copyWith(
                                        color: Colors.white,
                                        fontSize: 34,
                                      ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  sound.subtitle.toUpperCase(),
                                  style: theme.textTheme.labelMedium?.copyWith(
                                    color: Colors.white.withValues(alpha: 0.78),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 320),
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isActive
                                  ? sound.accent.baseColor.withValues(
                                      alpha: 0.78,
                                    )
                                  : Colors.white.withValues(alpha: 0.72),
                            ),
                            child: Icon(
                              isActive
                                  ? Icons.pause_rounded
                                  : Icons.play_arrow_rounded,
                              color: isActive
                                  ? Colors.white
                                  : AppColors.onSurface,
                              size: 28,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FeatureCards extends StatelessWidget {
  const _FeatureCards({required this.cards});

  final List<FeatureCard> cards;

  @override
  Widget build(BuildContext context) {
    final crossAxisCount = MediaQuery.sizeOf(context).width > 620 ? 2 : 1;

    return GridView.builder(
      itemCount: cards.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
        childAspectRatio: crossAxisCount == 2 ? 0.92 : 1.4,
      ),
      itemBuilder: (context, index) {
        final card = cards[index];
        final theme = Theme.of(context);

        return Container(
          decoration: BoxDecoration(
            gradient: card.accent.softGradient,
            borderRadius: BorderRadius.circular(38),
            boxShadow: [
              BoxShadow(
                color: card.accent.baseColor.withValues(alpha: 0.12),
                blurRadius: 38,
                spreadRadius: -12,
                offset: const Offset(0, 20),
              ),
            ],
          ),
          padding: const EdgeInsets.all(26),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                card.icon.iconData,
                size: 32,
                color: card.accent.foregroundColor,
              ),
              const Spacer(),
              Text(
                card.title,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontSize: 36,
                  color: card.accent.foregroundColor,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                card.description,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: card.accent.foregroundColor.withValues(alpha: 0.74),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
