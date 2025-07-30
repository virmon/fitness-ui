import 'package:fitness_ui/src/features/routines/domain/routine.dart';

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }

  String formatNounCount(int count) {
    String text = this;
    if (count > 1 && !text.endsWith('s')) {
      text = '${text}s';
    }
    return '$count $text';
  }
}

extension RoutineExtension on Routine {
  bool togglePrivacy() {
    return !isPrivate;
  }
}

extension ListExtension on List<Routine?> {
  List sortLatestOnTop() {
    List<Routine?> list = this;
    list.sort((a, b) => b!.createdAt!.compareTo(a!.createdAt!));
    return list;
  }
}
