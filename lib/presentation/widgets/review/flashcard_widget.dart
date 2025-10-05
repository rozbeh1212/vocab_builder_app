import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import '../../../core/models/word_data.dart';

class FlashcardWidget extends StatelessWidget {
  final WordData wordData;

  const FlashcardWidget({super.key, required this.wordData});

  @override
  Widget build(BuildContext context) {
    return FlipCard(
      direction: FlipDirection.HORIZONTAL,
      front: _buildFront(context),
      back: _buildBack(context),
    );
  }

  Widget _buildFront(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(16),
      child: Center(
        child: Text(
          wordData.word,
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildBack(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(wordData.word, style: Theme.of(context).textTheme.headlineMedium),
            Text(wordData.pronunciation, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey)),
            const SizedBox(height: 16),
            Text('Definition:', style: Theme.of(context).textTheme.titleSmall),
            Text(wordData.definition),
            const SizedBox(height: 16),
            if (wordData.synonyms.isNotEmpty) ...[
              Text('Synonyms:', style: Theme.of(context).textTheme.titleSmall),
              Text(wordData.synonyms.join(', ')),
              const SizedBox(height: 16),
            ],
            Text('Example:', style: Theme.of(context).textTheme.titleSmall),
            Text(wordData.example, style: const TextStyle(fontStyle: FontStyle.italic)),
            const Divider(height: 32),
            ...wordData.persianContexts.map((ctx) => Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(ctx.meaning, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text(ctx.example, style: const TextStyle(color: Colors.black87, fontStyle: FontStyle.italic)),
                  if (ctx.usageNotes != null && ctx.usageNotes!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text('Usage Notes:', style: Theme.of(context).textTheme.labelSmall),
                    Text(ctx.usageNotes!),
                  ],
                  if (ctx.collocations != null && ctx.collocations!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text('Collocations:', style: Theme.of(context).textTheme.labelSmall),
                    Text(ctx.collocations!.join(', ')),
                  ],
                  if (ctx.prepositionUsage != null && ctx.prepositionUsage!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text('Preposition Usage:', style: Theme.of(context).textTheme.labelSmall),
                    Text(ctx.prepositionUsage!),
                  ],
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}