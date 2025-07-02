import 'dart:async';

import 'package:fitness_ui/src/constants/mock_routines.dart';
import 'package:fitness_ui/src/utils/delay.dart';
import 'package:fitness_ui/src/features/routines/domain/routine.dart';
import 'package:fitness_ui/src/utils/in_memory_store.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FakeRoutinesRepository {
  FakeRoutinesRepository({this.hasDelay = true});
  final bool hasDelay;

  final _routines = InMemoryStore<List<Routine>>(List.from(mockRoutines));

  List<Routine> getRoutinesList() {
    return _routines.value;
  }

  Routine? getRoutineById(String routineId) {
    return _getRoutine(_routines.value, routineId);
  }

  Future<List<Routine>> fetchRoutinesList() async {
    return Future.value(_routines.value);
  }

  Stream<List<Routine>> watchRoutinesList() {
    return _routines.stream;
  }

  Stream<Routine?> watchRoutine(String routineId) {
    return watchRoutinesList()
        .map((routines) => _getRoutine(routines, routineId));
  }

  Future<void> setRoutine(Routine routine) async {
    await delay(hasDelay);
    final routines = _routines.value;

    if (routine.id == null) {
      Routine myNewRoutine = Routine(
        id: routine.title,
        title: routine.title,
        notes: routine.notes ?? '',
        exercises: routine.exercises,
        isPrivate: true,
      );
      routines.add(myNewRoutine);
    } else {
      final index = routines.indexWhere((current) => current.id == routine.id);

      routines[index] = routines[index].copyWith(
        title: routine.title,
        notes: routine.notes ?? '',
        exercises: routine.exercises,
        isPrivate: routine.isPrivate,
      );
    }
    _routines.value = routines;
  }

  Future<List<Routine>> searchRoutines(String query) async {
    assert(
      _routines.value.length <= 100,
      'Client-side search should only be performed if the number of routines is small. '
      'Consider doing server-side search for larger datasets.',
    );
    final routinesList = await fetchRoutinesList();
    return routinesList
        .where((routine) =>
            routine.title.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  static Routine? _getRoutine(List<Routine> routines, String routineId) {
    try {
      return routines.firstWhere((routine) => routine.id == routineId);
    } catch (e) {
      return null;
    }
  }
}

final routinesRepositoryProvider = Provider<FakeRoutinesRepository>((ref) {
  return FakeRoutinesRepository(hasDelay: false);
});

final routinesListStreamProvider =
    StreamProvider.autoDispose<List<Routine>>((ref) {
  final routinesRepository = ref.watch(routinesRepositoryProvider);
  return routinesRepository.watchRoutinesList();
});

final routinesListFutureProvider =
    FutureProvider.autoDispose<List<Routine>>((ref) {
  final routinesRepository = ref.watch(routinesRepositoryProvider);
  return routinesRepository.fetchRoutinesList();
});

final routineProvider =
    StreamProvider.autoDispose.family<Routine?, String>((ref, id) {
  final routinesRepository = ref.watch(routinesRepositoryProvider);
  return routinesRepository.watchRoutine(id);
});

final routinesListSearchProvider = FutureProvider.autoDispose
    .family<List<Routine>, String>((ref, query) async {
  final link = ref.keepAlive();
  // * keep previous search results in memory for 60 seconds
  final timer = Timer(const Duration(seconds: 60), () {
    link.close();
  });
  ref.onDispose(() => timer.cancel());
  final routinesRepository = ref.watch(routinesRepositoryProvider);
  return routinesRepository.searchRoutines(query);
});
