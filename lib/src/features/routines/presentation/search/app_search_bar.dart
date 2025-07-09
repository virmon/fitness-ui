import 'package:fitness_ui/src/features/routines/presentation/routine_controller.dart';
import 'package:fitness_ui/src/features/routines/presentation/search/search_query_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppSearchBar extends ConsumerStatefulWidget {
  const AppSearchBar({super.key});

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

  void _clearQuery() {
    searchFormController.clear();
    setState(() {
      query = '';
    });
    ref.read(searchQueryNotifierProvider.notifier).setQuery(query);
  }

  @override
  Widget build(BuildContext context) {
    final String searchBarHintText = 'Search';
    final double searchBarBorderRadius = 15.0;
    final double searchBarBottomPadding = 8.0;
    final double searchBarContentPadding = 10.0;

    ref.listen(
        routineControllerProvider,
        (_, state) => state.whenOrNull(
              error: (error, stackTrace) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(error.toString())),
                );
              },
            ));
    return Padding(
      padding: EdgeInsets.only(
        bottom: searchBarBottomPadding,
      ),
      child: TextFormField(
        controller: searchFormController,
        onEditingComplete: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        onChanged: (text) {
          ref.read(searchQueryNotifierProvider.notifier).setQuery(text);
        },
        autofocus: true,
        decoration: InputDecoration(
          filled: Theme.of(context).brightness == Brightness.light,
          fillColor: Colors.white,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(searchBarBorderRadius),
            borderSide: BorderSide(
              color: Colors.white54,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(searchBarBorderRadius),
            borderSide: BorderSide(
              color: Colors.white54,
            ),
          ),
          contentPadding: EdgeInsets.all(searchBarContentPadding),
          hintText: searchBarHintText,
          prefixIcon: const Icon(Icons.search),
          suffixIcon: Visibility(
              visible: searchFormController.text.isNotEmpty,
              child: IconButton(
                onPressed: _clearQuery,
                icon: const Icon(Icons.close),
              )),
        ),
      ),
    );
  }
}
