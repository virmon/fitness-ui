import 'package:fitness_ui/src/features/routines/data/fake_exercises_repository.dart';
import 'package:fitness_ui/src/features/routines/domain/exercise.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RoutineController extends AutoDisposeAsyncNotifier<List<Exercise>> {
  @override
  List<Exercise> build() {
    return [];
  }

  void searchExercises(String query) async {
    final exercisesRepository = ref.read(exercisesRepositoryProvider);
    state = const AsyncLoading();
    state = AsyncValue.data(await exercisesRepository.searchExercises(query));
  }
}

final routineControllerProvider =
    AsyncNotifierProvider.autoDispose<RoutineController, List<Exercise>>(() {
  return RoutineController();
});
