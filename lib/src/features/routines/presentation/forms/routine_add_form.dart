import 'package:fitness_ui/src/common/global_loading_indicator.dart';
import 'package:fitness_ui/src/common/typography.dart';
import 'package:fitness_ui/src/constants/constants.dart';
import 'package:fitness_ui/src/features/routines/application/routine_service.dart';
import 'package:fitness_ui/src/features/routines/domain/routine.dart';
import 'package:fitness_ui/src/features/routines/presentation/routines_list/routines_controller.dart';
import 'package:fitness_ui/src/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class RoutineAddForm extends ConsumerStatefulWidget {
  final bool isUpdateForm;

  const RoutineAddForm({
    super.key,
    this.isUpdateForm = false,
  });

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

    if (widget.isUpdateForm) {
      final routine = ref.read(routineServiceProvider).getActiveRoutine();
      addRoutineFormController.text = routine?.title ?? '';
    }
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
      _isButtonDisabled = addRoutineFormController.text.isEmpty;
    });
  }

  void _createRoutineTitle() async {
    ref.watch(routineServiceProvider).clearActiveRoutine();
    final hasCreatedNewRoutine = await ref
        .read(routinesControllerProvider.notifier)
        .addRoutine(Routine(title: _newRoutineTitle));

    if (context.mounted && hasCreatedNewRoutine) {
      _navigateRoutineDetailScreen();
      ref.read(loadingProvider.notifier).state = false;
    }
  }

  void _navigateRoutineDetailScreen() {
    context.pop();
    context.goNamed(AppRoute.routineDetail.name);
  }

  void _editRoutineTitle() {
    final currentRoutine = ref.read(routineServiceProvider).getActiveRoutine();

    Routine? updatedRoutine;
    if (currentRoutine != null) {
      updatedRoutine = Routine(
        id: currentRoutine.id,
        title: _newRoutineTitle,
        notes: currentRoutine.notes,
        exercises: currentRoutine.exercises,
        isPrivate: currentRoutine.isPrivate,
      );
      ref
          .read(routinesControllerProvider.notifier)
          .updateRoutineTitle(updatedRoutine);
    }
    context.pop();
  }

  void _saveRoutineTitle() {
    if (widget.isUpdateForm && addRoutineFormController.text.isNotEmpty) {
      _editRoutineTitle();
    } else {
      if (addRoutineFormController.text.isNotEmpty) {
        _createRoutineTitle();
      } else {
        null;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    String formLabel =
        widget.isUpdateForm ? AppRoutine.renameRoutine : AppRoutine.nameRoutine;
    String buttonText = widget.isUpdateForm ? 'Rename' : 'Create';

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
            TitleHeader(formLabel),
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
                onPressed: _saveRoutineTitle,
                child: Text(buttonText))
          ],
        ),
      ),
    );
  }
}
