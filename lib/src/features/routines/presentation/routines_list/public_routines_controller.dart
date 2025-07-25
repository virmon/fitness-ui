import 'dart:async';

import 'package:fitness_ui/src/features/routines/data/routines_repository.dart';
import 'package:fitness_ui/src/features/routines/domain/routine.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PublicRoutinesController
    extends AutoDisposeAsyncNotifier<List<Routine?>> {
  Future<List<Routine?>> fetchRoutines() async {
    final link = ref.keepAlive();
    final timer = Timer(const Duration(seconds: 120), () {
      link.close();
    });
    ref.onDispose(() => timer.cancel());
    return await ref.watch(routinesRepositoryProvider).getPublicRoutines();
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
}

final publicRoutinesControllerProvider =
    AutoDisposeAsyncNotifierProvider<PublicRoutinesController, List<Routine?>>(
        PublicRoutinesController.new);
