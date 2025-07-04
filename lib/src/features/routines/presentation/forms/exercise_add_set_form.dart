import 'package:fitness_ui/src/common/typography.dart';
import 'package:fitness_ui/src/features/routines/application/routine_service.dart';
import 'package:fitness_ui/src/features/routines/data/fake_routines_repository.dart';
import 'package:fitness_ui/src/features/routines/domain/exercise.dart';
import 'package:fitness_ui/src/features/routines/domain/exercise_set.dart';
import 'package:fitness_ui/src/features/routines/domain/routine.dart';
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
  final List<ExerciseSet> _removedSets = [];
  final ScrollController _controller = ScrollController();

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

  void _addExerciseSet() {
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
    setState(() {
      _exerciseSet = [..._exerciseSet, newExerciseSet];
    });
  }

  void _removeExerciseSet(ExerciseSet exercise) {
    final removeIndex =
        _exerciseSet.indexWhere((e) => e.setNo == exercise.setNo);

    setState(() {
      final removedSet = _exerciseSet.removeAt(removeIndex);
      _removedSets.add(removedSet);
    });
  }

  void _updateSets(AsyncValue routine) {
    List<ExerciseSet> undoList = [..._exerciseSet];
    setState(() {
      final updatedExercise = Exercise(
        id: widget.exercise.id,
        title: widget.exercise.title,
        type: widget.exercise.type,
        exerciseSets: undoList,
      );
      routine.whenData((selectedRoutine) => ref
          .read(routineServiceProvider)
          .addExercise(selectedRoutine!, updatedExercise, widget.isUpdate));
    });
  }

  void _scrollDown() {
    if (_controller.hasClients) {
      final listTileHeight = 64;
      double scrollPosition = _controller.position.maxScrollExtent;
      if (_exerciseSet.length >= 3) {
        scrollPosition = _controller.position.maxScrollExtent + listTileHeight;
      }
      _controller.animateTo(
        scrollPosition,
        duration: Duration(seconds: 1),
        curve: Curves.ease,
      );
    }
  }

  void _saveToRoutine(AsyncValue<Routine?> routine) {
    String message = widget.isUpdate
        ? '${widget.exercise.title} Updated'
        : '${widget.exercise.title} Added';
    final updatedExercise = Exercise(
      id: widget.exercise.id,
      title: widget.exercise.title,
      type: widget.exercise.type,
      exerciseSets: _exerciseSet,
    );

    routine.whenData((selectedRoutine) => ref
        .read(routineServiceProvider)
        .addExercise(selectedRoutine!, updatedExercise, widget.isUpdate));
    context.pop();
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final routineId = ref.read(routineServiceProvider).getSelectedRoutineId();
    final routine = ref.watch(routineProvider(routineId ?? '0'));

    String saveButtonText =
        widget.isUpdate ? 'Apply changes' : 'Add to routine';

    return SizedBox(
      height: 900,
      child: Center(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10, right: 10),
                  child: IconButton(
                    onPressed: () {
                      context.pop();
                      if (widget.isUpdate) {
                        _updateSets(routine);
                      }
                    },
                    icon: Icon(Icons.close),
                  ),
                )
              ],
            ),
            ExerciseSetList(
                exerciseSets: _exerciseSet,
                callback: _removeExerciseSet,
                scrollControl: _controller),
            SizedBox(
                child: Column(
              children: [
                Card(
                  child: ListTile(
                    title: Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                              height: 50,
                              width: 80,
                              child: Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: TextField(
                                  autofocus: true,
                                  controller: _weightController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      label: Text('LBS')),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 50,
                              width: 80,
                              child: Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: TextField(
                                  controller: _lowerRepController,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      label: Text('Rep lower')),
                                ),
                              ),
                            ),
                            Text('to'),
                            SizedBox(
                              height: 50,
                              width: 80,
                              child: Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: TextField(
                                  // style: TextStyle(height: 1.5),
                                  controller: _upperRepController,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      label: Text('Rep upper')),
                                ),
                              ),
                            ),
                          ],
                        )),
                    trailing: IconButton(
                      onPressed: () {
                        if (_weight == '' ||
                            _lowerRep == '' ||
                            _upperRep == '') {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: const Text('Missing Input')));
                        } else {
                          _scrollDown();
                          _addExerciseSet();
                        }
                      },
                      icon: Icon(Icons.add),
                    ),
                  ),
                )
              ],
            )),
            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Visibility(
                    visible: false,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo,
                        ),
                        onPressed: () {
                          if (_weight == '' ||
                              _lowerRep == '' ||
                              _upperRep == '') {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: const Text('Missing Input')));
                          } else {
                            _scrollDown();
                            _addExerciseSet();
                          }
                        },
                        child: const Text('Add Set')),
                  ),
                  Visibility(
                    visible: !widget.isUpdate,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo,
                        ),
                        onPressed: () {
                          _saveToRoutine(routine);
                        },
                        child: Text(saveButtonText)),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ExerciseSetList extends StatelessWidget {
  const ExerciseSetList({
    super.key,
    required this.exerciseSets,
    this.callback,
    required this.scrollControl,
  });
  final List<ExerciseSet> exerciseSets;
  final Function? callback;
  final ScrollController scrollControl;

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
              controller: scrollControl,
              children: [
                Column(
                  children: exerciseSets.isEmpty
                      ? [Text('No Data')]
                      : exerciseSets
                          .map((exerciseSet) => Card(
                                  child: Dismissible(
                                key: Key(exerciseSet.setNo.toString()),
                                onDismissed: (direction) {
                                  callback!(exerciseSet);
                                },
                                background: Container(color: Colors.red),
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
                              )))
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
