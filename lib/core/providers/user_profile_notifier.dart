import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/user_profile.dart';
import '../services/cache_service.dart';

final userProfileNotifierProvider = AsyncNotifierProvider<UserProfileNotifier, UserProfile>(
  () => UserProfileNotifier(),
);

class UserProfileNotifier extends AsyncNotifier<UserProfile> {
  final CacheService _cacheService = CacheService.instance;
  final Uuid _uuid = const Uuid();

  @override
  Future<UserProfile> build() async {
    return _loadUserProfile();
  }

  Future<UserProfile> _loadUserProfile() async {
    final box = await _cacheService.userProfileBox;
    UserProfile? profile = box.get('current_user');

    if (profile == null) {
      profile = UserProfile(id: _uuid.v4());
      await box.put('current_user', profile);
    }
    return profile;
  }

  Future<void> updateExperience(int points) async {
    state = await AsyncValue.guard(() async {
      UserProfile currentProfile = state.value!;
      int newExperience = currentProfile.experiencePoints + points;
      int newLevel = currentProfile.level;

      // Simple leveling system: 100 XP per level
      while (newExperience >= newLevel * 100) {
        newExperience -= newLevel * 100;
        newLevel++;
        // TODO: Trigger achievement for leveling up
      }

      final updatedProfile = currentProfile.copyWith(
        experiencePoints: newExperience,
        level: newLevel,
      );
      await _cacheService.userProfileBox.then((box) => box.put('current_user', updatedProfile));
      return updatedProfile;
    });
  }

  Future<void> updateStreak() async {
    state = await AsyncValue.guard(() async {
      UserProfile currentProfile = state.value!;
      DateTime now = DateTime.now();
      DateTime today = DateTime(now.year, now.month, now.day);

      int newStreak = currentProfile.currentStreak;
      DateTime? lastLogin = currentProfile.lastLoginDate;

      if (lastLogin == null || lastLogin.isBefore(today.subtract(const Duration(days: 1)))) {
        // Streak broken or first login
        newStreak = 1;
      } else if (lastLogin.isAtSameMomentAs(today.subtract(const Duration(days: 1)))) {
        // Continue streak
        newStreak++;
      }
      // If lastLogin is today, streak doesn't change (already counted)

      final updatedProfile = currentProfile.copyWith(
        currentStreak: newStreak,
        lastLoginDate: today,
      );
      await _cacheService.userProfileBox.then((box) => box.put('current_user', updatedProfile));
      return updatedProfile;
    });
  }

  // Future<List<Achievement>> getAchievements() async {
  //   final box = await _cacheService.achievementsBox;
  //   return box.values.toList();
  // }

  // Future<void> addAchievement(Achievement achievement) async {
  //   final box = await _cacheService.achievementsBox;
  //   await box.put(achievement.id, achievement);
  //   // Optionally update state to reflect new achievement
  // }
}
