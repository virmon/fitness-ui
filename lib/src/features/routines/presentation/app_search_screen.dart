import 'package:fitness_ui/src/common/typography.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppSearchScreen extends StatelessWidget {
  const AppSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: SearchBar(),
        actions: [
          IconButton(onPressed: () => context.pop(), icon: Icon(Icons.cancel))
        ],
      ),
      body: SearchResultList(),
    );
  }
}

class SearchBar extends StatelessWidget {
  const SearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: true,
      style: TextStyle(color: Colors.white),
    );
  }
}

class SearchResultList extends StatelessWidget {
  const SearchResultList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SearchResultListItem(),
        SearchResultListItem(),
        SearchResultListItem(),
        SearchResultListItem(),
        SearchResultListItem(),
      ],
    );
  }
}

class SearchResultListItem extends StatelessWidget {
  const SearchResultListItem({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onLongPress: () => {},
      title: TextHeader(text: 'search result sample'),
      subtitle: Text('10 workouts'),
      trailing: IconButton(
        onPressed: () => {
          // todo: implement add to current routine plan
        },
        icon: Icon(Icons.add_circle),
      ),
    );
  }
}
