import 'package:fitness_ui/src/common/app_menu_widget.dart';
import 'package:fitness_ui/src/common/async_value_widget.dart';
import 'package:fitness_ui/src/common/typography.dart';
import 'package:fitness_ui/src/constants/constants.dart';
import 'package:fitness_ui/src/features/routines/application/routine_service.dart';
import 'package:fitness_ui/src/features/routines/presentation/forms/routine_add_form.dart';
import 'package:fitness_ui/src/features/routines/presentation/routine_details/public_routine_controller.dart';
import 'package:fitness_ui/src/features/routines/presentation/routine_details/routine_controller.dart';
import 'package:fitness_ui/src/features/routines/presentation/routine_details/exercise_item.dart';
import 'package:fitness_ui/src/features/routines/presentation/routines_list/routines_controller.dart';
import 'package:fitness_ui/src/routing/app_router.dart';
import 'package:fitness_ui/src/utils/routines_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class RoutineDetailScreen extends ConsumerStatefulWidget {
  const RoutineDetailScreen(
      {super.key, this.newRoutineTitle, this.showPublicRoutines});
  final String? newRoutineTitle;
  final bool? showPublicRoutines;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _RoutineDetailScreenState();
}

class _RoutineDetailScreenState extends ConsumerState<RoutineDetailScreen> {
  bool _isPublicRoutine = false;

  @override
  void initState() {
    super.initState();

    if (widget.showPublicRoutines != null) {
      setState(() {
        _isPublicRoutine = widget.showPublicRoutines!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final routineId = ref.watch(routineServiceProvider).getActiveRoutineId();
    final routineValue = _isPublicRoutine
        ? ref.watch(activePublicRoutineControllerProvider)
        : ref.watch(activeRoutineControllerProvider);

    void navigateBack() {
      context.pop();
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(
            SnackBar(content: Text('successfully deleted $routineId')));
    }

    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () {
                showModalBottomSheet(
                  showDragHandle: true,
                  context: context,
                  builder: (BuildContext context) {
                    return AppMenuWidget(menuItems: [
                      MenuItem(
                        RoutineMenu.add,
                        Icons.add_circle_outline,
                        () => context.pushNamed(AppRoute.search.name),
                      ),
                      MenuItem(RoutineMenu.edit, Icons.edit, () {
                        showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) {
                              return RoutineAddForm(isUpdateForm: true);
                            });
                      }),
                      MenuItem(
                        RoutineMenu.remove,
                        Icons.remove_circle_outline,
                        () async {
                          bool isDeleted = await ref
                              .read(routinesControllerProvider.notifier)
                              .deleteRoutine(routineId!);
                          if (mounted && isDeleted) {
                            navigateBack();
                          }
                        },
                      ),
                    ]);
                  },
                );
              },
              icon: Icon(Icons.more_horiz_rounded),
            ),
          ],
        ),
        body: ListView(
          children: [
            Column(
              children: [
                AsyncValueWidget(
                    disabledLoading: true,
                    value: routineValue,
                    data: (routine) {
                      return Column(
                        children: [
                          Image.asset('assets/image_placeholder.jpg'),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                  padding: const EdgeInsets.only(left: 20.0),
                                  child: TitleHeader(widget.newRoutineTitle ??
                                      routine?.title ??
                                      '')),
                              Padding(
                                  padding: const EdgeInsets.only(left: 20.0),
                                  child: Text('exercise'.formatNounCount(
                                      routine?.exercises.length ?? 0))),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [],
                                ),
                              ),
                              Visibility(
                                  visible: !_isPublicRoutine,
                                  child: Column(
                                    children: [
                                      Visibility(
                                        visible:
                                            routine?.exercises.isNotEmpty ??
                                                false,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            children: [
                                              SizedBox(
                                                width: 450,
                                                height: 60,
                                                child: ElevatedButton(
                                                    onPressed: () {
                                                      // todo: implement start workout session
                                                    },
                                                    child: const TextHeader(
                                                        AppRoutine.start)),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Visibility(
                                        visible:
                                            routine?.exercises.isEmpty ?? true,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            children: [
                                              SizedBox(
                                                width: 450,
                                                height: 60,
                                                child: ElevatedButton(
                                                    onPressed: () => context
                                                        .pushNamed(AppRoute
                                                            .search.name),
                                                    child: const TextHeader(
                                                        AppRoutine.add)),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  )),
                              ExerciseItem(exercises: routine?.exercises ?? [])
                            ],
                          )
                        ],
                      );
                    })
              ],
            ),
          ],
        ));
  }
}
