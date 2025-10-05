import 'package:intl/intl.dart';

extension DateTimeFormatting on DateTime {
  String get reviewDateDisplay {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final date = DateTime(year, month, day);

    if (date.isBefore(today)) {
      return 'Due now';
    } else if (date == today) {
      return 'Due today';
    } else if (date == tomorrow) {
      return 'Due tomorrow';
    } else {
      final diff = date.difference(today).inDays;
      if (diff <= 7) {
        return 'Due in $diff days';
      } else {
        return 'Due ${DateFormat('MMM d').format(this)}';
      }
    }
  }

  String get shortTime {
    return DateFormat('HH:mm').format(this);
  }
}