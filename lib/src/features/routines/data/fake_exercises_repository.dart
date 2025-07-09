import 'dart:async';

import 'package:fitness_ui/src/constants/mock_routines.dart';
import 'package:fitness_ui/src/features/routines/domain/exercise.dart';
import 'package:fitness_ui/src/utils/delay.dart';
import 'package:fitness_ui/src/utils/in_memory_store.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FakeExercisesRepository {
  FakeExercisesRepository({this.hasDelay = true});
  final bool hasDelay;

  final _exercises = InMemoryStore<List<Exercise>>(List.from(mockExercises));

  List<Exercise> getExercisesList() {
    return _exercises.value;
  }

  Exercise? getExerciseById(String exerciseId) {
    return _getExercise(_exercises.value, exerciseId);
  }

  Future<List<Exercise>> fetchExercisesList() async {
    return Future.value(_exercises.value);
  }

  Stream<List<Exercise>> watchExercisesList() {
    return _exercises.stream;
  }

  Stream<Exercise?> watchExercise(String exerciseId) {
    return watchExercisesList()
        .map((exercises) => _getExercise(exercises, exerciseId));
  }

  Future<List<Exercise>> searchExercises(String query) async {
    await delay(true);
    assert(
      _exercises.value.length <= 100,
      'Client-side search should only be performed if the number of routines is small. '
      'Consider doing server-side search for larger datasets.',
    );
    final exercisesList = await fetchExercisesList();
    return exercisesList
        .where((exercise) =>
            exercise.title.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  static Exercise? _getExercise(List<Exercise> exercises, String exerciseId) {
    try {
      return exercises.firstWhere((exercise) => exercise.id == exerciseId);
    } catch (e) {
      return null;
    }
  }
}

final exercisesRepositoryProvider = Provider<FakeExercisesRepository>((ref) {
  return FakeExercisesRepository();
});

final exercisesListStreamProvider =
    StreamProvider.autoDispose<List<Exercise>>((ref) {
  final exercisesRepository = ref.watch(exercisesRepositoryProvider);
  return exercisesRepository.watchExercisesList();
});

final exercisesListFutureProvider =
    FutureProvider.autoDispose<List<Exercise>>((ref) {
  final exercisesRepository = ref.watch(exercisesRepositoryProvider);
  return exercisesRepository.fetchExercisesList();
});

final exerciseProvider =
    StreamProvider.autoDispose.family<Exercise?, String>((ref, id) {
  final exercisesRepository = ref.watch(exercisesRepositoryProvider);
  return exercisesRepository.watchExercise(id);
});

final exercisesListSearchProvider = FutureProvider.autoDispose
    .family<List<Exercise>, String>((ref, query) async {
  final link = ref.keepAlive();
  // * keep previous search results in memory for 60 seconds
  final timer = Timer(const Duration(seconds: 60), () {
    link.close();
  });
  ref.onDispose(() => timer.cancel());
  final exercisesRepository = ref.watch(exercisesRepositoryProvider);
  return exercisesRepository.searchExercises(query);
});
