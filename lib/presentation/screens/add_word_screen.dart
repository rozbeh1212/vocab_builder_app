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
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _submitWord() async {
    // Validate the form before proceeding
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final word = _textController.text.trim();
    final notifier = ref.read(wordNotifierProvider.notifier);

    // Show loading indicator immediately
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 16),
            Text('Adding word...'),
          ],
        ),
        duration: Duration(days: 1), // Keep it open until we hide it
      ),
    );

    await notifier.addWord(word);

    // Hide the loading snackbar
    if (mounted) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
    }

    // After the operation, check the result from the provider's state
    // and show appropriate feedback.
    if (mounted) {
      final currentState = ref.read(wordNotifierProvider);
      currentState.when(
        data: (_) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Word "$word" added successfully!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.of(context).pop();
        },
        error: (error, _) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: $error'),
              backgroundColor: Colors.red,
            ),
          );
        },
        loading: () {
          // This case should ideally not be hit if we handle loading state manually,
          // but it's good practice to have it.
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Listen to the provider to get real-time loading status
    final wordState = ref.watch(wordNotifierProvider);
    final isLoading = wordState.isLoading;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Word'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _textController,
                decoration: const InputDecoration(
                  labelText: 'Enter a word',
                  border: OutlineInputBorder(),
                ),
                autofocus: true,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a word.';
                  }
                  return null;
                },
                onFieldSubmitted: (_) => isLoading ? null : _submitWord(),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: isLoading ? null : _submitWord,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: isLoading
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 3,
                        ),
                      )
                    : const Text('Add Word'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}