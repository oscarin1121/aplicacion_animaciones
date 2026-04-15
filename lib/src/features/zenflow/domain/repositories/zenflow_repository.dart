import '../entities/zenflow_models.dart';

abstract class ZenflowRepository {
  Future<HomeScreenData> fetchHomeData();
  Future<StatisticsScreenData> fetchStatisticsData();
  Future<SoundsScreenData> fetchSoundsData();
  SessionPreset getSessionPreset();
}
