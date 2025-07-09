import 'package:fitness_ui/src/common/async_value_widget.dart';
import 'package:fitness_ui/src/common/typography.dart';
import 'package:fitness_ui/src/features/routines/domain/exercise.dart';
import 'package:fitness_ui/src/features/routines/presentation/forms/exercise_add_set_form.dart';
import 'package:fitness_ui/src/features/routines/presentation/routine_controller.dart';
import 'package:fitness_ui/src/features/routines/presentation/search/app_search_bar.dart';
import 'package:flutter/material.dart' hide SearchBar;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AppSearchScreen extends StatelessWidget {
  const AppSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: SearchBar(),
        actions: [
          IconButton(onPressed: () => context.pop(), icon: Icon(Icons.cancel))
        ],
      ),
      body: SearchResultList(),
    );
  }
}

class SearchResultList extends ConsumerWidget {
  const SearchResultList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchResults = ref.watch(routineControllerProvider);

    return ListView(
      children: [
        AsyncValueWidget(
          value: searchResults,
          data: (data) => SearchResultListItem(items: data),
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
          ? [Text('No data')]
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
