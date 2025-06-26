import 'package:fitness_ui/src/common/typography.dart';
import 'package:fitness_ui/src/features/routines/data/fake_routines_repository.dart';
import 'package:fitness_ui/src/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class RoutineAddForm extends ConsumerStatefulWidget {
  const RoutineAddForm({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RoutineAddFormState();
}

class _RoutineAddFormState extends ConsumerState<RoutineAddForm> {
  final addRoutineFormController = TextEditingController();
  String _newRoutineTitle = '';
  bool _isButtonDisabled = true;

  @override
  void initState() {
    super.initState();

    addRoutineFormController.addListener(_printLatestValue);
  }

  @override
  void dispose() {
    addRoutineFormController.dispose();
    super.dispose();
  }

  void _printLatestValue() {
    setState(() {
      _newRoutineTitle = addRoutineFormController.text;
      if (addRoutineFormController.text.isEmpty) {
        _isButtonDisabled = true;
      } else {
        _isButtonDisabled = false;
      }
    });
  }

  void _createRoutineTitle() {
    ref.read(routinesRepositoryProvider).setRoutine(_newRoutineTitle, null);
    context.pop();
    context.goNamed(AppRoute.workoutPlan.name,
        queryParameters: {'title': _newRoutineTitle});
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                right: 20,
                bottom: 20,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(onTap: () => context.pop(), child: Icon(Icons.close))
                ],
              ),
            ),
            const TitleHeader(text: 'Name your new Routine'),
            SizedBox(
              width: 350,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextField(
                  controller: addRoutineFormController,
                  autofocus: true,
                  decoration: InputDecoration(
                    filled: true,
                    hintStyle: TextStyle(color: Colors.grey[800]),
                    hintText: "My workout plan",
                    fillColor: Colors.white10,
                  ),
                ),
              ),
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  splashFactory: _isButtonDisabled
                      ? NoSplash.splashFactory
                      : InkSplash.splashFactory,
                  backgroundColor:
                      _isButtonDisabled ? Colors.grey : Colors.indigo,
                ),
                onPressed: () =>
                    _isButtonDisabled ? null : _createRoutineTitle(),
                child: const Text('Create'))
          ],
        ),
      ),
    );
  }
}
