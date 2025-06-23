import 'package:fitness_ui/src/common/async_value_widget.dart';
import 'package:fitness_ui/src/common/typography.dart';
import 'package:fitness_ui/src/features/routines/data/routines_repository.dart';
import 'package:fitness_ui/src/features/routines/domain/routine.dart';
import 'package:fitness_ui/src/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class RoutinesList extends ConsumerWidget {
  const RoutinesList({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routines = ref.watch(routineListFutureProvider);

    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Column(
            children: [
              ListSection(
                title: title,
                content: routines,
              ),
            ],
          ),
        )
      ],
    );
  }
}

class ListSection extends StatelessWidget {
  const ListSection({super.key, required this.title, required this.content});
  final String title;
  final AsyncValue content;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TitleHeader(text: title),
              AsyncValueWidget(
                value: content,
                data: (data) => ListSectionItem(items: data),
              ),
            ],
          ),
        )
      ],
    );
  }
}

class ListSectionItem extends StatelessWidget {
  const ListSectionItem({super.key, required this.items});
  final List<Routine?> items;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        return Column(
            children: items
                .map((item) => Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: ListTile(
                            visualDensity: VisualDensity(vertical: 4.0),
                            minVerticalPadding: 20,
                            leading: Container(
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0)),
                              child: Image.asset(
                                'assets/image${item!.id}.jpg',
                                fit: BoxFit.cover,
                                width: 130,
                                height: 120,
                              ),
                            ),
                            title: TextHeader(text: item.title),
                            subtitle: Text(
                                '${item.exercises.length.toString()} workouts'),
                            onTap: () {
                              ref
                                  .read(routinesRepositoryProvider)
                                  .getRoutineById(routineId: item.id);
                              context.goNamed(
                                AppRoute.workoutPlan.name,
                                pathParameters: {'id': item.id},
                              );
                            },
                          ),
                        ),
                      ],
                    ))
                .toList());
      },
    );
  }
}
