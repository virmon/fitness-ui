import 'package:fitness_ui/src/common/async_value_widget.dart';
import 'package:fitness_ui/src/features/routines/data/routines_repository.dart';
import 'package:fitness_ui/src/features/routines/domain/exercise.dart';
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
                                      Text(
                                        routine.title,
                                        style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w400,
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
                .map((item) => ExpansionTile(
                      title: Text(item?.title ?? ''),
                    ))
                .toList());
      },
    );
  }
}
