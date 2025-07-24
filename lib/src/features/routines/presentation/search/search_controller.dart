import 'package:fitness_ui/src/features/routines/data/fake_exercises_repository.dart';
import 'package:fitness_ui/src/features/routines/domain/exercise.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchController extends AutoDisposeAsyncNotifier<List<Exercise>> {
  @override
  List<Exercise> build() {
    return [];
  }

  void searchExercises(String query) async {
    state = const AsyncLoading();
    state = AsyncValue.data(
        await ref.read(exercisesListSearchProvider(query).future));
  }
}

final searchControllerProvider =
    AsyncNotifierProvider.autoDispose<SearchController, List<Exercise>>(() {
  return SearchController();
});
