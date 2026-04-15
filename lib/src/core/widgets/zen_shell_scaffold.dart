import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../routes/app_routes.dart';
import '../theme/app_colors.dart';
import 'ambient_background.dart';
import 'frosted_glass_card.dart';

class ZenShellScaffold extends StatelessWidget {
  const ZenShellScaffold({
    super.key,
    required this.child,
    required this.currentRoute,
  });

  final Widget child;
  final AppRoute currentRoute;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AmbientBackground(
        child: SafeArea(
          child: Column(
            children: [
              const _ZenTopBar(),
              Expanded(child: child),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 18),
                child: FrostedGlassCard(
                  borderRadius: 38,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                  child: Row(
                    children: [
                      for (final route in AppRoute.values)
                        Expanded(
                          child: _NavItem(
                            route: route,
                            isActive: route == currentRoute,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ZenTopBar extends StatelessWidget {
  const _ZenTopBar();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 4),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [AppColors.primary, Color(0xFF27465F)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.16),
                  blurRadius: 24,
                  spreadRadius: -4,
                  offset: const Offset(0, 14),
                ),
              ],
            ),
            child: const Icon(
              Icons.person_rounded,
              color: AppColors.surfaceLowest,
            ),
          ),
          const SizedBox(width: 14),
          Text(
            'ZenFlow',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontSize: 30,
              fontStyle: FontStyle.italic,
              color: AppColors.primary,
            ),
          ),
          const Spacer(),
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.45),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.settings_rounded),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({required this.route, required this.isActive});

  final AppRoute route;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 320),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: isActive
            ? AppColors.primaryContainer.withValues(alpha: 0.42)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(999),
      ),
      child: InkWell(
        onTap: () {
          if (!isActive) {
            context.go(route.path);
          }
        },
        borderRadius: BorderRadius.circular(999),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _iconForRoute(route),
                size: 24,
                color: isActive
                    ? AppColors.primary
                    : AppColors.onSurface.withValues(alpha: 0.38),
              ),
              const SizedBox(height: 6),
              Text(
                route.label.toUpperCase(),
                style: theme.textTheme.labelMedium?.copyWith(
                  color: isActive
                      ? AppColors.primary
                      : AppColors.onSurface.withValues(alpha: 0.38),
                  fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _iconForRoute(AppRoute route) {
    switch (route) {
      case AppRoute.home:
        return Icons.home_rounded;
      case AppRoute.statistics:
        return Icons.insights_rounded;
      case AppRoute.sounds:
        return Icons.graphic_eq_rounded;
      case AppRoute.meditate:
        return Icons.self_improvement_rounded;
    }
  }
}
