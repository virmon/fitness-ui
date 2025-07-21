// import 'package:fitness_ui/src/features/routines/data/fake_routines_repository.dart';
import 'dart:developer';

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
    // log(routine.title.toString());
    _currentRoutine.value = routine;
  }

  void clearSelectedRoutine() {
    _currentRoutine.value = null;
  }

  void createRoutine(Routine routine) {
    // ref.read(routinesRepositoryProvider).setRoutine(routine);
    ref.read(routinesRepositoryProvider).addRoutine(routine);
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
      // String? routineId = getSelectedRoutineId();
      // final routine =
      //     ref.read(routinesRepositoryProvider).getRoutineById(routineId!);
      // Routine updatedRoutine = routine.removeExerciseById(exercise.id);
      // createRoutine(updatedRoutine);
    } catch (e) {
      FlutterError.onError!(FlutterErrorDetails(exception: e));
    }
  }
}

final routineServiceProvider = Provider<RoutineService>((ref) {
  return RoutineService(ref);
});
