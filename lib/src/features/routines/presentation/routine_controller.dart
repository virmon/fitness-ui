import 'dart:async';
import 'dart:developer';

import 'package:fitness_ui/src/features/routines/application/routine_service.dart';
import 'package:fitness_ui/src/features/routines/domain/routine.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RoutineController extends AutoDisposeAsyncNotifier<Routine?> {
  @override
  Future<Routine?> build() {
    return ref.read(routineServiceProvider).fetchCurrentRoutine();
  }

  Future<void> getSingleRoutine() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      // ref.read(routineServiceProvider).setSelectedRoutineId(routineId);
      return await ref.read(routineServiceProvider).fetchCurrentRoutine();
    });
  }
}

final activeRoutineControllerProvider =
    AutoDisposeAsyncNotifierProvider<RoutineController, Routine?>(
        RoutineController.new);
