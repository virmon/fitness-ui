import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchQueryNotifier extends AutoDisposeNotifier<String> {
  Timer? _debounceTimer;

  @override
  String build() {
    ref.onDispose(() {
      _debounceTimer?.cancel();
    });
    return '';
  }

  void setQuery(String query) {
    if (_debounceTimer != null) {
      _debounceTimer!.cancel();
    }
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      state = query;
    });
  }
}

final searchQueryNotifierProvider =
    NotifierProvider.autoDispose<SearchQueryNotifier, String>(() {
  return SearchQueryNotifier();
});
