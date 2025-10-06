import '../models/fsrs_card_data.dart';

/// A lightweight local scheduler stub that mimics spaced-repetition behavior.
/// This provides a compile-time safe placeholder until the full `fsrs`
/// integration is implemented. It uses a very simple SM-2-like heuristic.
class FsrsService {
  static final FsrsService _instance = FsrsService._internal();
  factory FsrsService() => _instance;
  FsrsService._internal();

  FsrsCardData createInitialCard({required String id}) {
    return FsrsCardData(
      id: id,
      dueDate: DateTime.now(),
      ease: 2.5,
      intervalDays: 1,
      repetitions: 0,
      difficulty: 1.0,
    );
  }

  /// Rating: 0 = Again, 1 = Hard, 2 = Good, 3 = Easy
  FsrsCardData scheduleNextCard(FsrsCardData current, int rating) {
    double ease = current.ease;
    int reps = current.repetitions;
    int interval = current.intervalDays;

    if (rating <= 0) {
      // Again: reset repetitions and short interval
      reps = 0;
      interval = 1;
      ease = (ease - 0.2).clamp(1.3, 2.5);
    } else if (rating == 1) {
      // Hard
      reps += 1;
      interval = (interval * 1.2).ceil();
      ease = (ease - 0.1).clamp(1.3, 3.0);
    } else if (rating == 2) {
      // Good
      reps += 1;
      interval = (interval * ease).ceil();
    } else {
      // Easy
      reps += 1;
      interval = (interval * ease * 1.3).ceil();
      ease = (ease + 0.15).clamp(1.3, 4.0);
    }

    return FsrsCardData(
      id: current.id,
      dueDate: DateTime.now().add(Duration(days: interval)),
      ease: ease,
      intervalDays: interval,
      repetitions: reps,
      difficulty: current.difficulty,
    );
  }
}
