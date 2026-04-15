import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/local_zenflow_repository.dart';
import '../../domain/entities/zenflow_models.dart';
import '../../domain/repositories/zenflow_repository.dart';

final zenflowRepositoryProvider = Provider<ZenflowRepository>((ref) {
  return const LocalZenflowRepository();
});

final homeDataProvider = FutureProvider<HomeScreenData>((ref) {
  return ref.watch(zenflowRepositoryProvider).fetchHomeData();
});

final statisticsDataProvider = FutureProvider<StatisticsScreenData>((ref) {
  return ref.watch(zenflowRepositoryProvider).fetchStatisticsData();
});

final soundsDataProvider = FutureProvider<SoundsScreenData>((ref) {
  return ref.watch(zenflowRepositoryProvider).fetchSoundsData();
});

final sessionPresetProvider = Provider<SessionPreset>((ref) {
  return ref.watch(zenflowRepositoryProvider).getSessionPreset();
});

final selectedCategoryIdProvider =
    NotifierProvider<SelectedCategoryController, String?>(
      SelectedCategoryController.new,
    );

final activeSoundIdProvider = NotifierProvider<ActiveSoundController, String>(
  ActiveSoundController.new,
);

class SelectedCategoryController extends Notifier<String?> {
  @override
  String? build() => 'focus';

  void select(String? value) {
    state = value;
  }
}

class ActiveSoundController extends Notifier<String> {
  @override
  String build() => 'rain-forest';

  void select(String value) {
    state = value;
  }
}
