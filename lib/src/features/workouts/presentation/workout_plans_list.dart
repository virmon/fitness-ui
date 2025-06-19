import 'package:fitness_ui/src/features/authentication/auth_provider.dart';
import 'package:fitness_ui/src/features/authentication/firebase_auth_repository.dart';
import 'package:fitness_ui/src/features/workouts/data/workout_plans_repository.dart';
import 'package:fitness_ui/src/features/workouts/domain/workout_plan.dart';
import 'package:fitness_ui/src/features/workouts/presentation/workouts_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WorkoutPlansList extends ConsumerWidget {
  const WorkoutPlansList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workoutPlans = ref.watch(workoutPlanListFutureProvider);

    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Column(
            children: [
              CategorySection(
                title: 'My Workout Plans',
              ),
              workoutPlans.when(
                  data: (workoutPlans) =>
                      ListTileWorkoutPlan(items: workoutPlans),
                  error: (e, st) => Text(e.toString()),
                  loading: () => Center(
                        child: CircularProgressIndicator(),
                      ))
            ],
          ),
        )
      ],
    );
  }
}

class ListTileWorkoutPlan extends StatelessWidget {
  const ListTileWorkoutPlan({super.key, required this.items});
  final List<WorkoutPlan?> items;

  @override
  Widget build(BuildContext context) {
    return Column(
        children: items
            .map((item) => Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: ListTile(
                    tileColor: Colors.transparent,
                    leading: ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: 64,
                        minHeight: 44,
                        maxWidth: 84,
                        maxHeight: 64,
                      ),
                      child: Image.asset(
                        'assets/image${item!.id}.jpg',
                        width: 100,
                        height: 20,
                      ),
                    ),
                    title: Text(item.title),
                    subtitle:
                        Text('${item.exercises.length.toString()} workouts'),
                    onTap: () => print('clicked ${item.id}'),
                  ),
                ))
            .toList());
  }
}
