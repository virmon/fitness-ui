import 'package:fitness_ui/src/common/app_menu_widget.dart';
import 'package:fitness_ui/src/common/typography.dart';
import 'package:fitness_ui/src/constants/constants.dart';
import 'package:fitness_ui/src/features/routines/domain/exercise.dart';
import 'package:fitness_ui/src/features/routines/presentation/forms/exercise_add_set_form.dart';
import 'package:fitness_ui/src/features/routines/presentation/routines_list/routines_controller.dart';
import 'package:fitness_ui/src/utils/routines_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
        () => ref
            .read(routinesControllerProvider.notifier)
            .removeExercise(exercise),
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
                            TextHeader(exercise.value?.title ?? ''),
                          ],
                        ),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text('set'.formatNounCount(
                                exercise.value?.sets?.length ?? 0)),
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
