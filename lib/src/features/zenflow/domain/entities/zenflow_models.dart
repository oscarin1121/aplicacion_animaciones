enum ZenAccent { primary, secondary, tertiary, neutral }

enum ZenIconToken {
  focus,
  sleep,
  anxiety,
  growth,
  timer,
  streak,
  completed,
  sunrise,
  moon,
  sparkles,
  sleepTimer,
  soundWave,
}

enum SessionPhase { inhale, hold, exhale }

class HomeScreenData {
  const HomeScreenData({
    required this.heroTitle,
    required this.heroSubtitle,
    required this.ritual,
    required this.categories,
    required this.weeklyBars,
    required this.summary,
  });

  final String heroTitle;
  final String heroSubtitle;
  final DailyRitual ritual;
  final List<FocusCategory> categories;
  final List<WeeklyBar> weeklyBars;
  final MetricSummary summary;
}

class DailyRitual {
  const DailyRitual({
    required this.title,
    required this.description,
    required this.callToAction,
    required this.imageAsset,
  });

  final String title;
  final String description;
  final String callToAction;
  final String imageAsset;
}

class FocusCategory {
  const FocusCategory({
    required this.id,
    required this.title,
    required this.sessions,
    required this.icon,
    required this.accent,
  });

  final String id;
  final String title;
  final int sessions;
  final ZenIconToken icon;
  final ZenAccent accent;
}

class WeeklyBar {
  const WeeklyBar({
    required this.label,
    required this.value,
    required this.accent,
    this.highlighted = false,
  });

  final String label;
  final double value;
  final ZenAccent accent;
  final bool highlighted;
}

class MetricSummary {
  const MetricSummary({
    required this.title,
    required this.value,
    required this.suffix,
    required this.icon,
    required this.accent,
    required this.progress,
  });

  final String title;
  final String value;
  final String suffix;
  final ZenIconToken icon;
  final ZenAccent accent;
  final double progress;
}

class StatisticsScreenData {
  const StatisticsScreenData({
    required this.title,
    required this.subtitle,
    required this.weeklyBars,
    required this.minutesMetric,
    required this.streakMetric,
    required this.completedMetric,
    required this.community,
    required this.patterns,
    required this.quote,
  });

  final String title;
  final String subtitle;
  final List<WeeklyBar> weeklyBars;
  final MetricSummary minutesMetric;
  final MetricSummary streakMetric;
  final MetricSummary completedMetric;
  final CommunityHighlight community;
  final List<DailyPattern> patterns;
  final String quote;
}

class CommunityHighlight {
  const CommunityHighlight({
    required this.friendsJoined,
    required this.description,
  });

  final int friendsJoined;
  final String description;
}

class DailyPattern {
  const DailyPattern({
    required this.title,
    required this.description,
    required this.status,
    required this.caption,
    required this.accent,
    required this.icon,
  });

  final String title;
  final String description;
  final String status;
  final String caption;
  final ZenAccent accent;
  final ZenIconToken icon;
}

class SoundsScreenData {
  const SoundsScreenData({
    required this.title,
    required this.subtitle,
    required this.sounds,
    required this.featureCards,
  });

  final String title;
  final String subtitle;
  final List<Soundscape> sounds;
  final List<FeatureCard> featureCards;
}

class Soundscape {
  const Soundscape({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.badge,
    required this.imageAsset,
    required this.accent,
    this.highlighted = false,
  });

  final String id;
  final String title;
  final String subtitle;
  final String badge;
  final String imageAsset;
  final ZenAccent accent;
  final bool highlighted;
}

class FeatureCard {
  const FeatureCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.accent,
  });

  final String title;
  final String description;
  final ZenIconToken icon;
  final ZenAccent accent;
}

class SessionPreset {
  const SessionPreset({
    required this.title,
    required this.subtitle,
    required this.totalDuration,
    required this.bpm,
  });

  final String title;
  final String subtitle;
  final Duration totalDuration;
  final int bpm;
}
