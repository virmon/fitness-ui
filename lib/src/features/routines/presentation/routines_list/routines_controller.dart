import 'dart:async';
import 'dart:developer';

import 'package:fitness_ui/src/common/global_loading_indicator.dart';
import 'package:fitness_ui/src/features/routines/application/routine_service.dart';
import 'package:fitness_ui/src/features/routines/data/routines_repository.dart';
import 'package:fitness_ui/src/features/routines/domain/exercise.dart';
import 'package:fitness_ui/src/features/routines/domain/routine.dart';
import 'package:fitness_ui/src/features/routines/presentation/routine_details/routine_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RoutinesController extends AutoDisposeAsyncNotifier<List<Routine?>> {
  Future<List<Routine?>> fetchRoutines() async {
    final link = ref.keepAlive();
    final timer = Timer(const Duration(seconds: 120), () {
      link.close();
    });
    ref.onDispose(() => timer.cancel());
    return await ref.watch(routinesRepositoryProvider).getRoutines();
  }

  @override
  Future<List<Routine?>> build() {
    return fetchRoutines();
  }

  Future<void> refreshRoutines() async {
    state = await AsyncValue.guard(() async {
      return fetchRoutines();
    });
  }

  Future<bool> addRoutine(Routine routine) async {
    bool isCreateSuccess = false;
    ref.read(loadingProvider.notifier).state = true;
    state = await AsyncValue.guard(() async {
      final newRoutine =
          await ref.read(routinesRepositoryProvider).addRoutine(routine);
      log(newRoutine!.id.toString());
      if (newRoutine.id != null) {
        isCreateSuccess = true;
      }
      ref.read(routineServiceProvider).setActiveRoutine(newRoutine);
      return fetchRoutines();
    });
    return isCreateSuccess;
  }

  Future<void> updateRoutine(
      Routine routine, Exercise updatedExercise, bool isUpdateExercise) async {
    state = await AsyncValue.guard(() async {
      final updatedRoutine = await ref
          .read(routineServiceProvider)
          .addExercise(routine, updatedExercise, isUpdateExercise);
      if (updatedRoutine != null) {
        await ref
            .read(activeRoutineControllerProvider.notifier)
            .refreshActiveRoutine();
      }
      return fetchRoutines();
    });
  }

  Future<void> updateRoutineTitle(Routine routine) async {
    state = await AsyncValue.guard(() async {
      final updatedRoutine =
          await ref.read(routineServiceProvider).createRoutine(routine);
      if (updatedRoutine != null) {
        await ref
            .read(activeRoutineControllerProvider.notifier)
            .refreshActiveRoutine();
      }
      return fetchRoutines();
    });
  }

  Future<void> removeExercise(Exercise exercise) async {
    state = await AsyncValue.guard(() async {
      final updatedRoutine =
          await ref.read(routineServiceProvider).removeExercise(exercise);
      if (updatedRoutine != null) {
        await ref
            .read(activeRoutineControllerProvider.notifier)
            .refreshActiveRoutine();
      }
      return fetchRoutines();
    });
  }

  Future<bool> deleteRoutine(String routineId) async {
    bool isDeleted = false;
    ref.read(loadingProvider.notifier).state = true;
    state = await AsyncValue.guard(() async {
      isDeleted = await ref
          .read(routinesRepositoryProvider)
          .deleteRoutineById(routineId: routineId);
      return fetchRoutines();
    }).whenComplete(() => ref.read(loadingProvider.notifier).state = false);
    return Future.value(isDeleted);
  }
}

final routinesControllerProvider =
    AutoDisposeAsyncNotifierProvider<RoutinesController, List<Routine?>>(
        RoutinesController.new);
