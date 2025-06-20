import 'package:fitness_ui/src/common/async_value_widget.dart';
import 'package:fitness_ui/src/features/workouts/data/workout_plans_repository.dart';
import 'package:fitness_ui/src/features/workouts/domain/workout_plan.dart';
import 'package:fitness_ui/src/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class WorkoutPlansList extends ConsumerWidget {
  const WorkoutPlansList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workoutPlans = ref.watch(workoutPlanListFutureProvider);
    final listTitle = 'My Workout Plans';

    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Column(
            children: [
              ListSection(
                title: listTitle,
                content: workoutPlans,
              ),
            ],
          ),
        )
      ],
    );
  }
}

class ListSection extends StatelessWidget {
  const ListSection({super.key, required this.title, required this.content});
  final String title;
  final AsyncValue content;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 22),
              ),
              AsyncValueWidget(
                value: content,
                data: (data) => ListSectionItem(items: data),
              ),
            ],
          ),
        )
      ],
    );
  }
}

class ListSectionItem extends StatelessWidget {
  const ListSectionItem({super.key, required this.items});
  final List<WorkoutPlan?> items;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        return Column(
            children: items
                .map((item) => Column(
                      children: [
                        ListTile(
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
                            subtitle: Text(
                                '${item.exercises.length.toString()} workouts'),
                            onTap: () {
                              ref
                                  .read(workoutPlansRepositoryProvider)
                                  .getWorkoutPlanById(workoutPlanId: item.id);
                              context.goNamed(
                                AppRoute.workoutPlan.name,
                                pathParameters: {'id': item.id},
                              );
                            }),
                      ],
                    ))
                .toList());
      },
    );
  }
}
