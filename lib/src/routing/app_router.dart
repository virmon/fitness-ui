import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:fitness_ui/src/features/Home/presentation/app_navigation_bar.dart';
import 'package:fitness_ui/src/features/Home/presentation/dashboard_screen.dart';
import 'package:fitness_ui/src/features/workouts/presentation/workouts_list/workouts_list_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorHomeKey = GlobalKey<NavigatorState>(
  debugLabel: 'shellHome',
);
final _shellNavigatorWorkoutsKey = GlobalKey<NavigatorState>(
  debugLabel: 'shellWorkouts',
);
final _shellNavigatorProfileKey = GlobalKey<NavigatorState>(
  debugLabel: 'shellProfile',
);

class AppRoute {
  static const String home = '/';
  static const String workouts = '/workouts';
  static const String profile = '/profile';
}

final goRouter = GoRouter(
  initialLocation: AppRoute.home,
  navigatorKey: _rootNavigatorKey,
  debugLogDiagnostics: false,
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return AppNavigationBar(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          navigatorKey: _shellNavigatorHomeKey,
          routes: [
            GoRoute(
              path: AppRoute.home,
              builder: (context, state) => const DashboardScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _shellNavigatorWorkoutsKey,
          routes: [
            GoRoute(
              path: AppRoute.workouts,
              builder: (context, state) => const WorkoutsListScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _shellNavigatorProfileKey,
          routes: [
            GoRoute(
              path: AppRoute.profile,
              builder: (context, state) => const Placeholder(),
            ),
          ],
        ),
      ],
    ),
  ],
);
