import 'dart:math';

import '../models/word_srs.dart';

/// [SRSService] implements the SuperMemo 2 (SM2) spaced repetition algorithm.
///
/// The SM2 algorithm determines optimal intervals between word reviews based on:
/// * The user's self-rated performance (0-5)
/// * Previous review history
/// * Current learning phase
///
/// The algorithm adjusts:
/// * Interval: Time until next review
/// * E-Factor: Ease factor that influences interval growth
/// * Repetition count: Number of successful reviews
///
/// References:
/// * SuperMemo 2 Algorithm: https://www.supermemo.com/en/archives1990-2015/english/ol/sm2
/// * Spaced Repetition: https://en.wikipedia.org/wiki/Spaced_repetition
class SRSService {
  /// Calculates the next review data for a word based on the SM-2 algorithm.
  ///
  /// [wordSRS]: The word's current SRS data.
  /// [quality]: The user's recall quality (0-5). 0 is worst, 5 is best.
  /// Returns the updated WordSRS object.
  static WordSRS sm2(WordSRS wordSRS, int quality) {
    // Work on a copy to avoid unexpected side-effects.
    final updated = wordSRS.copyWith();

    if (quality < 3) {
      // If recall quality is low, reset repetitions and set short interval.
      updated.repetition = 0;
      updated.interval = 1;
      // Efactor drops slightly on failures, but shouldn't go below 1.3
      updated.efactor = max(1.3, updated.efactor - 0.2);
    } else {
      // Update efactor based on quality using SM-2 formula
      final double newEfactor = updated.efactor + (0.1 - (5 - quality) * (0.08 + (5 - quality) * 0.02));
      updated.efactor = max(1.3, newEfactor);

      if (updated.repetition == 0) {
        updated.interval = 1;
      } else if (updated.repetition == 1) {
        updated.interval = 6;
      } else {
        updated.interval = max(1, (updated.interval * updated.efactor).round());
      }

      updated.repetition = updated.repetition + 1;
    }

    // Set the next due date.
    updated.dueDate = DateTime.now().add(Duration(days: updated.interval));

    return updated;
  }
}