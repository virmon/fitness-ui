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
  final _currentRoutine = InMemoryStore<Routine?>(null);

  String? getActiveRoutineId() {
    if (_currentRoutine.value?.id != null) {
      return _currentRoutine.value?.id;
    }
    return null;
  }

  Routine? getActiveRoutine() {
    return _currentRoutine.value;
  }

  void setActiveRoutine(Routine routine) {
    clearActiveRoutine();
    _currentRoutine.value = routine;
  }

  void clearActiveRoutine() {
    _currentRoutine.value = null;
  }

  Future<Routine?> createRoutine(Routine routine) {
    return ref.read(routinesRepositoryProvider).addRoutine(routine);
  }

  Future<Routine?> fetchCurrentRoutine() async {
    try {
      String? routineId = getActiveRoutineId();
      Routine? routine;
      if (routineId != null) {
        routine = await ref
            .read(routinesRepositoryProvider)
            .getRoutineById(routineId);
      }
      return routine;
    } catch (e) {
      throw 'The routine you requested is not available.';
    }
  }

  Future<Routine?> fetchCurrentPublicRoutine() async {
    try {
      String? routineId = getActiveRoutineId();
      Routine? routine;
      if (routineId != null) {
        routine = await ref
            .read(routinesRepositoryProvider)
            .getPublicRoutineById(routineId);
      }
      return routine;
    } catch (e) {
      throw 'The routine you requested is not available.';
    }
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
      final routine = getActiveRoutine();
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
