import 'package:fitness_ui/src/common/app_menu_widget.dart';
import 'package:fitness_ui/src/common/async_value_widget.dart';
import 'package:fitness_ui/src/common/typography.dart';
import 'package:fitness_ui/src/constants/constants.dart';
import 'package:fitness_ui/src/features/routines/application/routine_service.dart';
import 'package:fitness_ui/src/features/routines/data/fake_routines_repository.dart';
import 'package:fitness_ui/src/features/routines/domain/exercise.dart';
import 'package:fitness_ui/src/features/routines/presentation/forms/exercise_add_set_form.dart';
import 'package:fitness_ui/src/features/routines/presentation/forms/routine_add_form.dart';
import 'package:fitness_ui/src/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class RoutineDetailScreen extends StatelessWidget {
  const RoutineDetailScreen({super.key, this.routineTitle});
  final String? routineTitle;

  void _showRoutineMenu(BuildContext context, WidgetRef ref, String routineId) {
    List<MenuItem> menuItems = [
      MenuItem(
        RoutineMenu.add,
        Icons.add_circle_outline,
        () => context.pushNamed(AppRoute.search.name),
      ),
      MenuItem(RoutineMenu.edit, Icons.edit, () {
        showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return RoutineAddForm(isUpdateForm: true);
            });
      }),
      MenuItem(
        RoutineMenu.remove,
        Icons.remove_circle_outline,
        () {
          ref.read(routinesRepositoryProvider).removeRoutine(routineId);
          context.pop();
        },
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

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final routineId =
            ref.watch(routineServiceProvider).getSelectedRoutineId();

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
                  onPressed: () => _showRoutineMenu(context, ref, routineId!),
                  icon: Icon(Icons.more_horiz_rounded),
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
                                    visible:
                                        routine?.exercises.isNotEmpty ?? false,
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
                                                    text: AppRoutine.start)),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                    visible:
                                        routine?.exercises.isEmpty ?? false,
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
                                                    text: AppRoutine.add)),
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

  void _showEditExerciseSets(BuildContext context, Exercise exercise) {
    showModalBottomSheet(
      isDismissible: false,
      showDragHandle: false,
      enableDrag: false,
      context: context,
      builder: (BuildContext context) {
        return ExerciseAddSetForm(
          exercise: exercise,
          isUpdate: true,
        );
      },
    );
  }

  void _showExerciseMenu(
      BuildContext context, WidgetRef ref, Exercise exercise) {
    List<MenuItem> menuItems = [
      MenuItem(
        ExerciseMenu.edit,
        Icons.edit,
        () => _showEditExerciseSets(context, exercise),
      ),
      MenuItem(
        ExerciseMenu.remove,
        Icons.remove_circle_outline,
        () => ref.read(routineServiceProvider).removeExercise(exercise),
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

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
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
                          onPressed: () =>
                              _showExerciseMenu(context, ref, exercise.value!),
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
