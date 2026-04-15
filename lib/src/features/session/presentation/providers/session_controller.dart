import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../zenflow/domain/entities/zenflow_models.dart';
import '../../../zenflow/presentation/providers/zenflow_providers.dart';

final sessionControllerProvider =
    NotifierProvider<SessionController, SessionViewState>(
      SessionController.new,
    );

class SessionController extends Notifier<SessionViewState> {
  Timer? _timer;

  @override
  SessionViewState build() {
    ref.onDispose(() {
      _timer?.cancel();
    });

    final preset = ref.watch(sessionPresetProvider);
    final initialState = SessionViewState.initial(preset);

    Future<void>.microtask(_ensureTicker);
    return initialState;
  }

  void togglePlayPause() {
    final nextIsPlaying = !state.isPlaying;
    state = state.copyWith(isPlaying: nextIsPlaying);

    if (nextIsPlaying) {
      _ensureTicker();
    } else {
      _timer?.cancel();
    }
  }

  void toggleSound() {
    state = state.copyWith(isSoundEnabled: !state.isSoundEnabled);
  }

  void stop() {
    _timer?.cancel();
    state = SessionViewState.initial(
      state.preset,
    ).copyWith(isSoundEnabled: state.isSoundEnabled, isPlaying: false);
  }

  void _ensureTicker() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final current = state;

      if (!current.isPlaying) {
        return;
      }

      if (current.remaining <= const Duration(seconds: 1)) {
        _timer?.cancel();
        state = SessionViewState.initial(current.preset).copyWith(
          remaining: Duration.zero,
          isPlaying: false,
          isSoundEnabled: current.isSoundEnabled,
          sessionProgress: 1,
          phase: SessionPhase.exhale,
          breathProgress: 0,
        );
        return;
      }

      final remaining = current.remaining - const Duration(seconds: 1);
      state = SessionViewState.fromRemaining(
        preset: current.preset,
        remaining: remaining,
        isPlaying: true,
        isSoundEnabled: current.isSoundEnabled,
      );
    });
  }
}

class SessionViewState {
  const SessionViewState({
    required this.preset,
    required this.remaining,
    required this.isPlaying,
    required this.isSoundEnabled,
    required this.phase,
    required this.breathProgress,
    required this.sessionProgress,
  });

  factory SessionViewState.initial(SessionPreset preset) {
    return SessionViewState.fromRemaining(
      preset: preset,
      remaining: preset.totalDuration,
      isPlaying: true,
      isSoundEnabled: true,
    );
  }

  factory SessionViewState.fromRemaining({
    required SessionPreset preset,
    required Duration remaining,
    required bool isPlaying,
    required bool isSoundEnabled,
  }) {
    final elapsed = preset.totalDuration - remaining;
    final cycleSecond = elapsed.inSeconds % 10;
    final totalSeconds = preset.totalDuration.inSeconds;

    SessionPhase phase;
    double breathProgress;

    if (cycleSecond < 4) {
      phase = SessionPhase.inhale;
      breathProgress = cycleSecond / 4;
    } else if (cycleSecond < 6) {
      phase = SessionPhase.hold;
      breathProgress = 1;
    } else {
      phase = SessionPhase.exhale;
      breathProgress = 1 - ((cycleSecond - 6) / 4);
    }

    return SessionViewState(
      preset: preset,
      remaining: remaining,
      isPlaying: isPlaying,
      isSoundEnabled: isSoundEnabled,
      phase: phase,
      breathProgress: breathProgress.clamp(0.0, 1.0),
      sessionProgress: elapsed.inSeconds == 0
          ? 0.0
          : elapsed.inSeconds / totalSeconds,
    );
  }

  final SessionPreset preset;
  final Duration remaining;
  final bool isPlaying;
  final bool isSoundEnabled;
  final SessionPhase phase;
  final double breathProgress;
  final double sessionProgress;

  String get remainingLabel {
    final minutes = remaining.inMinutes
        .remainder(60)
        .toString()
        .padLeft(2, '0');
    final seconds = remaining.inSeconds
        .remainder(60)
        .toString()
        .padLeft(2, '0');
    return '$minutes:$seconds';
  }

  String get phaseLabel {
    switch (phase) {
      case SessionPhase.inhale:
        return 'Inhale';
      case SessionPhase.hold:
        return 'Hold';
      case SessionPhase.exhale:
        return 'Exhale';
    }
  }

  SessionViewState copyWith({
    Duration? remaining,
    bool? isPlaying,
    bool? isSoundEnabled,
    SessionPhase? phase,
    double? breathProgress,
    double? sessionProgress,
  }) {
    return SessionViewState(
      preset: preset,
      remaining: remaining ?? this.remaining,
      isPlaying: isPlaying ?? this.isPlaying,
      isSoundEnabled: isSoundEnabled ?? this.isSoundEnabled,
      phase: phase ?? this.phase,
      breathProgress: breathProgress ?? this.breathProgress,
      sessionProgress: sessionProgress ?? this.sessionProgress,
    );
  }
}
