import 'package:flutter_riverpod/flutter_riverpod.dart';

enum WeightUnit { lbs, kgs }

final weightUnitProvider = StateProvider<WeightUnit>((ref) => WeightUnit.lbs);