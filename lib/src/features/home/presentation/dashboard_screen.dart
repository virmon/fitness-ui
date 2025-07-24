import 'dart:developer';

import 'package:fitness_ui/src/features/authentication/application/auth_service.dart';
import 'package:fitness_ui/src/features/routines/data/routines_repository.dart';
import 'package:fitness_ui/src/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              context.pushNamed(AppRoute.profile.name);
            },
          )
        ],
        automaticallyImplyLeading: false,
      ),
      body: Consumer(
        builder: (BuildContext context, WidgetRef ref, Widget? child) {
          return Center(
            child: Column(children: [
              ElevatedButton(
                  onPressed: () async {
                    ref.watch(authServiceProvider).logout();
                  },
                  child: Text('Logout')),
              ElevatedButton(
                onPressed: () => context.go('/pose'),
                child: const Text("Start Pose Tracking"),
              )
            ]),
          );
        },
        child: Center(
          child: Column(
            children: [],
          ),
        ),
      ),
    );
  }
}
