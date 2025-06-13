import 'package:fitness_ui/src/features/workouts/presentation/workouts_list/workouts_list_screen.dart';
import 'package:go_router/go_router.dart';

enum AppRoute { workouts }

final goRouter = GoRouter(
  initialLocation: '/',
  debugLogDiagnostics: false,
  routes: [
    GoRoute(
      path: '/',
      name: AppRoute.workouts.name,
      builder: (context, state) => const WorkoutsListScreen(),
      routes: [],
    ),
  ],
);
