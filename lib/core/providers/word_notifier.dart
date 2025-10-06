import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/word_srs.dart';
import '../services/cache_service.dart';
import '../services/gemini_service.dart';
import '../services/srs_service.dart';
import '../models/word_data.dart';

final wordNotifierProvider = AsyncNotifierProvider<WordNotifier, List<WordSRS>>(WordNotifier.new);

class WordNotifier extends AsyncNotifier<List<WordSRS>> {
  final CacheService _cacheService = CacheService.instance;
  final GeminiService _geminiService = GeminiService();

  @override
  Future<List<WordSRS>> build() async {
    // load words from cache at startup
    return await _cacheService.getAllWordSRS();
  }

  Future<void> addWord(String newWord) async {
    state = const AsyncValue.loading();

    try {
      final existingSrs = await _cacheService.getWordSRS(newWord);
      if (existingSrs != null) {
        // word already exists; reload list and exit
        state = AsyncValue.data(await _cacheService.getAllWordSRS());
        return;
      }

      WordData? wordData = await _cacheService.getWordDetails(newWord);
      if (wordData == null) {
        wordData = await _geminiService.getWordDetails(newWord);
      }

      if (wordData != null) {
        await _cacheService.saveWordDetails(newWord, wordData);

        final newSrsData = WordSRS(
          word: newWord,
          dueDate: DateTime.now(),
          repetition: 0,
          interval: 0,
          efactor: 2.5,
        );

        await _cacheService.saveWordSRS(newSrsData);
        state = AsyncValue.data(await _cacheService.getAllWordSRS());
      } else {
        // nothing found; reload to ensure UI state is consistent
        state = AsyncValue.data(await _cacheService.getAllWordSRS());
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateWordAfterReview(WordSRS word, int quality) async {
    try {
      final updatedWord = SRSService.sm2(word, quality);
      await _cacheService.saveWordSRS(updatedWord);

      final current = state.value ?? await _cacheService.getAllWordSRS();
      final idx = current.indexWhere((w) => w.word == updatedWord.word);
      if (idx != -1) {
        current[idx] = updatedWord;
      }
      state = AsyncValue.data(current);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
