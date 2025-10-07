import 'package:intl/intl.dart';

/// An extension on [DateTime] to provide custom, human-readable date and time formatting.
extension DateTimeFormatting on DateTime {
  /// Provides a user-friendly string representation for review due dates.
  ///
  /// Examples:
  /// - A date in the past: "Due now"
  /// - Today: "Due today"
  /// - Tomorrow: "Due tomorrow"
  /// - Within a week: "Due in X days"
  /// - More than a week away: "Due MMM d" (e.g., "Due Oct 26")
  String get reviewDateDisplay {
    final now = DateTime.now();
    // Normalize dates to midnight to ensure accurate day comparisons.
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final dateToCompare = DateTime(year, month, day);

    if (dateToCompare.isBefore(today)) {
      return 'Due now';
    } else if (dateToCompare == today) {
      return 'Due today';
    } else if (dateToCompare == tomorrow) {
      return 'Due tomorrow';
    } else {
      final differenceInDays = dateToCompare.difference(today).inDays;
      if (differenceInDays <= 7) {
        return 'Due in $differenceInDays days';
      } else {
        // Use a standard format for dates further in the future.
        return 'Due ${DateFormat('MMM d').format(this)}';
      }
    }
  }

  /// Formats the time into a short "HH:mm" format (e.g., "21:30").
  String get shortTime {
    return DateFormat('HH:mm').format(this);
  }
}