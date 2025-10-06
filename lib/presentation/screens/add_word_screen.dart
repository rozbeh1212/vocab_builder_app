import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/word_notifier.dart';

class AddWordScreen extends ConsumerStatefulWidget {
  const AddWordScreen({super.key});

  @override
  ConsumerState<AddWordScreen> createState() => _AddWordScreenState();
}

class _AddWordScreenState extends ConsumerState<AddWordScreen> {
  final _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _submitWord() async {
    final word = _textController.text.trim();
    if (word.isEmpty) {
      return;
    }

    final wordNotifier = ref.read(wordNotifierProvider.notifier);
    await wordNotifier.addWord(word);

    if (mounted) {
      // Watch the state of the notifier to react to changes
      final currentWordState = ref.read(wordNotifierProvider);
      currentWordState.whenOrNull(
        error: (e, st) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        },
        data: (words) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('کلمه "$word" با موفقیت اضافه شد!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.of(context).pop();
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Word'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _textController,
              decoration: const InputDecoration(
                labelText: 'Enter a word',
                border: OutlineInputBorder(),
              ),
              autofocus: true,
            ),
            const SizedBox(height: 20),
            Consumer(
              builder: (context, ref, child) {
                final wordState = ref.watch(wordNotifierProvider);
                final isLoading = wordState.isLoading;
                return ElevatedButton(
                  onPressed: isLoading ? null : _submitWord,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Add Word'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

