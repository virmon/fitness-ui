import 'package:fitness_ui/src/common/async_value_widget.dart';
import 'package:fitness_ui/src/common/global_loading_indicator.dart';
import 'package:fitness_ui/src/common/typography.dart';
import 'package:fitness_ui/src/features/routines/application/routine_service.dart';
import 'package:fitness_ui/src/features/routines/domain/routine.dart';
import 'package:fitness_ui/src/features/routines/presentation/routines_list/public_routines_controller.dart';
import 'package:fitness_ui/src/features/routines/presentation/routines_list/routines_controller.dart';
import 'package:fitness_ui/src/routing/app_router.dart';
import 'package:fitness_ui/src/utils/routines_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class RoutinesList extends ConsumerStatefulWidget {
  const RoutinesList({
    super.key,
    required this.title,
    this.showPublicRoutines = false,
  });
  final String title;
  final bool showPublicRoutines;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RoutinesListState();
}

class _RoutinesListState extends ConsumerState<RoutinesList> {
  bool _isPublicRoutine = false;

  @override
  void initState() {
    super.initState();

    setState(() {
      _isPublicRoutine = widget.showPublicRoutines;
    });
  }

  @override
  Widget build(BuildContext context) {
    final asyncRoutines = _isPublicRoutine
        ? ref.watch(publicRoutinesControllerProvider)
        : ref.watch(routinesControllerProvider);

    return RefreshIndicator(
      onRefresh: () async {
        HapticFeedback.heavyImpact();
        _isPublicRoutine
            ? await ref
                .read(publicRoutinesControllerProvider.notifier)
                .refreshRoutines()
            : await ref
                .read(routinesControllerProvider.notifier)
                .refreshRoutines();
      },
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              children: [
                ListSection(
                  title: widget.title,
                  content: asyncRoutines,
                  showPublicRoutines: widget.showPublicRoutines,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class ListSection extends StatelessWidget {
  const ListSection(
      {super.key,
      required this.title,
      required this.content,
      required this.showPublicRoutines});
  final String title;
  final AsyncValue content;
  final bool showPublicRoutines;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              title.isNotEmpty ? TitleHeader(title) : SizedBox(),
              AsyncValueWidget(
                value: content,
                data: (data) => ListSectionItem(
                    items: data, showPublicRoutines: showPublicRoutines),
              ),
            ],
          ),
        )
      ],
    );
  }
}

class ListSectionItem extends StatelessWidget {
  const ListSectionItem(
      {super.key, required this.items, required this.showPublicRoutines});
  final List<Routine?> items;
  final bool showPublicRoutines;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        return Column(
            children: items
                .sortLatestOnTop()
                .map((routine) => Column(
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
                                'assets/image_placeholder.jpg',
                                fit: BoxFit.cover,
                                width: 130,
                                height: 120,
                              ),
                            ),
                            title: TextHeader(routine!.title),
                            subtitle: Text('exercise'
                                .formatNounCount(routine.exercises.length)),
                            onTap: () {
                              final routineId = routine.id;
                              if (routineId != null) {
                                ref
                                    .read(routineServiceProvider)
                                    .setActiveRoutine(routine);
                                context.goNamed(AppRoute.routineDetail.name,
                                    queryParameters: {
                                      'showPublicRoutines':
                                          showPublicRoutines.toString()
                                    });
                                ref.read(loadingProvider.notifier).state = true;
                              }
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
