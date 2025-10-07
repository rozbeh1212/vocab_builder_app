import 'dart:math';
import '../models/word_srs.dart';

/// [SRSService] implements the SuperMemo 2 (SM-2) spaced repetition algorithm.
///
/// This class provides a static method to calculate the next review date for a word
/// based on the user's performance. The algorithm adjusts the interval between
/// reviews to optimize memory retention.
///
/// The SM-2 algorithm considers:
/// - The user's self-rated recall quality (1-5).
/// - The word's current repetition history and ease factor.
///
/// For more details on the algorithm, see: https://www.supermemo.com/en/archives1990-2015/english/ol/sm2
class SRSService {
  /// Calculates the next review data for a word based on the SM-2 algorithm.
  ///
  /// [wordSRS]: The word's current SRS data before this review.
  /// [quality]: The user's recall quality, where a lower value means poorer recall.
  ///            - 1: Hard (Forgot the word, reset progress).
  ///            - 3: Good (Remembered with some effort).
  ///            - 5: Easy (Perfect recall).
  ///
  /// Returns a new, updated [WordSRS] object with the next review schedule.
  static WordSRS sm2(WordSRS wordSRS, int quality) {
    // A quality score below 3 indicates failure to recall the information.
    if (quality < 3) {
      // Reset the repetition count to start over.
      const int newRepetition = 0;
      // Reset the interval to 1 day.
      const int newInterval = 1;
      // Decrease the E-Factor, but not below the minimum of 1.3.
      // A lower E-Factor means future intervals will grow more slowly.
      final double newEfactor = max(1.3, wordSRS.efactor - 0.2);

      return wordSRS.copyWith(
        repetition: newRepetition,
        interval: newInterval,
        efactor: newEfactor,
        dueDate: DateTime.now().add(Duration(days: newInterval)),
      );
    } else {
      // If recall was successful (quality >= 3)
      int newInterval;
      int newRepetition = wordSRS.repetition + 1;

      // Update the E-Factor based on the quality.
      // A higher quality means the E-Factor increases, leading to longer intervals.
      final double newEfactor = max(
        1.3,
        wordSRS.efactor + (0.1 - (5 - quality) * (0.08 + (5 - quality) * 0.02)),
      );

      // Determine the next interval based on the repetition number.
      if (newRepetition == 1) {
        newInterval = 1;
      } else if (newRepetition == 2) {
        newInterval = 6;
      } else {
        newInterval = (wordSRS.interval * newEfactor).round();
      }

      return wordSRS.copyWith(
        repetition: newRepetition,
        interval: newInterval,
        efactor: newEfactor,
        dueDate: DateTime.now().add(Duration(days: newInterval)),
      );
    }
  }
}
