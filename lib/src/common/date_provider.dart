import 'package:flutter_riverpod/flutter_riverpod.dart';

enum DateFormatOption { mmddyyyy, ddmmyyyy }

final dateFormatProvider = StateProvider<DateFormatOption>((ref) {
  return DateFormatOption.mmddyyyy;
});