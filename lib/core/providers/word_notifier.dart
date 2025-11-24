import 'dart:developer' as developer; // Import for logging
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/word_data.dart';
import '../models/definition.dart';
import '../models/word_srs.dart';
import '../models/word_form.dart';
import '../models/phrasal_verb.dart';
import '../models/persian_context.dart';
import '../services/cache_service.dart';
import '../services/default_word_service.dart'; // Import DefaultWordService
import '../services/gemini_service.dart'; // Import GeminiService
import '../services/srs_service.dart';

/// Provides an asynchronous notifier for managing the list of [WordSRS] objects.
///
/// This provider handles loading words from the cache, adding new words by fetching
/// details from an external service, and updating words after a review session.
final wordNotifierProvider =
    AsyncNotifierProvider<WordNotifier, List<WordSRS>>(WordNotifier.new);

class WordNotifier extends AsyncNotifier<List<WordSRS>> {
  final CacheService _cacheService = CacheService.instance;
  final DefaultWordService _defaultWordService = DefaultWordService(); // Instantiate DefaultWordService
  final GeminiService _geminiService = GeminiService(); // Instantiate GeminiService

  /// The build method is called when the provider is first read.
  /// It initializes the state by loading all SRS words from the local cache.
  @override
  Future<List<WordSRS>> build() async {
    return _cacheService.getAllWordSRS();
  }

