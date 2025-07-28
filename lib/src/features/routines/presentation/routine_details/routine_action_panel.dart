import 'package:fitness_ui/src/common/typography.dart';
import 'package:fitness_ui/src/constants/constants.dart';
import 'package:fitness_ui/src/features/routines/domain/routine.dart';
import 'package:fitness_ui/src/features/routines/presentation/routines_list/routines_controller.dart';
import 'package:fitness_ui/src/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class RoutineActionPanel extends StatelessWidget {
  final bool isPublicRoutine;
  final Routine routine;

  const RoutineActionPanel({
    super.key,
    required this.isPublicRoutine,
    required this.routine,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        return Column(
          children: [
            Visibility(
                visible: isPublicRoutine,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                        padding: const EdgeInsets.only(
                          left: 10.0,
                          right: 10.0,
                        ),
                        child: ElevatedButton(
                          onPressed: () async {
                            final routineCopy = Routine(
                              title: 'Copy of ${routine.title}',
                              notes: routine.notes,
                              exercises: routine.exercises,
                            );
                            final isComplete = await ref
                                .read(routinesControllerProvider.notifier)
                                .addRoutine(routineCopy);
                            if (context.mounted && isComplete) {
                              context.pop();
                              context.goNamed(AppRoute.routineDetail.name);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(),
                            minimumSize: const Size(40, 40),
                          ),
                          child: Icon(Icons.copy),
                        )),
                  ],
                )),
            Visibility(
                visible: !isPublicRoutine,
                child: Column(
                  children: [
                    Visibility(
                      visible: routine.exercises.isNotEmpty,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 60,
                              child: ElevatedButton(
                                onPressed: () {
                                  // todo: implement start workout session
                                },
                                style: ElevatedButton.styleFrom(
                                  minimumSize: Size(double.infinity, 50),
                                ),
                                child: const TextHeader(AppRoutine.start),
                              ),
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
                              height: 60,
                              child: ElevatedButton(
                                onPressed: () {
                                  context.pushNamed(AppRoute.search.name);
                                },
                                style: ElevatedButton.styleFrom(
                                  minimumSize: Size(double.infinity, 50),
                                ),
                                child: const TextHeader(AppRoutine.add),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )),
          ],
        );
      },
    );
  }
}
