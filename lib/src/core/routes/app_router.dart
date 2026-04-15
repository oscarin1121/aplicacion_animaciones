import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/session/presentation/screens/session_screen.dart';
import '../../features/sounds/presentation/screens/sounds_screen.dart';
import '../../features/statistics/presentation/screens/statistics_screen.dart';
import '../widgets/zen_shell_scaffold.dart';
import 'app_routes.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoute.home.path,
    routes: [
      GoRoute(path: '/', redirect: (_, state) => AppRoute.home.path),
      ShellRoute(
        builder: (context, state, child) {
          return ZenShellScaffold(
            currentRoute: AppRoute.fromLocation(state.uri.path),
            child: child,
          );
        },
        routes: [
          GoRoute(
            path: AppRoute.home.path,
            name: AppRoute.home.name,
            pageBuilder: (context, state) =>
                _buildPage(state: state, child: const HomeScreen()),
          ),
          GoRoute(
            path: AppRoute.statistics.path,
            name: AppRoute.statistics.name,
            pageBuilder: (context, state) =>
                _buildPage(state: state, child: const StatisticsScreen()),
          ),
          GoRoute(
            path: AppRoute.sounds.path,
            name: AppRoute.sounds.name,
            pageBuilder: (context, state) =>
                _buildPage(state: state, child: const SoundsScreen()),
          ),
          GoRoute(
            path: AppRoute.meditate.path,
            name: AppRoute.meditate.name,
            pageBuilder: (context, state) =>
                _buildPage(state: state, child: const SessionScreen()),
          ),
        ],
      ),
    ],
  );
});

Page<void> _buildPage({required GoRouterState state, required Widget child}) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    transitionDuration: const Duration(milliseconds: 480),
    reverseTransitionDuration: const Duration(milliseconds: 360),
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final incomingOpacity = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: animation,
          curve: const Interval(0.32, 1, curve: Cubic(0.2, 0.9, 0.2, 1)),
          reverseCurve: Curves.easeInOutCubic,
        ),
      );
      final outgoingOpacity = Tween<double>(begin: 1, end: 0).animate(
        CurvedAnimation(
          parent: secondaryAnimation,
          curve: const Interval(0, 0.28, curve: Curves.easeOutCubic),
          reverseCurve: Curves.easeInCubic,
        ),
      );
      final incomingOffset =
          Tween<Offset>(
            begin: const Offset(0.045, 0),
            end: Offset.zero,
          ).animate(
            CurvedAnimation(
              parent: animation,
              curve: const Interval(0.32, 1, curve: Cubic(0.2, 0.9, 0.2, 1)),
              reverseCurve: Curves.easeInOutCubic,
            ),
          );
      final outgoingOffset =
          Tween<Offset>(
            begin: Offset.zero,
            end: const Offset(-0.02, 0),
          ).animate(
            CurvedAnimation(
              parent: secondaryAnimation,
              curve: const Interval(0, 0.28, curve: Curves.easeOutCubic),
              reverseCurve: Curves.easeInCubic,
            ),
          );

      return ClipRect(
        child: FadeTransition(
          opacity: outgoingOpacity,
          child: SlideTransition(
            position: outgoingOffset,
            child: FadeTransition(
              opacity: incomingOpacity,
              child: SlideTransition(position: incomingOffset, child: child),
            ),
          ),
        ),
      );
    },
  );
}
