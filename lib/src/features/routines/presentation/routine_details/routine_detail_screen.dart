import 'package:fitness_ui/src/common/app_menu_widget.dart';
import 'package:fitness_ui/src/common/async_value_widget.dart';
import 'package:fitness_ui/src/common/cover_image_widget.dart';
import 'package:fitness_ui/src/common/typography.dart';
import 'package:fitness_ui/src/constants/constants.dart';
import 'package:fitness_ui/src/features/routines/application/routine_service.dart';
import 'package:fitness_ui/src/features/routines/presentation/forms/routine_add_form.dart';
import 'package:fitness_ui/src/features/routines/presentation/routine_details/routine_action_panel.dart';
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
  final ScrollController _scrollController = ScrollController();
  bool _showTitle = false;

  @override
  void initState() {
    super.initState();

    if (widget.showPublicRoutines != null) {
      setState(() {
        _isPublicRoutine = widget.showPublicRoutines!;
      });
    }

    _scrollController.addListener(() {
      double currentScrollPosition = _scrollController.position.pixels;
      if (currentScrollPosition >= 230) {
        setState(() {
          _showTitle = true;
        });
      } else {
        setState(() {
          _showTitle = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final routineId = ref.watch(routineServiceProvider).getActiveRoutineId();
    final routineValue = _isPublicRoutine
        ? ref.watch(activePublicRoutineControllerProvider)
        : ref.watch(activeRoutineControllerProvider);

    Size screenSize = MediaQuery.of(context).size;
    double titleWidth = screenSize.width * 0.5;

    void navigateBack() {
      context.pop();
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(
            SnackBar(content: Text('successfully deleted $routineId')));
    }

    return Scaffold(
      body: AsyncValueWidget(
          disabledLoading: true,
          value: routineValue,
          data: (routine) {
            return CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverAppBar(
                  pinned: true,
                  expandedHeight: 260.0,
                  flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    title: AnimatedOpacity(
                      opacity: _showTitle ? 1 : 0,
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.ease,
                      child: SizedBox(
                        width: titleWidth,
                        child: TextHeader(
                            widget.newRoutineTitle ?? routine!.title),
                      ),
                    ),
                    background: CoverImageWidget(
                        coverImage: 'assets/image_placeholder.jpg'),
                  ),
                  actions: [
                    Visibility(
                      visible: !_isPublicRoutine,
                      child: IconButton(
                        onPressed: () {
                          showModalBottomSheet(
                            showDragHandle: true,
                            context: context,
                            builder: (BuildContext context) {
                              return StatefulBuilder(
                                builder: (context, setState) {
                                  return AppMenuWidget(menuItems: [
                                    MenuItem(
                                      RoutineMenu.add,
                                      Icons.add_circle_outline,
                                      () => context
                                          .pushNamed(AppRoute.search.name),
                                    ),
                                    MenuItem(
                                      routine!.isPrivate
                                          ? RoutineMenu.togglePublic
                                          : RoutineMenu.togglePrivate,
                                      routine.isPrivate
                                          ? Icons.public
                                          : Icons.lock,
                                      () => ref
                                          .read(routinesControllerProvider
                                              .notifier)
                                          .toggleRoutinePrivacy(routine),
                                    ),
                                    MenuItem(RoutineMenu.edit, Icons.edit, () {
                                      showModalBottomSheet(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return RoutineAddForm(
                                                isUpdateForm: true);
                                          });
                                    }),
                                    MenuItem(
                                      RoutineMenu.remove,
                                      Icons.remove_circle_outline,
                                      () async {
                                        bool isDeleted = await ref
                                            .read(routinesControllerProvider
                                                .notifier)
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
                          );
                        },
                        icon: Icon(Icons.more_horiz_rounded),
                      ),
                    ),
                  ],
                ),
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                              padding:
                                  const EdgeInsets.only(left: 10.0, top: 10.0),
                              child: TitleHeader(
                                  widget.newRoutineTitle ?? routine!.title)),
                          Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Text('exercise'
                                  .formatNounCount(routine!.exercises.length))),
                          Padding(
                              padding:
                                  const EdgeInsets.only(left: 10.0, top: 5.0),
                              child: routine.isPrivate
                                  ? Icon(Icons.lock)
                                  : Icon(Icons.public)),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [],
                            ),
                          ),
                          RoutineActionPanel(
                            isPublicRoutine: _isPublicRoutine,
                            routine: routine,
                          ),
                          ExerciseItem(
                            exercises: routine.exercises,
                            showOptions: !_isPublicRoutine,
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
    );
  }
}
