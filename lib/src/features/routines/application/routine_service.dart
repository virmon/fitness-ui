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
  final _currentRoutineId = InMemoryStore<String?>(null);
  final _currentRoutine = InMemoryStore<Routine?>(null);

  String? getSelectedRoutineId() {
    return _currentRoutineId.value;
  }

  void setSelectedRoutineId(String routineId) {
    _currentRoutineId.value = routineId;
  }

  void clearSelectedRoutineId() {
    _currentRoutineId.value = null;
  }

  Routine? getSelectedRoutine() {
    return _currentRoutine.value;
  }

  void setSelectedRoutine(Routine routine) {
    _currentRoutine.value = routine;
  }

  void clearSelectedRoutine() {
    _currentRoutine.value = null;
  }

  Future<Routine?> createRoutine(Routine routine) {
    return ref.read(routinesRepositoryProvider).addRoutine(routine);
  }

  Future<Routine?> fetchCurrentRoutine() async {
    String? routineId = getSelectedRoutineId();
    Routine? routine;
    if (routineId != null) {
      routine =
          await ref.read(routinesRepositoryProvider).getRoutineById(routineId);
    }
    return routine;
  }

  Future<Routine?> addExercise(
      Routine routine, Exercise exercise, bool isUpdate) async {
    try {
      Routine updatedRoutine;
      if (isUpdate) {
        updatedRoutine = routine.updateExercise(exercise);
      } else {
        updatedRoutine = routine.addExercise(exercise);
      }
      return createRoutine(updatedRoutine);
    } catch (e) {
      FlutterError.onError!(FlutterErrorDetails(exception: e));
      return null;
    }
  }

  Future<Routine?> removeExercise(Exercise exercise) async {
    try {
      final routine = getSelectedRoutine();
      Routine updatedRoutine;
      if (routine != null) {
        updatedRoutine = routine.removeExerciseById(exercise.id);
        return createRoutine(updatedRoutine);
      }
      return null;
    } catch (e) {
      FlutterError.onError!(FlutterErrorDetails(exception: e));
      return null;
    }
  }
}

final routineServiceProvider = Provider<RoutineService>((ref) {
  return RoutineService(ref);
});
