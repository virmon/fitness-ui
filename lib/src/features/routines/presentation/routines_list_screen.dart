import 'package:fitness_ui/src/features/routines/presentation/forms/routine_add_form.dart';
import 'package:fitness_ui/src/features/routines/presentation/routines_list.dart';
import 'package:fitness_ui/src/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RoutinesListScreen extends StatelessWidget {
  const RoutinesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Routines'),
          bottom: const TabBar(tabs: [
            Tab(
              child: Text('Me'),
            ),
            Tab(
              child: Text('Explore'),
            ),
          ]),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                context.pushNamed(AppRoute.search.name);
              },
            )
          ],
        ),
        body: TabBarView(children: [
          RoutinesList(title: 'My Routines'),
          RoutinesList(title: 'Explore'),
        ]),
        floatingActionButton: FloatingActionButton(
          onPressed: () => {
            showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return RoutineAddForm();
                })
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
