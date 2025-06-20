import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppNavigationBar extends StatelessWidget {
  const AppNavigationBar({Key? key, required this.navigationShell})
      : super(key: key ?? const ValueKey('AppNavigationBar'));
  final StatefulNavigationShell navigationShell;

  void _goBranch(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        destinations: const [
          NavigationDestination(
              label: 'Home',
              icon: Icon(
                Icons.dashboard,
                color: Colors.white70,
              )),
          NavigationDestination(
            label: 'Workouts',
            icon: Icon(
              Icons.fitness_center,
              color: Colors.white70,
            ),
          ),
          NavigationDestination(
              label: 'Profile',
              icon: Icon(
                Icons.person,
                color: Colors.white70,
              )),
        ],
        onDestinationSelected: _goBranch,
      ),
    );
  }
}
