import 'package:fitness_ui/src/common/date_provider.dart';

String formatDate(DateTime date, DateFormatOption format) {
  switch (format) {
    case DateFormatOption.mmddyyyy:
      return '${date.month.toString().padLeft(2, '0')}/'
             '${date.day.toString().padLeft(2, '0')}/'
             '${date.year}';
    case DateFormatOption.ddmmyyyy:
      return '${date.day.toString().padLeft(2, '0')}/'
             '${date.month.toString().padLeft(2, '0')}/'
             '${date.year}';
  }
}