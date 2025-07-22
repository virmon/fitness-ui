import 'dart:async';

import 'package:fitness_ui/src/features/routines/application/routine_service.dart';
import 'package:fitness_ui/src/features/routines/domain/routine.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RoutineController extends AutoDisposeAsyncNotifier<Routine?> {
  @override
  Future<Routine?> build() {
    return ref.read(routineServiceProvider).fetchCurrentRoutine();
  }

  Future<void> refreshActiveRoutine() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final updatedRoutine =
          await ref.read(routineServiceProvider).fetchCurrentRoutine();
      if (updatedRoutine != null) {
        ref.read(routineServiceProvider).setSelectedRoutine(updatedRoutine);
      }
      return updatedRoutine;
    });
  }
}

final activeRoutineControllerProvider =
    AutoDisposeAsyncNotifierProvider<RoutineController, Routine?>(
        RoutineController.new);
