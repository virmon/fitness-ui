import 'package:fitness_ui/src/common/typography.dart';
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
                  return RoutineCreateForm();
                })
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

class RoutineCreateForm extends StatelessWidget {
  const RoutineCreateForm({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                right: 20,
                bottom: 20,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(onTap: () => context.pop(), child: Icon(Icons.close))
                ],
              ),
            ),
            const TitleHeader(text: 'Name your new Routine'),
            SizedBox(
              width: 350,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextField(
                  autofocus: true,
                  decoration: InputDecoration(
                    filled: true,
                    hintStyle: TextStyle(color: Colors.grey[800]),
                    hintText: "My workout plan",
                    fillColor: Colors.white10,
                  ),
                ),
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  // todo: create new routine
                  // todo: navigate to newly created routine
                },
                child: const Text('Create'))
          ],
        ),
      ),
    );
  }
}
