import 'package:fitness_ui/src/features/authentication/auth_gate.dart';
import 'package:fitness_ui/src/features/authentication/firebase_auth_repository.dart';
import 'package:fitness_ui/src/features/authentication/user_profile_screen.dart';
import 'package:fitness_ui/src/features/routines/presentation/routine_detail_screen.dart';
import 'package:fitness_ui/src/features/routines/presentation/routines_list_screen.dart';
import 'package:fitness_ui/src/features/routines/presentation/app_search_screen.dart';
import 'package:fitness_ui/src/routing/go_router_refresh_stream.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fitness_ui/src/features/Home/presentation/app_navigation_bar.dart';
import 'package:fitness_ui/src/features/Home/presentation/dashboard_screen.dart';

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

enum AppRoute {
  signIn,
  home,
  workouts,
  workoutPlan,
  newRoutine,
  profile,
  search,
}

final goRouterProvider = Provider((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return GoRouter(
    initialLocation: '/',
    navigatorKey: _rootNavigatorKey,
    debugLogDiagnostics: false,
    redirect: (context, state) {
      final path = state.uri.path;
      final isLoggedIn = authRepository.currentUser != null;
      if (isLoggedIn) {
        if (path.startsWith('/signIn')) {
          return '/';
        }
      } else {
        if (path.startsWith('/') ||
            path.startsWith('/workouts') ||
            path.startsWith('/profile')) {
          return '/signIn';
        }
      }
      return null;
    },
    refreshListenable: GoRouterRefreshStream(authRepository.authStateChanges()),
    routes: [
      GoRoute(
        path: '/signIn',
        name: AppRoute.signIn.name,
        pageBuilder: (context, state) => const NoTransitionPage(
          child: AuthGate(),
        ),
      ),
      StatefulShellRoute.indexedStack(
        pageBuilder: (context, state, navigationShell) => NoTransitionPage(
            child: AppNavigationBar(navigationShell: navigationShell)),
        branches: [
          StatefulShellBranch(
            navigatorKey: _shellNavigatorHomeKey,
            routes: [
              GoRoute(
                path: '/',
                name: AppRoute.home.name,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: DashboardScreen(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellNavigatorWorkoutsKey,
            routes: [
              GoRoute(
                  path: '/workouts',
                  name: AppRoute.workouts.name,
                  pageBuilder: (context, state) => const NoTransitionPage(
                        child: RoutinesListScreen(),
                      ),
                  routes: [
                    GoRoute(
                      path: '/detail',
                      name: AppRoute.workoutPlan.name,
                      builder: (context, state) {
                        final routineId = state.uri.queryParameters['id'];
                        final routineTitle = state.uri.queryParameters['title'];
                        return RoutineDetailScreen(
                          routineId: routineId,
                          routineTitle: routineTitle,
                        );
                      },
                    ),
                  ]),
              GoRoute(
                path: '/search',
                name: AppRoute.search.name,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: AppSearchScreen(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellNavigatorProfileKey,
            routes: [
              GoRoute(
                path: '/profile',
                name: AppRoute.profile.name,
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: UserProfileScreen()),
              ),
            ],
          ),
        ],
      ),
    ],
    errorPageBuilder: (context, state) => const NoTransitionPage(
      child: Scaffold(
        body: Center(
          child: Text('Page Not Found'),
        ),
      ),
    ),
  );
});
