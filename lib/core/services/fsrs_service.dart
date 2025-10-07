import 'dart:math';
import '../models/fsrs_card_data.dart';

/// [FsrsService] provides a placeholder implementation for a Free Spaced Repetition Scheduler.
///
/// This service uses a simplified algorithm inspired by SM-2 to calculate the next
/// review date for a card based on user performance. It is intended as a
/// compile-time safe stub until a full, more complex FSRS library is integrated.
class FsrsService {
  // Singleton pattern to ensure only one instance of the service exists.
  FsrsService._internal();
  static final FsrsService _instance = FsrsService._internal();
  factory FsrsService() => _instance;

  /// Creates the initial state for a new FSRS card.
  FsrsCardData createInitialCard({required String id}) {
    return FsrsCardData(
      id: id,
      dueDate: DateTime.now(),
      ease: 2.5, // Standard starting ease factor
      intervalDays: 1, // First review is scheduled for the next day
      repetitions: 0,
      difficulty: 1.0, // Neutral starting difficulty
    );
  }

  /// Schedules the next review for a card based on the user's rating.
  ///
  /// The rating system is as follows:
  /// - `0`: Again (Forgot the card completely)
  /// - `1`: Hard (Remembered, but with significant difficulty)
  /// - `2`: Good (Remembered with some effort)
  /// - `3`: Easy (Perfect recall)
  FsrsCardData scheduleNextCard(FsrsCardData current, int rating) {
    double ease = current.ease;
    int reps = current.repetitions;
    int interval = current.intervalDays;

    if (rating <= 0) { // "Again"
      reps = 0; // Reset repetition count
      interval = 1; // Schedule for tomorrow
      ease = (ease - 0.2).clamp(1.3, 4.0);
    } else {
      reps++;
      if (rating == 1) { // "Hard"
        interval = (interval * 1.2).ceil();
        ease = (ease - 0.15).clamp(1.3, 4.0);
      } else if (rating == 2) { // "Good"
        // Interval grows based on the current ease factor
        interval = (interval * ease).ceil();
        // No change in ease
      } else { // "Easy"
        interval = (interval * ease * 1.3).ceil(); // Bonus for easy recall
        ease = (ease + 0.15).clamp(1.3, 4.0);
      }
    }
    
    // Ensure interval doesn't become excessively long in this simple model
    interval = min(interval, 365); 

    return FsrsCardData(
      id: current.id,
      dueDate: DateTime.now().add(Duration(days: interval)),
      ease: ease,
      intervalDays: interval,
      repetitions: reps,
      difficulty: current.difficulty, // Difficulty is not adjusted in this simple model
    );
  }
}