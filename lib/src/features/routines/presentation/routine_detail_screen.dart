import 'package:fitness_ui/src/common/async_value_widget.dart';
import 'package:fitness_ui/src/common/typography.dart';
import 'package:fitness_ui/src/features/routines/application/routine_service.dart';
import 'package:fitness_ui/src/features/routines/data/fake_routines_repository.dart';
import 'package:fitness_ui/src/features/routines/domain/exercise.dart';
import 'package:fitness_ui/src/features/routines/presentation/forms/exercise_add_set_form.dart';
import 'package:fitness_ui/src/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class RoutineDetailScreen extends StatelessWidget {
  const RoutineDetailScreen({super.key, this.routineTitle});
  final String? routineTitle;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final routineId =
            ref.watch(routineServiceProvider).getSelectedRoutine();

        AsyncValue routineValue = AsyncData([]);
        if (routineId == null) {
          context.goNamed(AppRoute.workouts.name);
        } else {
          routineValue = ref.watch(routineProvider(routineId));
        }

        return Scaffold(
            appBar: AppBar(
              actions: [
                IconButton(
                  onPressed: () {
                    context.pushNamed(AppRoute.search.name);
                  },
                  icon: Icon(Icons.add),
                ),
              ],
            ),
            body: ListView(
              children: [
                Column(
                  children: [
                    AsyncValueWidget(
                        value: routineValue,
                        data: (routine) {
                          return Column(
                            children: [
                              Image.asset(
                                'assets/image_placeholder.jpg',
                                width: 400,
                                height: 280,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                      padding:
                                          const EdgeInsets.only(left: 20.0),
                                      child: TitleHeader(
                                        text: routineTitle ??
                                            routine?.title ??
                                            '',
                                      )),
                                  Padding(
                                      padding:
                                          const EdgeInsets.only(left: 20.0),
                                      child: Text(
                                          '${routine?.exercises.length ?? '0'} workouts')),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          width: 450,
                                          height: 60,
                                          child: ElevatedButton(
                                              onPressed: () {
                                                // todo: implement start workout session
                                              },
                                              child: const TextHeader(
                                                  text: 'Start Workout')),
                                        ),
                                      ],
                                    ),
                                  ),
                                  ExerciseItem(
                                      exercises: routine?.exercises ?? [])
                                ],
                              )
                            ],
                          );
                        })
                  ],
                ),
              ],
            ));
      },
    );
  }
}

class ExerciseItem extends StatelessWidget {
  const ExerciseItem({super.key, required this.exercises});
  final List<Exercise?> exercises;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        return Column(
            children: exercises.isEmpty
                ? [Text('No exercise data')]
                : exercises
                    .asMap()
                    .entries
                    .map(
                      (exercise) => ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            TextHeader(text: exercise.value?.title ?? ''),
                          ],
                        ),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                                '${exercise.value?.exerciseSets?.length ?? 0} sets'),
                          ],
                        ),
                        trailing: InkWell(
                          child: Icon(Icons.more_horiz_outlined),
                          onTap: () => showModalBottomSheet(
                            showDragHandle: true,
                            context: context,
                            builder: (BuildContext context) {
                              return ExerciseAddSetForm(
                                exercise: exercise.value!,
                                isUpdate: true,
                              );
                            },
                          ),
                        ),
                      ),
                    )
                    .toList());
      },
    );
  }
}
