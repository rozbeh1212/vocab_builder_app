import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import '../models/achievement.dart';
import '../models/common_collocation.dart';
import '../models/definition.dart';
import '../models/fsrs_card_data.dart';
import '../models/persian_context.dart';
import '../models/phrasal_verb.dart';
import '../models/preposition_usage.dart';
import '../models/user_profile.dart';
import '../models/word_data.dart';
import '../models/word_form.dart';
import '../models/word_srs.dart';

/// [CacheService] handles all local data persistence using the Hive database.
///
/// This service is a singleton responsible for:
/// - Initializing Hive and registering all necessary type adapters.
/// - Opening and managing various "boxes" (tables) for different data models.
/// - Providing a clean API for CRUD (Create, Read, Update, Delete) operations.
///
/// The service uses the following boxes:
/// - `word_srs_box`: Stores learning progress and review schedules ([WordSRS]).
/// - `word_details_box`: Caches detailed word information ([WordData]).
/// - `user_profile_box`: Stores user profile information like level and streak ([UserProfile]).
/// - `achievements_box`: Stores user achievements ([Achievement]).
class CacheService {
  static const _srsBoxName = 'word_srs_box';
  static const _detailsBoxName = 'word_details_box';
  static const _userProfileBoxName = 'user_profile_box';
  static const _achievementsBoxName = 'achievements_box';

  // Private constructor for the singleton pattern.
  CacheService._();
  static final CacheService instance = CacheService._();

  Box<WordSRS>? _srsBox;
  Box<WordData>? _detailsBox;
  Box<UserProfile>? _userProfileBox;
  Box<Achievement>? _achievementsBox;

  /// Initializes the Hive database.
  ///
  /// This must be called once at application startup (e.g., in `main.dart`)
  /// before any other database operations are performed.
  Future<void> init() async {
    developer.log('[CacheService] Initialization started.');
    // Initialize Hive with a platform-specific path.
    if (!kIsWeb) {
      final appDocumentDir = await getApplicationDocumentsDirectory();
      Hive.init(appDocumentDir.path);
    } else {
      await Hive.initFlutter();
    }

    // Register all necessary TypeAdapters to serialize/deserialize custom objects.
    _registerAdapters();
    developer.log('[CacheService] All adapters registered.');

    // Open boxes to make them available for read/write operations.
    _srsBox = await Hive.openBox<WordSRS>(_srsBoxName);
    _detailsBox = await Hive.openBox<WordData>(_detailsBoxName);
    _userProfileBox = await Hive.openBox<UserProfile>(_userProfileBoxName);
    _achievementsBox = await Hive.openBox<Achievement>(_achievementsBoxName);
    developer.log('[CacheService] All boxes opened.');
  }

  void _registerAdapters() {
    // User-related models
    if (!Hive.isAdapterRegistered(UserProfileAdapter().typeId)) {
      Hive.registerAdapter(UserProfileAdapter());
    }
    if (!Hive.isAdapterRegistered(AchievementAdapter().typeId)) {
      Hive.registerAdapter(AchievementAdapter());
    }

    // Word and definition models
    if (!Hive.isAdapterRegistered(WordDataAdapter().typeId)) {
      Hive.registerAdapter(WordDataAdapter());
    }
    if (!Hive.isAdapterRegistered(DefinitionAdapter().typeId)) {
      Hive.registerAdapter(DefinitionAdapter());
    }
    if (!Hive.isAdapterRegistered(PersianContextAdapter().typeId)) {
      Hive.registerAdapter(PersianContextAdapter());
    }
    if (!Hive.isAdapterRegistered(PhrasalVerbAdapter().typeId)) {
      Hive.registerAdapter(PhrasalVerbAdapter());
    }
    if (!Hive.isAdapterRegistered(WordFormAdapter().typeId)) {
      Hive.registerAdapter(WordFormAdapter());
    }
    if (!Hive.isAdapterRegistered(CommonCollocationAdapter().typeId)) {
      Hive.registerAdapter(CommonCollocationAdapter());
    }
    if (!Hive.isAdapterRegistered(PrepositionUsageAdapter().typeId)) {
      Hive.registerAdapter(PrepositionUsageAdapter());
    }

    // SRS models
    if (!Hive.isAdapterRegistered(WordSRSAdapter().typeId)) {
      Hive.registerAdapter(WordSRSAdapter());
    }
    if (!Hive.isAdapterRegistered(FsrsCardDataAdapter().typeId)) {
      Hive.registerAdapter(FsrsCardDataAdapter());
    }
  }

  /// Clears all data from all known boxes.
  Future<void> clearAllData() async {
    await _srsBox?.clear();
    await _detailsBox?.clear();
    await _userProfileBox?.clear();
    await _achievementsBox?.clear();
  }

  // --- SRS Data Operations ---

  Future<WordSRS?> getWordSRS(String word) async {
    return _srsBox?.get(word);
  }

  Future<void> saveWordSRS(WordSRS word) async {
    await _srsBox?.put(word.word, word);
  }

  Future<List<WordSRS>> getAllWordSRS() async {
    return _srsBox?.values.toList() ?? [];
  }

  // --- Word Details Data Operations ---

  Future<WordData?> getWordDetails(String word) async {
    return _detailsBox?.get(word);
  }

  Future<void> saveWordDetails(String word, WordData data) async {
    await _detailsBox?.put(word, data);
  }

  // --- User Profile Operations ---
  
  Future<UserProfile?> getUserProfile() async {
    return _userProfileBox?.get('current_user');
  }

  Future<void> saveUserProfile(UserProfile profile) async {
    await _userProfileBox?.put('current_user', profile);
  }
}
