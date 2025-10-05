import 'package:flutter/material.dart';
import '../../../core/models/word_data.dart';

class WordDetailsDisplay extends StatelessWidget {
  final WordData wordData;
  const WordDetailsDisplay({super.key, required this.wordData});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(wordData.word, 
                              style: Theme.of(context).textTheme.headlineMedium
                                ?.copyWith(fontWeight: FontWeight.bold)
                            ),
                            Text(wordData.pronunciation, 
                              style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(color: Colors.grey)
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.volume_up),
                        onPressed: () {
                          // TODO: Implement TTS for pronunciation
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Coming soon: Word pronunciation'))
                          );
                        },
                        tooltip: 'Listen to pronunciation',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
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
    );
  }
}