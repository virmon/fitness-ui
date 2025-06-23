import 'package:fitness_ui/src/common/async_value_widget.dart';
import 'package:fitness_ui/src/common/typography.dart';
import 'package:fitness_ui/src/features/routines/data/routines_repository.dart';
import 'package:fitness_ui/src/features/routines/domain/exercise.dart';
import 'package:fitness_ui/src/features/routines/domain/exercise_set.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RoutineDetailScreen extends StatelessWidget {
  const RoutineDetailScreen({super.key, required this.routineId});
  final String? routineId;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final routineValue = ref.watch(routineFutureProvider(routineId!));

        return Scaffold(
            appBar: AppBar(),
            body: ListView(
              children: [
                Column(
                  children: [
                    AsyncValueWidget(
                      value: routineValue,
                      data: (routine) => routine == null
                          ? Text('No data')
                          : Center(
                              child: Column(
                                children: [
                                  Image.asset(
                                    'assets/image${routine.id}.jpg',
                                    width: 400,
                                    height: 280,
                                  ),
                                  Column(
                                    children: [
                                      TitleHeader(
                                        text: routine.title,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            ElevatedButton(
                                                onPressed: () {
                                                  // todo: implement add exercise on current routine
                                                },
                                                child: const Text('Add')),
                                            ElevatedButton(
                                                onPressed: () {
                                                  // todo: implement start workout session
                                                },
                                                child: const Text('Start')),
                                          ],
                                        ),
                                      ),
                                      ExerciseItem(items: routine.exercises)
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
                .asMap()
                .entries
                .map(
                  (item) => ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        TextHeader(text: item.value?.title ?? ''),
                      ],
                    ),
                    subtitle: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('${item.value!.exerciseSets.length} sets · '),
                        Text(
                            '${item.value!.exerciseSets[1].weight} ${item.value!.exerciseSets[1].weightUnit} · '),
                        Text('${item.value!.exerciseSets[1].repUpper} reps'),
                      ],
                    ),
                    trailing: InkWell(
                      child: Icon(Icons.more_horiz_outlined),
                      onTap: () => showModalBottomSheet(
                        showDragHandle: true,
                        context: context,
                        builder: (BuildContext context) {
                          return ExerciseSetForm(
                            exerciseName: item.value!.title,
                            exerciseSets: item.value!.exerciseSets,
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

class ExerciseSetForm extends StatelessWidget {
  const ExerciseSetForm({
    super.key,
    required this.exerciseName,
    required this.exerciseSets,
  });
  final String exerciseName;
  final List<ExerciseSet> exerciseSets;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 500,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TitleHeader(text: exerciseName),
            ExerciseSetTable(exerciseSets: exerciseSets),
            SizedBox(height: 100),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: () {
                      // todo: create new routine
                      // todo: navigate to newly created routine
                    },
                    child: const Text('Add Set')),
                ElevatedButton(
                    onPressed: () {
                      // todo: create new routine
                      // todo: navigate to newly created routine
                    },
                    child: const Text('Apply Changes')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ExerciseSetTable extends StatelessWidget {
  const ExerciseSetTable({super.key, required this.exerciseSets});
  final List<ExerciseSet> exerciseSets;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: DataTable(
        columnSpacing: 100,
        columns: const <DataColumn>[
          DataColumn(label: Text('Set')),
          DataColumn(label: Text('LBS')),
          DataColumn(label: Text('Rep Range')),
        ],
        rows: exerciseSets
            .map((exerciseSet) => DataRow(cells: [
                  DataCell(Text(exerciseSet.setNo.toString())),
                  DataCell(Text(exerciseSet.weight.toString())),
                  DataCell(Text(
                      '${exerciseSet.repLower.toString()} to ${exerciseSet.repUpper.toString()}')),
                ]))
            .toList(),
      ),
    );
  }
}
