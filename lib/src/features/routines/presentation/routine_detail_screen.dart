import 'package:fitness_ui/src/common/app_menu_widget.dart';
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
                                  Visibility(
                                    visible: routine.exercises.isNotEmpty,
                                    child: Padding(
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
                                  ),
                                  Visibility(
                                    visible: routine.exercises.isEmpty,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            width: 450,
                                            height: 60,
                                            child: ElevatedButton(
                                                onPressed: () =>
                                                    context.pushNamed(
                                                        AppRoute.search.name),
                                                child: const TextHeader(
                                                    text:
                                                        'Add to this routine')),
                                          ),
                                        ],
                                      ),
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

  void _showEditExerciseSets(BuildContext context, exercise) {
    context.pop();
    showModalBottomSheet(
      isDismissible: false,
      showDragHandle: false,
      enableDrag: false,
      context: context,
      builder: (BuildContext context) {
        return ExerciseAddSetForm(
          exercise: exercise.value!,
          isUpdate: true,
        );
      },
    );
  }

  void _showExerciseMenu(BuildContext context, exercise, removeExercise) {
    List<MenuItem> menuItems = [
      MenuItem(
        'Edit Exercise Sets',
        Icons.edit,
        () => _showEditExerciseSets(context, exercise),
      ),
      MenuItem(
        'Remove Exercise',
        Icons.delete,
        () => _removeExercise(context, exercise, removeExercise),
      ),
    ];

    showModalBottomSheet(
      showDragHandle: true,
      context: context,
      builder: (BuildContext context) {
        return AppMenuWidget(menuItems: menuItems);
      },
    );
  }

  void _removeExercise(BuildContext context, exercise, removeExercise) {
    context.pop();
    removeExercise(exercise.value);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final removeExercise = ref.read(routineServiceProvider).removeExercise;
        return Visibility(
          visible: exercises.isNotEmpty,
          child: Column(
              children: exercises
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
                        trailing: IconButton(
                          onPressed: () => _showExerciseMenu(
                              context, exercise, removeExercise),
                          icon: Icon(Icons.more_horiz_outlined),
                        ),
                        onTap: () => {}),
                  )
                  .toList()),
        );
      },
    );
  }
}
