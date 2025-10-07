import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/models/word.dart';
import '../../core/models/word_srs.dart';
import '../../core/providers/word_notifier.dart';
import '../../core/services/word_service.dart';
import '../../utils/app_router.dart';
import '../../utils/date_formatter.dart';
import '../widgets/common/app_loader.dart';

class WordListScreen extends ConsumerStatefulWidget {
  final String category;
  const WordListScreen({super.key, required this.category});

  @override
  ConsumerState<WordListScreen> createState() => _WordListScreenState();
}

class _WordListScreenState extends ConsumerState<WordListScreen> {
  // Future to load the master word list from assets (e.g., TOEFL, IELTS)
  late Future<List<Word>> _wordsFuture;
  final WordService _wordService = WordService();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadWordsFromAssets();
    _searchController.addListener(_onSearchChanged);
  }

  void _loadWordsFromAssets() {
    _wordsFuture = _wordService.loadWords(widget.category);
  }

  void _onSearchChanged() {
    if (_searchQuery != _searchController.text.trim()) {
      setState(() {
        _searchQuery = _searchController.text.trim().toLowerCase();
      });
    }
  }

  Future<void> _refresh() async {
    setState(() {
      _loadWordsFromAssets();
    });
    // Also refresh the SRS words from the cache
    await ref.refresh(wordNotifierProvider.future);
  }

  Widget _buildSrsStatus(BuildContext context, WordSRS srsWord) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.schedule,
          size: 14,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(width: 4),
        Text(
          srsWord.dueDate.reviewDateDisplay,
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.category} Words'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search words...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                        },
                      )
                    : null,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                filled: true,
                fillColor: theme.cardColor,
              ),
            ),
          ),
        ),
      ),
      body: Consumer(
        builder: (context, ref, _) {
          // Watch the user's SRS word list from the provider
          final srsWordState = ref.watch(wordNotifierProvider);
          final srsWords = srsWordState.value ?? [];

          return FutureBuilder<List<Word>>(
            future: _wordsFuture,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.error_outline, size: 48, color: Colors.red),
                        const SizedBox(height: 12),
                        Text('Failed to load words from assets', style: theme.textTheme.titleMedium),
                        const SizedBox(height: 8),
                        Text('${snapshot.error}', textAlign: TextAlign.center),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: _refresh,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                );
              }

              if (snapshot.connectionState == ConnectionState.waiting || srsWordState.isLoading) {
                return const Center(child: AppLoader());
              }

              final allWords = snapshot.data ?? [];
              final filteredWords = _searchQuery.isEmpty
                  ? allWords
                  : allWords.where((w) => w.word.toLowerCase().contains(_searchQuery)).toList();

              if (filteredWords.isEmpty) {
                return RefreshIndicator(
                  onRefresh: _refresh,
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      const SizedBox(height: 120),
                      Center(child: Text('No words found.', style: theme.textTheme.titleMedium)),
                    ],
                  ),
                );
              }

              // Create a lookup map for faster SRS status checks
              final srsWordsMap = {for (var srs in srsWords) srs.word.toLowerCase(): srs};

              return RefreshIndicator(
                onRefresh: _refresh,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: filteredWords.length,
                  separatorBuilder: (_, __) => const Divider(height: 1, indent: 16, endIndent: 16),
                  itemBuilder: (context, index) {
                    final word = filteredWords[index];
                    final srsData = srsWordsMap[word.word.toLowerCase()];
                    final isInSrs = srsData != null;

                    return ListTile(
                      leading: CircleAvatar(child: Text(word.word[0].toUpperCase())),
                      title: Text(word.word, style: const TextStyle(fontWeight: FontWeight.w600)),
                      subtitle: isInSrs ? _buildSrsStatus(context, srsData) : null,
                      trailing: IconButton(
                        icon: isInSrs
                            ? const Icon(Icons.check_circle, color: Colors.green)
                            : const Icon(Icons.add_circle_outline),
                        tooltip: isInSrs ? 'Added to your list' : 'Add to your list',
                        onPressed: isInSrs
                            ? null // Disable button if word is already in SRS
                            : () async {
                                final notifier = ref.read(wordNotifierProvider.notifier);
                                await notifier.addWord(word.word);
                                // The UI will update automatically via the provider watcher,
                                // but we can show a confirmation snackbar.
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Added "${word.word}" to your list.'),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                }
                              },
                      ),
                      onTap: () {
                        Navigator.of(context).pushNamed(
                          AppRouter.wordDetailRoute,
                          arguments: word.word,
                        );
                      },
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
