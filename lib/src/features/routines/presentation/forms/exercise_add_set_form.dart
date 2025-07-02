import 'package:fitness_ui/src/common/typography.dart';
import 'package:fitness_ui/src/features/routines/application/routine_service.dart';
import 'package:fitness_ui/src/features/routines/data/fake_routines_repository.dart';
import 'package:fitness_ui/src/features/routines/domain/exercise.dart';
import 'package:fitness_ui/src/features/routines/domain/exercise_set.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ExerciseAddSetForm extends ConsumerStatefulWidget {
  const ExerciseAddSetForm({
    super.key,
    required this.exercise,
    this.isUpdate = false,
  });
  final Exercise exercise;
  final bool isUpdate;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _State();
}

class _State extends ConsumerState<ExerciseAddSetForm> {
  final _weightController = TextEditingController();
  final _lowerRepController = TextEditingController();
  final _upperRepController = TextEditingController();
  String _weight = '';
  String _lowerRep = '';
  String _upperRep = '';

  List<ExerciseSet> _exerciseSet = [];

  @override
  void initState() {
    super.initState();

    if (widget.exercise.exerciseSets != null) {
      setState(() {
        _exerciseSet = widget.exercise.exerciseSets!;
      });
    }

    _weightController.addListener(_printLatestValue);
    _lowerRepController.addListener(_printLatestValue);
    _upperRepController.addListener(_printLatestValue);
  }

  @override
  void dispose() {
    _weightController.dispose();
    _lowerRepController.dispose();
    _upperRepController.dispose();
    super.dispose();
  }

  void _printLatestValue() {
    setState(() {
      _weight = _weightController.text;
      _lowerRep = _lowerRepController.text;
      _upperRep = _upperRepController.text;
    });
  }

  void _addExerciseSet(ExerciseSet newExerciseSet) {
    setState(() {
      _exerciseSet = [..._exerciseSet, newExerciseSet];
    });
  }

  @override
  Widget build(BuildContext context) {
    final routineId = ref.read(routineServiceProvider).getSelectedRoutine();
    final routine = ref.watch(routineProvider(routineId!));

    String saveButtonText =
        widget.isUpdate ? 'Apply changes' : 'Add to routine';
    String message = widget.isUpdate ? 'Exercise Updated' : 'Exercise Added';

    return SizedBox(
      height: 900,
      child: Center(
        child: Column(
          children: [
            ExerciseSetList(exerciseSets: _exerciseSet),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Card(
                    child: Row(
                  children: [
                    SizedBox(
                      height: 70,
                      width: 100,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          autofocus: true,
                          controller: _weightController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(), label: Text('LBS')),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 70,
                      width: 100,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: _lowerRepController,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(), label: Text('Min')),
                        ),
                      ),
                    ),
                    Text('to'),
                    SizedBox(
                      height: 70,
                      width: 100,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: _upperRepController,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(), label: Text('Max')),
                        ),
                      ),
                    ),
                  ],
                )),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                    ),
                    onPressed: () {
                      if (_weight == '' || _lowerRep == '' || _upperRep == '') {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: const Text('Missing Input')));
                      } else {
                        final exerciseSetCount = _exerciseSet.length + 1;
                        final weightUnit = 'LBS';

                        final newExerciseSet = ExerciseSet(
                          setNo: exerciseSetCount.toString(),
                          repLower: int.parse(_lowerRep),
                          repUpper: int.parse(_upperRep),
                          weight: int.parse(_weight),
                          weightUnit: weightUnit,
                          restDuration: 2000,
                        );

                        _addExerciseSet(newExerciseSet);
                      }
                    },
                    child: const Text('Add Set')),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                    ),
                    onPressed: () {
                      // add to current routine plan
                      final updatedExercise = Exercise(
                        id: widget.exercise.id,
                        title: widget.exercise.title,
                        type: widget.exercise.type,
                        exerciseSets: _exerciseSet,
                      );

                      routine.whenData((selectedRoutine) => ref
                          .read(routineServiceProvider)
                          .addExercise(selectedRoutine!, updatedExercise,
                              widget.isUpdate));
                      context.pop();
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text(message)));
                    },
                    child: Text(saveButtonText)),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class ExerciseSetList extends StatelessWidget {
  const ExerciseSetList({super.key, required this.exerciseSets});
  final List<ExerciseSet> exerciseSets;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextHeader(text: 'Set (${exerciseSets.length})'),
                TextHeader(text: 'Weight'),
                TextHeader(text: 'Rep Range'),
                SizedBox(width: 25)
              ],
            ),
          ),
          SizedBox(
            height: 190,
            child: ListView(
              children: [
                Column(
                  children: exerciseSets.isEmpty
                      ? [Text('No Data')]
                      : exerciseSets
                          .map((exerciseSet) => Card(
                                child: ListTile(
                                  title: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Text(exerciseSet.setNo.toString()),
                                      Text(exerciseSet.weight.toString()),
                                      Text(
                                          '${exerciseSet.repLower.toString()} to ${exerciseSet.repUpper.toString()} '),
                                    ],
                                  ),
                                  trailing: IconButton(
                                      onPressed: () => {},
                                      icon: Icon(Icons.more_horiz)),
                                ),
                              ))
                          .toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
