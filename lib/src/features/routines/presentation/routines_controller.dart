import 'dart:async';
import 'dart:developer';

import 'package:fitness_ui/src/features/routines/application/routine_service.dart';
import 'package:fitness_ui/src/features/routines/data/routines_repository.dart';
import 'package:fitness_ui/src/features/routines/domain/exercise.dart';
import 'package:fitness_ui/src/features/routines/domain/routine.dart';
import 'package:fitness_ui/src/features/routines/presentation/routine_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RoutinesController
    extends AutoDisposeFamilyAsyncNotifier<List<Routine?>, bool?> {
  Future<List<Routine?>> fetchRoutines([showPublicRoutines]) async {
    if (showPublicRoutines != null || showPublicRoutines == true) {
      return await ref.watch(routinesRepositoryProvider).getPublicRoutines();
    } else {
      return await ref.watch(routinesRepositoryProvider).getRoutines();
    }
  }

  @override
  Future<List<Routine?>> build(showPublicRoutines) {
    return fetchRoutines();
  }

  Future<bool> addRoutine(Routine routine) async {
    bool retVal = false;
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final newRoutine =
          await ref.read(routinesRepositoryProvider).addRoutine(routine);
      log(newRoutine!.id.toString());
      ref.read(routineServiceProvider).setSelectedRoutineId(newRoutine.id!);
      ref.read(routineServiceProvider).setSelectedRoutine(newRoutine);
      retVal = true;
      return fetchRoutines();
    });
    return retVal;
  }

  Future<void> updateRoutine(
      Routine routine, Exercise updatedExercise, bool isUpdateExercise) async {
    state = const AsyncLoading();
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
    state = const AsyncLoading();
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
    state = const AsyncLoading();
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

  Future<void> deleteRoutine(String routineId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref
          .read(routinesRepositoryProvider)
          .deleteRoutineById(routineId: routineId);
      return fetchRoutines();
    });
  }
}

final routinesControllerProvider = AutoDisposeFamilyAsyncNotifierProvider<
    RoutinesController, List<Routine?>, bool?>(RoutinesController.new);

final routinesControllerPublicListProvider = FutureProvider.autoDispose
    .family<List<Routine?>, bool?>((ref, showPublicRoutines) {
  final link = ref.keepAlive();
  final timer = Timer(const Duration(seconds: 60), () {
    link.close();
  });
  ref.onDispose(() => timer.cancel());
  final routinesController = ref.watch(routinesControllerProvider.notifier);
  return routinesController.fetchRoutines(showPublicRoutines);
});
