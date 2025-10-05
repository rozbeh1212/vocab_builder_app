import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/models/word.dart';
import '../../core/services/word_service.dart';
import '../providers/word_provider.dart';
import 'word_detail_screen.dart';
import '../widgets/common/app_loader.dart';
import '../../utils/date_formatter.dart';

class WordListScreen extends StatefulWidget {
  final String category;
  const WordListScreen({super.key, required this.category});

  @override
  State<WordListScreen> createState() => _WordListScreenState();
}

class _WordListScreenState extends State<WordListScreen> {
  late Future<List<Word>> _wordsFuture;
  final WordService _wordService = WordService();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _wordsFuture = _wordService.loadWords(widget.category);
    // Removed provider load to avoid overriding asset list
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text.trim().toLowerCase();
    });
  }

  Future<void> _refresh() async {
    setState(() {
      _wordsFuture = _wordService.loadWords(widget.category);
    });
    await _wordsFuture;
  }

  Widget _buildSrsStatus(BuildContext context, WordProvider provider, String word) {
    final srsWord = provider.words.firstWhere((w) => w.word.toLowerCase() == word.toLowerCase());
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
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.category} Words'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: TextField(
              controller: _searchController,
              onChanged: (_) => _onSearchChanged(),
              decoration: InputDecoration(
                hintText: 'Search words',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _onSearchChanged();
                        },
                      )
                    : null,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                filled: true,
                fillColor: Theme.of(context).cardColor,
              ),
            ),
          ),
        ),
      ),
      body: Consumer<WordProvider>(
        builder: (context, provider, _) {
          return FutureBuilder<List<Word>>(
            future: _wordsFuture,
            builder: (context, snapshot) {
              // Debug: show snapshot state when something goes wrong
              if (snapshot.hasError) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.error_outline, size: 48, color: Colors.red),
                        const SizedBox(height: 12),
                        Text('Failed to load words from assets', style: Theme.of(context).textTheme.titleMedium),
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

              if (snapshot.connectionState == ConnectionState.waiting || 
                  provider.isLoading) {
                return const Center(child: AppLoader());
              }

              final allWords = snapshot.data ?? [];
              final words = _searchQuery.isEmpty
                  ? allWords
                  : allWords.where((w) => w.word.toLowerCase().contains(_searchQuery)).toList();

              if (words.isEmpty) {
                return RefreshIndicator(
                  onRefresh: _refresh,
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      const SizedBox(height: 120),
                      Center(child: Text('No words found', style: Theme.of(context).textTheme.titleMedium)),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 48.0),
                        child: ElevatedButton(
                          onPressed: _refresh,
                          child: const Text('Reload'),
                        ),
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: _refresh,
                child: ListView.separated(
                  itemCount: words.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final word = words[index];
                    final inSrs = provider.words.any((s) => s.word.toLowerCase() == word.word.toLowerCase());
                    return ListTile(
                      leading: CircleAvatar(child: Text(word.word[0].toUpperCase())),
                      title: Text(word.word, style: const TextStyle(fontWeight: FontWeight.w600)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (word.meaning != null) Text(word.meaning!),
                          if (inSrs) ...[const SizedBox(height: 4), _buildSrsStatus(context, provider, word.word)],
                        ],
                      ),
                      trailing: IconButton(
                        icon: inSrs ? const Icon(Icons.check_circle, color: Colors.green) : const Icon(Icons.add_circle_outline),
                        tooltip: inSrs ? 'Already in SRS' : 'Add to SRS',
                        onPressed: inSrs
                            ? null
                            : () async {
                                await provider.addWord(word.word);
                                if (provider.error != null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(provider.error!)),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Added "${word.word}" to SRS')),
                                  );
                                }
                              },
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WordDetailScreen(word: word.word),
                          ),
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