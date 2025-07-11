import 'package:fitness_ui/src/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FitnessApp extends ConsumerWidget {
  const FitnessApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goRouter = ref.watch(goRouterProvider);
    return MaterialApp.router(
      routerConfig: goRouter,
      title: 'Fitness App',
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.indigo,
          ),
          primarySwatch: Colors.grey,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.black87,
            foregroundColor: Colors.white,
            elevation: 0,
          ),
          navigationBarTheme: NavigationBarThemeData(
            backgroundColor: Colors.black87,
            indicatorColor: Colors.white10,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigo,
              foregroundColor: Colors.white,
            ),
          ),
          tabBarTheme: TabBarThemeData(
            indicatorColor: Colors.indigo,
            splashFactory: NoSplash.splashFactory,
            labelColor: Colors.white,
            labelStyle: TextStyle(
              fontSize: 18,
            ),
            unselectedLabelStyle: TextStyle(
              fontSize: 16,
              color: Colors.white38,
            ),
          ),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: Colors.indigo,
            foregroundColor: Colors.white,
          )),
    );
  }
}
