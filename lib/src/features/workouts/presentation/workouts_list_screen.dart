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

class CategorySection extends StatelessWidget {
  const CategorySection({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Placeholder(),
        ),
        Text(
          title,
          style: TextStyle(fontSize: 22),
        ),
      ],
    );
  }
}
