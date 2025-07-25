import 'dart:async';

import 'package:fitness_ui/src/common/global_loading_indicator.dart';
import 'package:fitness_ui/src/features/routines/application/routine_service.dart';
import 'package:fitness_ui/src/features/routines/domain/routine.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PublicRoutineController extends AutoDisposeAsyncNotifier<Routine?> {
  Routine? routine;
  @override
  Future<Routine?> build() {
    return getCurrentRoutine();
  }

  Future<Routine?> getCurrentRoutine() async {
    routine = await ref
        .read(routineServiceProvider)
        .fetchCurrentPublicRoutine()
        .whenComplete(() => ref.read(loadingProvider.notifier).state = false);
    return routine;
  }
}

final activePublicRoutineControllerProvider =
    AutoDisposeAsyncNotifierProvider<PublicRoutineController, Routine?>(
        PublicRoutineController.new);
