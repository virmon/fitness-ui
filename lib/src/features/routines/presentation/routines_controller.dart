import 'dart:async';

import 'package:fitness_ui/src/features/routines/data/routines_repository.dart';
import 'package:fitness_ui/src/features/routines/domain/routine.dart';
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

  Future<void> addRoutine(Routine routine) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(routinesRepositoryProvider).addRoutine(routine);
      return fetchRoutines();
    });
  }

  // todo: implement update routine controller
  Future<void> updateRoutine(Routine routine) async {}

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
