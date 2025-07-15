// import 'package:fitness_ui/src/features/routines/data/fake_routines_repository.dart';
import 'package:fitness_ui/src/features/routines/data/routines_repository.dart';
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

  String? getSelectedRoutineId() {
    return _currentRoutine.value;
  }

  void setSelectedRoutineId(String routineId) {
    _currentRoutine.value = routineId;
  }

  void clearSelectedRoutineId() {
    _currentRoutine.value = null;
  }

  void createRoutine(Routine routine) {
    // ref.read(routinesRepositoryProvider).setRoutine(routine);
    ref.read(routinesRepositoryProvider).addRoutine(routine);
  }

  Routine? getCurrentRoutine() {
    String? routineId = getSelectedRoutineId();
    Routine? routine =
        ref.read(routinesRepositoryProvider).getRoutineById(routineId!);
    return routine;
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

  Future<void> removeExercise(Exercise exercise) async {
    try {
      String? routineId = getSelectedRoutineId();
      final routine =
          ref.read(routinesRepositoryProvider).getRoutineById(routineId!);
      // Routine updatedRoutine = routine!.removeExerciseById(exercise.id);
      Routine updatedRoutine = routine!.removeExerciseById(exercise.id);
      createRoutine(updatedRoutine);
    } catch (e) {
      FlutterError.onError!(FlutterErrorDetails(exception: e));
    }
  }
}

final routineServiceProvider = Provider<RoutineService>((ref) {
  return RoutineService(ref);
});
