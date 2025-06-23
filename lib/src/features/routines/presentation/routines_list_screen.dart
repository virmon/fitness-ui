import 'package:fitness_ui/src/features/routines/presentation/routines_list.dart';
import 'package:flutter/material.dart';

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
        ),
        body: TabBarView(children: [
          RoutinesList(title: 'My Routines'),
          RoutinesList(title: 'Explore'),
        ]),
        floatingActionButton: FloatingActionButton(
          onPressed: () => {
            // todo: open create new routine screen
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
