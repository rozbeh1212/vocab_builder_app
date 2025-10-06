import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

import '../models/persian_context.dart';
import '../models/word_data.dart';
import '../models/word_srs.dart';
import '../models/word.dart';
import '../models/fsrs_card_data.dart';
import '../models/user_profile.dart';
import '../models/achievement.dart';

/// [CacheService] handles all local data persistence using Hive database.
///
/// This service is responsible for:
/// * Managing word SRS (Spaced Repetition System) data
/// * Storing word details and translations
/// * Handling data caching and retrieval
/// * Managing database initialization and box operations
///
/// The service uses two main storage boxes:
/// * SRS Box: Stores learning progress and review scheduling
/// * Details Box: Stores word definitions, examples, and translations
///
/// Usage:
/// ```dart
/// final cache = CacheService.instance;
/// await cache.init(); // Must be called before any other operations
/// ```
class CacheService {
  // Box names act like table names in a traditional database.
  static const _srsBoxName = 'word_srs_box';
  static const _detailsBoxName = 'word_details_box';

  // Private constructor for Singleton pattern
  CacheService._();
  static final CacheService instance = CacheService._();

  /// Initializes Hive, registers adapters, and opens boxes.
  /// This MUST be called in main.dart before runApp().
  Box<WordSRS>? _srsBox;
  Box<WordData>? _detailsBox;
  // Box<FsrsCardData>? _cardsBox; // currently unused; keep open in future for FSRS cards
  Box<UserProfile>? _userProfileBox;
  Box<Achievement>? _achievementsBox;

  Future<void> init() async {
    // For web, Hive uses its own storage. For mobile, we need a path.
    if (!kIsWeb) {
      final appDocumentDir = await getApplicationDocumentsDirectory();
      await Hive.initFlutter(appDocumentDir.path);
    } else {
      await Hive.initFlutter();
    }

    // Register adapters
    if (!Hive.isAdapterRegistered(WordSRSAdapter().typeId)) {
      Hive.registerAdapter(WordSRSAdapter());
    }
    if (!Hive.isAdapterRegistered(WordDataAdapter().typeId)) {
      Hive.registerAdapter(WordDataAdapter());
    }
    if (!Hive.isAdapterRegistered(PersianContextAdapter().typeId)) {
      Hive.registerAdapter(PersianContextAdapter());
    }
    if (!Hive.isAdapterRegistered(FsrsCardDataAdapter().typeId)) {
      Hive.registerAdapter(FsrsCardDataAdapter());
    }
    if (!Hive.isAdapterRegistered(UserProfileAdapter().typeId)) {
      Hive.registerAdapter(UserProfileAdapter());
    }
    if (!Hive.isAdapterRegistered(AchievementAdapter().typeId)) {
      Hive.registerAdapter(AchievementAdapter());
    }

    // Only open boxes if they're not already open
    _srsBox = await Hive.openBox<WordSRS>(_srsBoxName);
    _detailsBox = await Hive.openBox<WordData>(_detailsBoxName);
    // Note: fsrs_cards_box opening is deferred until FSRS features are used.
    _userProfileBox = await Hive.openBox<UserProfile>('user_profile_box');
    _achievementsBox = await Hive.openBox<Achievement>('achievements_box');
  }

  Future<Box<WordSRS>> get srsBox async {
    if (_srsBox == null || !_srsBox!.isOpen) {
      _srsBox = await Hive.openBox<WordSRS>(_srsBoxName);
    }
    return _srsBox!;
  }

  Future<Box<WordData>> get detailsBox async {
    if (_detailsBox == null || !_detailsBox!.isOpen) {
      _detailsBox = await Hive.openBox<WordData>(_detailsBoxName);
    }
    return _detailsBox!;
  }

  Future<Box<UserProfile>> get userProfileBox async {
    if (_userProfileBox == null || !_userProfileBox!.isOpen) {
      _userProfileBox = await Hive.openBox<UserProfile>('user_profile_box');
    }
    return _userProfileBox!;
  }

  Future<Box<Achievement>> get achievementsBox async {
    if (_achievementsBox == null || !_achievementsBox!.isOpen) {
      _achievementsBox = await Hive.openBox<Achievement>('achievements_box');
    }
    return _achievementsBox!;
  }

  Future<List<Word>> getWords() async {
    final box = await srsBox;
    final List<Word> words = [];
    
    for (var wordSrs in box.values) {
      words.add(Word(
        word: wordSrs.word,
      ));
    }
    return words;
  }

  Future<void> clear() async {
    final srsBox = await this.srsBox;
    final detailsBox = await this.detailsBox;
    final userProfileBox = await this.userProfileBox;
    final achievementsBox = await this.achievementsBox;
    await srsBox.clear();
    await detailsBox.clear();
    await userProfileBox.clear();
    await achievementsBox.clear();
  }

  Future<void> addWord(Word word) async {
    final box = await srsBox;
    final wordSrs = WordSRS(
      word: word.word,
      dueDate: DateTime.now(),
    );
    await box.put(word.word, wordSrs);
  }

  // --- SRS Data Operations ---

  Future<WordSRS?> getWordSRS(String word) async {
    final box = await srsBox;
    return box.get(word);
  }

  Future<void> saveWordSRS(WordSRS word) async {
    final box = await srsBox;
    await box.put(word.word, word);
  }

  Future<List<WordSRS>> getAllWordSRS() async {
    final box = await srsBox;
    return box.values.toList();
  }

  // --- Word Details Data Operations ---

  Future<WordData?> getWordDetails(String word) async {
    final box = await detailsBox;
    return box.get(word);
  }

  Future<void> saveWordDetails(String word, WordData data) async {
    final box = await detailsBox;
    await box.put(word, data);
  }
}