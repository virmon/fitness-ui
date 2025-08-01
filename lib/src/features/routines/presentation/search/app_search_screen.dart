import 'package:fitness_ui/src/common/async_value_widget.dart';
import 'package:fitness_ui/src/common/typography.dart';
import 'package:fitness_ui/src/features/routines/data/fake_exercises_repository.dart';
import 'package:fitness_ui/src/features/routines/data/routines_repository.dart';
import 'package:fitness_ui/src/features/routines/domain/exercise.dart';
import 'package:fitness_ui/src/features/routines/presentation/forms/exercise_add_set_form.dart';
import 'package:fitness_ui/src/features/routines/presentation/routines_list/routines_list.dart';
import 'package:fitness_ui/src/features/routines/presentation/search/app_search_bar.dart';
import 'package:fitness_ui/src/features/routines/presentation/search/search_query_notifier.dart';
import 'package:flutter/material.dart' hide SearchBar;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AppSearchScreen extends StatelessWidget {
  final bool? shouldShowExercises;

  const AppSearchScreen({super.key, this.shouldShowExercises = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: AppSearchBar(),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: Center(
              child: GestureDetector(
                onTap: () => context.pop(),
                child: const Text('Cancel'),
              ),
            ),
          ),
        ],
      ),
      body: SearchResultList(
        shouldShowExercises: shouldShowExercises,
      ),
    );
  }
}

class SearchResultList extends ConsumerWidget {
  final bool? shouldShowExercises;

  const SearchResultList({super.key, this.shouldShowExercises = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final query = ref.watch(searchQueryNotifierProvider);
    final exercisesSearchResultAsync =
        ref.watch(exercisesListSearchProvider(query));
    final routinesSearchResultAsync =
        ref.watch(routinesListSearchProvider(query));

    return ListView(
      children: [
        Visibility(
          visible: !shouldShowExercises!,
          child: ListSection(
            title: query.isEmpty ? '' : 'Results for $query',
            content: routinesSearchResultAsync,
            showPublicRoutines: true,
          ),
        ),
        Visibility(
          visible: shouldShowExercises!,
          child: AsyncValueWidget(
            value: exercisesSearchResultAsync,
            data: (data) => SearchResultListItem(items: data),
          ),
        ),
      ],
    );
  }
}

class SearchResultListItem extends StatelessWidget {
  const SearchResultListItem({super.key, required this.items});
  final List<Exercise?> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: items.isEmpty
          ? [
              Center(
                  heightFactor: 2,
                  child: Column(
                    children: [
                      Icon(Icons.search_off),
                      TextHeader('No match results')
                    ],
                  ))
            ]
          : items
              .map(
                (exercise) => Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(0),
                      child: ListTile(
                        title: TextHeader(exercise!.title),
                        subtitle: Text(exercise.type),
                        trailing: IconButton(
                          onPressed: () {
                            showModalBottomSheet(
                                isDismissible: false,
                                showDragHandle: false,
                                enableDrag: false,
                                context: context,
                                builder: (BuildContext context) {
                                  return ExerciseAddSetForm(
                                    exercise: exercise,
                                  );
                                });
                          },
                          icon: Icon(Icons.add_circle),
                        ),
                      ),
                    ),
                  ],
                ),
              )
              .toList(),
    );
  }
}
