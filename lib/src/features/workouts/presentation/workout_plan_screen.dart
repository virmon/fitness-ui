import 'package:fitness_ui/src/common/async_value_widget.dart';
import 'package:fitness_ui/src/features/workouts/data/workout_plans_repository.dart';
import 'package:fitness_ui/src/features/workouts/domain/workout_plan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WorkoutPlanScreen extends StatelessWidget {
  const WorkoutPlanScreen({super.key, required this.workoutPlanId});
  final String? workoutPlanId;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final workoutPlanValue =
            ref.watch(workoutPlanFutureProvider(workoutPlanId!));

        return Scaffold(
            appBar: AppBar(),
            body: ListView(
              children: [
                Column(
                  children: [
                    AsyncValueWidget(
                      value: workoutPlanValue,
                      data: (workoutPlan) => workoutPlan == null
                          ? Text('No data')
                          : Center(
                              child: Column(
                                children: [
                                  Image.asset(
                                    'assets/image${workoutPlan.id}.jpg',
                                    width: 400,
                                    height: 280,
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        workoutPlan.title,
                                        style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      ExerciseItem(items: workoutPlan.exercises)
                                    ],
                                  )
                                ],
                              ),
                            ),
                    )
                  ],
                ),
              ],
            ));
      },
    );
  }
}

class ExerciseItem extends StatelessWidget {
  const ExerciseItem({super.key, required this.items});
  final List<Exercise?> items;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        return Column(
            children: items
                .map((item) => ExpansionTile(
                      title: Text(item?.title ?? ''),
                    ))
                .toList());
      },
    );
  }
}
