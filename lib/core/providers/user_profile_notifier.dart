import 'dart:developer' as developer;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import '../models/user_profile.dart';
import '../services/cache_service.dart';

/// Provides an asynchronous notifier for managing the user's [UserProfile].
///
/// This provider handles loading the user profile from the cache, creating a new one
/// if it doesn't exist, and updating user-specific data like experience points and streaks.
final userProfileNotifierProvider =
    AsyncNotifierProvider<UserProfileNotifier, UserProfile>(
  UserProfileNotifier.new,
);

class UserProfileNotifier extends AsyncNotifier<UserProfile> {
  final CacheService _cacheService = CacheService.instance;
  final Uuid _uuid = const Uuid();

  /// The build method initializes the user profile.
  /// It loads the profile from the cache or creates a new one if none exists.
  @override
  Future<UserProfile> build() async {
    try {
      final cachedProfile = await _cacheService.getUserProfile();

      if (cachedProfile != null) {
        return cachedProfile;
      }

      // If no profile exists, create a new one with a unique ID and save it.
      final newProfile = UserProfile(id: _uuid.v4());
      await _cacheService.saveUserProfile(newProfile);
      return newProfile;
    } on HiveError catch (e, st) {
      developer.log(
        '[UserProfileNotifier] HiveError while loading user profile: $e',
        error: e,
        stackTrace: st,
        name: 'UserProfileNotifier',
      );
      rethrow;
    }
  }

  /// Updates the user's experience points and handles leveling up.
  Future<void> updateExperience(int points) async {
    // Ensure the current state is loaded and valid before updating.
    final previousState = await future;
    
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      int newExperience = previousState.experiencePoints + points;
      int newLevel = previousState.level;

      // Simple leveling system: 100 XP required per level.
      while (newExperience >= newLevel * 100) {
        newExperience -= newLevel * 100;
        newLevel++;
        // TODO: Implement a mechanism to grant achievements for leveling up.
      }

      final updatedProfile = previousState.copyWith(
        experiencePoints: newExperience,
        level: newLevel,
      );
      
      await _cacheService.saveUserProfile(updatedProfile);
      return updatedProfile;
    });
  }

  /// Updates the user's daily login streak.
  Future<void> updateStreak() async {
    final previousState = await future;

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final now = DateTime.now();
      // Normalize to midnight to compare days accurately.
      final today = DateTime(now.year, now.month, now.day); 
      final lastLogin = previousState.lastLoginDate;

      int newStreak = previousState.currentStreak;

      if (lastLogin == null) {
        // First login ever.
        newStreak = 1;
      } else {
        final lastLoginDate = DateTime(lastLogin.year, lastLogin.month, lastLogin.day);
        final difference = today.difference(lastLoginDate).inDays;

        if (difference == 1) {
          // Consecutive day login, increment streak.
          newStreak++;
        } else if (difference > 1) {
          // Streak is broken, reset to 1.
          newStreak = 1;
        }
        // If difference is 0, it's the same day, so no change to streak.
      }
      
      final updatedProfile = previousState.copyWith(
        currentStreak: newStreak,
        lastLoginDate: today,
      );

      await _cacheService.saveUserProfile(updatedProfile);
      return updatedProfile;
    });
  }

  /// Sets a new daily review goal for the user.
  Future<void> setDailyGoal(int goal) async {
    final previousState = await future;

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final updatedProfile = previousState.copyWith(dailyReviewGoal: goal);
      await _cacheService.saveUserProfile(updatedProfile);
      return updatedProfile;
    });
  }

  /// Records the completion of a review, updating daily counts and streaks.
  Future<void> recordReviewCompletion() async {
    final previousState = await future;

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final lastLogin = previousState.lastLoginDate;

      int newReviewsCompletedToday = previousState.reviewsCompletedToday;
      int newStreak = previousState.currentStreak;

      // Check if it's a new day since the last login/review.
      if (lastLogin == null ||
          DateTime(lastLogin.year, lastLogin.month, lastLogin.day)
              .isBefore(today)) {
        // If it's a new day, reset reviewsCompletedToday.
        newReviewsCompletedToday = 0;
        // Also update streak logic for new day
        if (lastLogin == null) {
          newStreak = 1; // First review ever
        } else {
          final lastLoginDay = DateTime(lastLogin.year, lastLogin.month, lastLogin.day);
          final difference = today.difference(lastLoginDay).inDays;
          if (difference == 1) {
            newStreak++; // Consecutive day
          } else {
            newStreak = 1; // Streak broken, reset
          }
        }
      }

      newReviewsCompletedToday++; // Increment for the current review

      final updatedProfile = previousState.copyWith(
        reviewsCompletedToday: newReviewsCompletedToday,
        lastLoginDate: today,
        currentStreak: newStreak,
      );

      await _cacheService.saveUserProfile(updatedProfile);
      return updatedProfile;
    });
  }
}
