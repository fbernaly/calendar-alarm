import 'package:intl/intl.dart';

String formatDate(DateTime date) {
  return '${DateFormat.yMMMEd().format(date)}, ${DateFormat('jm').format(date)}';
}

String formatRange(DateTime from, DateTime to) {
  return '${DateFormat.yMMMEd().format(from)}, ${DateFormat('jm').format(from)} - ${DateFormat('jm').format(to)}';
}
