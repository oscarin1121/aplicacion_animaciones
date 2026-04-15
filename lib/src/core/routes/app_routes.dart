enum AppRoute {
  home('/home', 'Home'),
  statistics('/statistics', 'Statistics'),
  sounds('/sounds', 'Sounds'),
  meditate('/meditate', 'Meditate');

  const AppRoute(this.path, this.label);

  final String path;
  final String label;

  static AppRoute fromLocation(String location) {
    for (final route in values) {
      if (location == route.path || location.startsWith('${route.path}/')) {
        return route;
      }
    }

    return home;
  }
}