  /// Helper method to add a list of words, handling duplicates and fetching details.
  Future<void> _addWordsFromList(List<String> words) async {
    state = const AsyncValue.loading(); // Set state to loading for the batch operation
    try {
      List<WordSRS> currentWords = state.value ?? [];
      final List<WordSRS> wordsToAdd = [];

      for (final word in words) {
        final normalizedWord = word.trim().toLowerCase();
        if (normalizedWord.isEmpty) continue;

        // Check if word already exists
        if (currentWords.any((w) => w.word.toLowerCase() == normalizedWord) ||
            wordsToAdd.any((w) => w.word.toLowerCase() == normalizedWord)) {
          continue; // Skip if already exists or already in the current batch to add
        }

        WordData? wordData = await getWordDetails(normalizedWord);
        if (wordData != null) {
          final newSrsData = WordSRS(
            word: wordData.word,
            dueDate: DateTime.now(),
            repetition: 0,
            interval: 0,
            efactor: 2.5,
          );
          wordsToAdd.add(newSrsData);
        } else {
          developer.log('Failed to fetch details for word: $normalizedWord. Skipping addition.', name: 'WordNotifier');
          // Do not add the word if details cannot be fetched to prevent "ghost cards"
        }
      }

      if (wordsToAdd.isNotEmpty) {
        await Future.wait(wordsToAdd.map((w) => _cacheService.saveWordSRS(w)));
        state = AsyncValue.data([...currentWords, ...wordsToAdd]);
      } else {
        state = AsyncValue.data(currentWords); // Restore previous state if no new words were added
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Loads the default list of words from the asset file.
  Future<void> loadDefaultWords() async {
    final defaultWords = await _defaultWordService.loadWordsFromAsset('assets/data/default_words.json');
    await _addWordsFromList(defaultWords);
  }

  /// Loads IELTS words from the asset file and adds them to the vocabulary.
  Future<void> loadIeltsWords() async {
    final ieltsWords = await _defaultWordService.loadWordsFromAsset('assets/data/ielts_words.json');
    await _addWordsFromList(ieltsWords);
  }

  /// Loads TOEFL words from the asset file and adds them to the vocabulary.
  Future<void> loadToeflWords() async {
    final toeflWords = await _defaultWordService.loadWordsFromAsset('assets/data/toefl_words.json');
    await _addWordsFromList(toeflWords);
  }

  /// Adds a new word to the user's vocabulary list.
  ///
  /// It first checks if the word already exists. If not, it fetches word details
  /// from the Gemini service, caches them, creates a new SRS entry, and updates the state.
  Future<void> addWord(String newWord) async {
    final normalizedWord = newWord.trim().toLowerCase();
    if (normalizedWord.isEmpty) return;

    // For single word addition, we can reuse the existing logic
    // but ensure it doesn't interfere with batch loading state.
    final previousState = state;
    state = const AsyncValue.loading();

    try {
      final normalizedWord = newWord.trim().toLowerCase();
      if (normalizedWord.isEmpty) {
        state = previousState; // Restore state if input is empty
        return;
      }

      final existingWords = previousState.value ?? [];
      if (existingWords.any((w) => w.word.toLowerCase() == normalizedWord)) {
        state = previousState; // Restore previous data state if word already exists
        return;
      }

      WordData? wordData = await getWordDetails(normalizedWord);

      if (wordData != null) {
        final newSrsData = WordSRS(
          word: wordData.word,
          dueDate: DateTime.now(),
          repetition: 0,
          interval: 0,
          efactor: 2.5,
        );

        await _cacheService.saveWordSRS(newSrsData);
        state = AsyncValue.data([...existingWords, newSrsData]);
      } else {
        developer.log('Failed to fetch details for word: $normalizedWord. Not adding to vocabulary.', name: 'WordNotifier');
        state = previousState; // Restore previous state if word details could not be fetched
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Updates a word's SRS data after a user review.
  ///
  /// [word]: The [WordSRS] object to be updated.
  /// [quality]: An integer (0-5) representing the user's recall quality.
  Future<void> updateWordAfterReview(WordSRS word, int quality) async {
    final currentWords = state.valueOrNull;
    if (currentWords == null) return; // Cannot update if state is not loaded

    try {
      // 1. Calculate the new SRS parameters using the SM2 algorithm.
      final updatedWord = SRSService.sm2(word, quality);

      // 2. Save the updated data to the cache.
      await _cacheService.saveWordSRS(updatedWord);

      // 3. Update the state in memory for immediate UI feedback.
      final index = currentWords.indexWhere((w) => w.word == updatedWord.word);
      if (index != -1) {
        final updatedList = List<WordSRS>.from(currentWords);
        updatedList[index] = updatedWord;
        state = AsyncValue.data(updatedList);
      }
    } catch (e, st) {
      // If update fails, set the state to error.
      state = AsyncValue.error(e, st);
    }
  }

  /// Retrieves details for a given word.
  ///
  /// It first attempts to load from the local cache. If not found, it fetches
  /// from the [GeminiService] and caches the result for future use.
  Future<WordData?> getWordDetails(String word) async {
    try {
      // 1. Try to get details from the cache.
      WordData? details = await _cacheService.getWordDetails(word);
      if (details != null) {
        developer.log('Word details for "$word" found in cache.', name: 'WordNotifier');
        return details;
      }

      // 2. If not in cache, try to fetch from local JSON assets.
      final Map<String, dynamic>? raw = await _defaultWordService.loadWordDetails(word);
      if (raw != null) {
        details = _mapToWordData(raw);
        if (details != null) {
          await _cacheService.saveWordDetails(word, details);
          developer.log('Word details for "$word" found in local JSON and cached.', name: 'WordNotifier');
          return details;
        }
      }

      // 3. If not in local JSON, fetch from Gemini API.
      developer.log('Fetching word details for "$word" from Gemini API.', name: 'WordNotifier');
      details = await _geminiService.getWordDetails(word);
      if (details != null) {
        await _cacheService.saveWordDetails(word, details);
        developer.log('Word details for "$word" fetched from Gemini API and cached.', name: 'WordNotifier');
        return details;
      }

      // If all attempts fail, return null.
      developer.log('Failed to fetch word details for "$word" from any source.', name: 'WordNotifier');
      return null;
    } catch (e, st) {
      developer.log(
        'Error in getWordDetails for word: $word',
        error: e,
        stackTrace: st,
        name: 'WordNotifier',
      );
      return null;
    }
  }

  /// Converts a raw JSON-like map into a [WordData] instance.
  WordData _mapToWordData(Map<String, dynamic> raw) {
    // Pronunciation/phonetic
    final pronunciation = raw['phonetic'] as String? ?? raw['pronunciation'] as String?;

    // Definitions: list of strings -> List<Definition>
    final defs = <Definition>[];
    final defsFromJson = raw['definitions'] as List<dynamic>?;
    if (defsFromJson != null) {
      for (final d in defsFromJson) {
        if (d is String) {
          defs.add(Definition(partOfSpeech: '', meaning: d, example: ''));
        } else if (d is Map<String, dynamic>) {
          defs.add(Definition(
            partOfSpeech: d['partOfSpeech'] as String? ?? '',
            meaning: d['meaning'] as String? ?? '',
            example: d['example'] as String? ?? '',
          ));
        }
      }
    }

    // Synonyms/Antonyms
    final synonyms = (raw['synonyms'] as List?)?.whereType<String>().toList();
    final antonyms = (raw['antonyms'] as List?)?.whereType<String>().toList();

    // Word family -> wordForms
    final wordForms = <WordForm>[];
    final wf = raw['wordFamily'] as List?;
    if (wf != null) {
      for (final item in wf) {
        if (item is Map<String, dynamic>) {
          wordForms.add(WordForm(
            formType: item['partOfSpeech'] as String? ?? '',
            word: item['word'] as String? ?? '',
            meaning: null,
            example: null,
          ));
        }
      }
    }

    // Phrasal verbs
    final phrasalVerbs = <PhrasalVerb>[];
    final pv = raw['phrasalVerbs'] as List?;
    if (pv != null) {
      for (final item in pv) {
        if (item is Map<String, dynamic>) {
          phrasalVerbs.add(PhrasalVerb(
            verb: item['verb'] as String? ?? '',
            meaning: item['meaning'] as String? ?? '',
            example: item['example'] as String? ?? '',
          ));
        }
      }
    }

    // Persian contexts: use persianMeaning + usageNote + collocations
    final persianContexts = <PersianContext>[];
    final persianMeaning = raw['persianMeaning'] as String?;
    if (persianMeaning != null && persianMeaning.isNotEmpty) {
      persianContexts.add(PersianContext(
        meaning: persianMeaning,
        example: (raw['exampleSentences'] as List?)?.isNotEmpty == true
            ? (raw['exampleSentences'] as List).first as String? ?? ''
            : raw['example'] as String? ?? '',
        usageNotes: raw['usageNote'] as String?,
        collocations: (raw['collocations'] as List?)?.whereType<String>().toList(),
        prepositionUsage: null,
      ));
    }

    // Audio: prefer US then UK
    String? audioUrl;
    final audioMap = raw['audioUrls'] as Map?;
    if (audioMap != null) {
      audioUrl = (audioMap['us'] as String?) ?? (audioMap['uk'] as String?);
    }

    // Example: take the first example sentence if available
    String? example;
    final examples = (raw['exampleSentences'] as List?)?.whereType<String>().toList();
    if (examples != null && examples.isNotEmpty) example = examples.first;
    example ??= raw['example'] as String?;

    final cefrLevel = raw['cefrLevel'] as String?;
    final usageNote = raw['usageNote'] as String?;

    // Convert audioMap to Map<String,String> if present
    Map<String, String>? audioUrlsMap;
    if (audioMap != null) {
      audioUrlsMap = {};
      audioMap.forEach((k, v) {
        if (v is String) audioUrlsMap![k.toString()] = v;
      });
    }

    return WordData(
      word: raw['word'] as String? ?? '',
      meaning: raw['persianMeaning'] as String? ?? raw['meaning'] as String?,
      example: example,
      pronunciation: pronunciation,
      synonyms: synonyms,
      antonyms: antonyms,
      imageUrl: null,
      audioUrl: audioUrl,
      definitions: defs.isNotEmpty ? defs : null,
      persianContexts: persianContexts.isNotEmpty ? persianContexts : null,
      phrasalVerbs: phrasalVerbs.isNotEmpty ? phrasalVerbs : null,
      wordForms: wordForms.isNotEmpty ? wordForms : null,
      mnemonic: usageNote,
      cefrLevel: cefrLevel,
      audioUrls: audioUrlsMap,
    );
  }
}
