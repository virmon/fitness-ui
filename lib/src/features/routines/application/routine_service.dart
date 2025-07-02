import 'package:fitness_ui/src/features/routines/data/fake_routines_repository.dart';
import 'package:fitness_ui/src/features/routines/domain/exercise.dart';
import 'package:fitness_ui/src/features/routines/domain/mutable_routine.dart';
import 'package:fitness_ui/src/features/routines/domain/routine.dart';
import 'package:fitness_ui/src/utils/in_memory_store.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RoutineService {
  RoutineService(this.ref);
  final Ref ref;
  final _currentRoutine = InMemoryStore<String?>(null);

  String? getSelectedRoutine() {
    return _currentRoutine.value;
  }

  void setSelectedRoutine(String routineId) {
    _currentRoutine.value = routineId;
  }

  void clearSelectedRoutine() {
    _currentRoutine.value = null;
  }

  void createRoutine(Routine routine) {
    ref.read(routinesRepositoryProvider).setRoutine(routine);
  }

  Future<void> addExercise(
      Routine routine, Exercise exercise, bool isUpdate) async {
    try {
      Routine updatedRoutine;
      if (isUpdate) {
        updatedRoutine = routine.updateExercise(exercise);
      } else {
        updatedRoutine = routine.addExercise(exercise);
      }
      createRoutine(updatedRoutine);
    } catch (e) {
      FlutterError.onError!(FlutterErrorDetails(exception: e));
    }
  }
}

final routineServiceProvider = Provider<RoutineService>((ref) {
  return RoutineService(ref);
});
