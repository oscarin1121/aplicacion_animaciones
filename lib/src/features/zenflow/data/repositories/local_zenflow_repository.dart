import '../../../../core/constants/app_assets.dart';
import '../../domain/entities/zenflow_models.dart';
import '../../domain/repositories/zenflow_repository.dart';

class LocalZenflowRepository implements ZenflowRepository {
  const LocalZenflowRepository();

  @override
  Future<HomeScreenData> fetchHomeData() async {
    await Future<void>.delayed(const Duration(milliseconds: 220));

    return const HomeScreenData(
      heroTitle: 'Breathe in clarity.',
      heroSubtitle:
          'Focus on the center. Let your rhythm align with the sanctuary.',
      ritual: DailyRitual(
        title: 'The Morning Stillness Session',
        description:
            'A 10-minute guided transition from sleep to awareness using soft-bell anchors.',
        callToAction: 'Begin Journey',
        imageAsset: AppAssets.morningRitual,
      ),
      categories: [
        FocusCategory(
          id: 'focus',
          title: 'Focus',
          sessions: 12,
          icon: ZenIconToken.focus,
          accent: ZenAccent.primary,
        ),
        FocusCategory(
          id: 'sleep',
          title: 'Sleep',
          sessions: 24,
          icon: ZenIconToken.sleep,
          accent: ZenAccent.secondary,
        ),
        FocusCategory(
          id: 'anxiety',
          title: 'Anxiety',
          sessions: 18,
          icon: ZenIconToken.anxiety,
          accent: ZenAccent.tertiary,
        ),
        FocusCategory(
          id: 'growth',
          title: 'Growth',
          sessions: 9,
          icon: ZenIconToken.growth,
          accent: ZenAccent.primary,
        ),
      ],
      weeklyBars: [
        WeeklyBar(label: 'MON', value: 0.26, accent: ZenAccent.tertiary),
        WeeklyBar(label: 'TUE', value: 0.38, accent: ZenAccent.tertiary),
        WeeklyBar(label: 'WED', value: 0.22, accent: ZenAccent.secondary),
        WeeklyBar(label: 'THU', value: 0.54, accent: ZenAccent.primary),
        WeeklyBar(label: 'FRI', value: 0.33, accent: ZenAccent.tertiary),
        WeeklyBar(
          label: 'SAT',
          value: 0.68,
          accent: ZenAccent.tertiary,
          highlighted: true,
        ),
        WeeklyBar(label: 'SUN', value: 0.14, accent: ZenAccent.tertiary),
      ],
      summary: MetricSummary(
        title: 'Zen Minutes',
        value: '840',
        suffix: 'min',
        icon: ZenIconToken.timer,
        accent: ZenAccent.secondary,
        progress: 0.72,
      ),
    );
  }

  @override
  Future<StatisticsScreenData> fetchStatisticsData() async {
    await Future<void>.delayed(const Duration(milliseconds: 260));

    return const StatisticsScreenData(
      title: 'Weekly Mindfulness',
      subtitle: 'You\'ve reached 85% of your tranquility goal this week.',
      weeklyBars: [
        WeeklyBar(label: 'MON', value: 0.40, accent: ZenAccent.primary),
        WeeklyBar(label: 'TUE', value: 0.65, accent: ZenAccent.primary),
        WeeklyBar(label: 'WED', value: 0.55, accent: ZenAccent.primary),
        WeeklyBar(
          label: 'THU',
          value: 0.90,
          accent: ZenAccent.primary,
          highlighted: true,
        ),
        WeeklyBar(label: 'FRI', value: 0.75, accent: ZenAccent.primary),
        WeeklyBar(label: 'SAT', value: 0.30, accent: ZenAccent.tertiary),
        WeeklyBar(label: 'SUN', value: 0.20, accent: ZenAccent.tertiary),
      ],
      minutesMetric: MetricSummary(
        title: 'Minutes Meditated',
        value: '1,240',
        suffix: 'min',
        icon: ZenIconToken.timer,
        accent: ZenAccent.primary,
        progress: 0.85,
      ),
      streakMetric: MetricSummary(
        title: 'Days Streak',
        value: '12',
        suffix: '',
        icon: ZenIconToken.streak,
        accent: ZenAccent.tertiary,
        progress: 0.74,
      ),
      completedMetric: MetricSummary(
        title: 'Sessions Completed',
        value: '48',
        suffix: '',
        icon: ZenIconToken.completed,
        accent: ZenAccent.secondary,
        progress: 1,
      ),
      community: CommunityHighlight(
        friendsJoined: 16,
        description: 'Join 16 friends in today\'s group meditation.',
      ),
      patterns: [
        DailyPattern(
          title: 'Morning Focus',
          description: 'Peak concentration at 8:30 AM',
          status: 'Excellent',
          caption: 'Consistency',
          accent: ZenAccent.tertiary,
          icon: ZenIconToken.sunrise,
        ),
        DailyPattern(
          title: 'Sleep Quality',
          description: 'Avg. deep sleep 4h 20m',
          status: 'Improving',
          caption: 'Last 7 days',
          accent: ZenAccent.secondary,
          icon: ZenIconToken.moon,
        ),
      ],
      quote:
          '“The soul always knows what to do to heal itself. The challenge is to silence the mind.”',
    );
  }

  @override
  Future<SoundsScreenData> fetchSoundsData() async {
    await Future<void>.delayed(const Duration(milliseconds: 240));

    return const SoundsScreenData(
      title: 'Sound Explorer',
      subtitle: 'Curated environments for your focus',
      sounds: [
        Soundscape(
          id: 'rain-forest',
          title: 'Rain Forest',
          subtitle: '324 active listeners',
          badge: 'Featured',
          imageAsset: AppAssets.rainForest,
          accent: ZenAccent.primary,
          highlighted: true,
        ),
        Soundscape(
          id: 'white-noise',
          title: 'White Noise',
          subtitle: 'Deep Sleep Engine',
          badge: 'Sleep',
          imageAsset: AppAssets.whiteNoise,
          accent: ZenAccent.neutral,
        ),
        Soundscape(
          id: 'ocean-waves',
          title: 'Ocean Waves',
          subtitle: 'Coastal Rhythms',
          badge: 'Restore',
          imageAsset: AppAssets.oceanWaves,
          accent: ZenAccent.tertiary,
        ),
        Soundscape(
          id: 'mountain-wind',
          title: 'Mountain Wind',
          subtitle: 'High Altitude Calm',
          badge: 'Deep Calm',
          imageAsset: AppAssets.mountainWind,
          accent: ZenAccent.secondary,
        ),
      ],
      featureCards: [
        FeatureCard(
          title: 'Smart Mix',
          description:
              'Let AI blend sounds based on your current heart rate and environment.',
          icon: ZenIconToken.sparkles,
          accent: ZenAccent.secondary,
        ),
        FeatureCard(
          title: 'Sleep Timer',
          description: 'Gently fade out audio over 20, 40, or 60 minutes.',
          icon: ZenIconToken.sleepTimer,
          accent: ZenAccent.tertiary,
        ),
      ],
    );
  }

  @override
  SessionPreset getSessionPreset() {
    return const SessionPreset(
      title: 'Evening Serenity',
      subtitle: 'Deep Ocean Breath',
      totalDuration: Duration(minutes: 15),
      bpm: 98,
    );
  }
}
