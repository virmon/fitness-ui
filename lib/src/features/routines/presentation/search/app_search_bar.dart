import 'package:fitness_ui/src/features/routines/presentation/routine_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchBar extends ConsumerStatefulWidget {
  const SearchBar({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchBarState();
}

class _SearchBarState extends ConsumerState<ConsumerStatefulWidget> {
  final searchFormController = TextEditingController();
  String query = '';

  @override
  void initState() {
    super.initState();

    searchFormController.addListener(_onQueryChange);
  }

  @override
  void dispose() {
    searchFormController.dispose();
    super.dispose();
  }

  void _onQueryChange() {
    setState(() {
      query = searchFormController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: searchFormController,
      onEditingComplete: () {
        FocusManager.instance.primaryFocus?.unfocus();
        ref.watch(routineControllerProvider.notifier).searchExercises(query);
      },
      autofocus: true,
      style: TextStyle(color: Colors.white),
    );
  }
}
