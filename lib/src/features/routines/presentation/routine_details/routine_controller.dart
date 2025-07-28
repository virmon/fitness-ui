import 'dart:async';

import 'package:fitness_ui/src/common/global_loading_indicator.dart';
import 'package:fitness_ui/src/features/routines/application/routine_service.dart';
import 'package:fitness_ui/src/features/routines/domain/routine.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RoutineController extends AutoDisposeAsyncNotifier<Routine?> {
  Routine? routine;
  @override
  Future<Routine?> build() {
    return getCurrentRoutine();
  }

  Future<Routine?> getCurrentRoutine() async {
    routine = await ref
        .read(routineServiceProvider)
        .fetchCurrentRoutine()
        .whenComplete(() => ref.read(loadingProvider.notifier).state = false);
    return routine;
  }

  Future<void> refreshActiveRoutine() async {
    state = await AsyncValue.guard(() async {
      final updatedRoutine =
          await ref.read(routineServiceProvider).fetchCurrentRoutine();
      if (updatedRoutine != null) {
        ref.read(routineServiceProvider).setActiveRoutine(updatedRoutine);
      }
      return updatedRoutine;
    });
  }
}

final activeRoutineControllerProvider =
    AutoDisposeAsyncNotifierProvider<RoutineController, Routine?>(
        RoutineController.new);
