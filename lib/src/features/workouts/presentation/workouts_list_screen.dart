import 'package:fitness_ui/src/features/workouts/presentation/workout_plans_list.dart';
import 'package:flutter/material.dart';

class WorkoutsListScreen extends StatelessWidget {
  const WorkoutsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Workouts'),
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
          WorkoutPlansList(),
          Placeholder(),
        ]),
      ),
    );
  }
}
