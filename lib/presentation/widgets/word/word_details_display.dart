import 'package:flutter/material.dart';
import '../../../core/models/persian_context.dart';
import '../../../core/models/word_data.dart';

/// [WordDetailsDisplay] is a widget responsible for rendering the detailed
/// information of a [WordData] object in a structured and readable format.
class WordDetailsDisplay extends StatelessWidget {
  final WordData wordData;
  const WordDetailsDisplay({super.key, required this.wordData});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const SizedBox(height: 24),
          _buildSectionTitle(context, 'Definition'),
          if (wordData.definitions?.isNotEmpty ?? false)
            ...wordData.definitions!.map((def) => Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    '• ${def.meaning}',
                    style: theme.textTheme.bodyLarge,
                  ),
                )),
          const SizedBox(height: 16),
          if (wordData.synonyms?.isNotEmpty ?? false) ...[
            _buildSectionTitle(context, 'Synonyms'),
            Text(wordData.synonyms?.join(', ') ?? '', style: theme.textTheme.bodyMedium),
            const SizedBox(height: 16),
          ],
          if (wordData.phrasalVerbs?.isNotEmpty ?? false) ...[
            _buildSectionTitle(context, 'Phrasal Verbs'),
            ...wordData.phrasalVerbs!.map((pv) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pv.verb,
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Meaning: ${pv.meaning}',
                    style: theme.textTheme.bodyMedium?.copyWith(fontStyle: FontStyle.italic),
                  ),
                  Text(
                    'Example: ${pv.example}',
                    style: theme.textTheme.bodyMedium?.copyWith(fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            )),
            const SizedBox(height: 16),
          ],
          if (wordData.wordForms?.isNotEmpty ?? false) ...[
            _buildSectionTitle(context, 'Word Forms'),
            ...wordData.wordForms!.map((form) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      style: theme.textTheme.bodyLarge,
                      children: [
                        TextSpan(
                          text: '${form.formType}: ',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(text: form.word),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Meaning: ${form.meaning}',
                    style: theme.textTheme.bodyMedium?.copyWith(fontStyle: FontStyle.italic),
                  ),
                  Text(
                    'Example: ${form.example}',
                    style: theme.textTheme.bodyMedium?.copyWith(fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            )),
            const SizedBox(height: 16),
          ],
          _buildSectionTitle(context, 'Example'),
          Text(
            wordData.example ?? '',
            style: theme.textTheme.bodyLarge?.copyWith(
              fontStyle: FontStyle.italic,
                color: theme.colorScheme.onSurface.withAlpha((0.8 * 255).round()),
            ),
          ),
          if (wordData.mnemonic?.isNotEmpty ?? false) ...[
            const Divider(height: 48),
            _buildSectionTitle(context, 'Memory Aid'),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.lightbulb_outline, color: theme.colorScheme.secondary, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    wordData.mnemonic!,
                    style: theme.textTheme.bodyLarge?.copyWith(fontStyle: FontStyle.italic),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
          const Divider(height: 48),
          _buildSectionTitle(context, 'Persian Contexts'),
          ...?wordData.persianContexts
              ?.map((ctx) => _buildPersianContext(context, ctx))
              .expand((widget) => [widget, const SizedBox(height: 20)]),
        ],
      ),
    );
  }

  /// Builds the header section with the word, pronunciation, and TTS button.
  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 0,
      color: theme.colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    wordData.word,
                    style: theme.textTheme.headlineMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    wordData.pronunciation ?? '',
                    style: theme.textTheme.titleMedium
           ?.copyWith(color: theme.colorScheme.onSurface.withAlpha((0.7 * 255).round())),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.volume_up_outlined),
              onPressed: () {
                // TODO: Implement Text-to-Speech functionality.
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Coming soon: Word pronunciation')),
                );
              },
              tooltip: 'Listen to pronunciation',
            ),
          ],
        ),
      ),
    );
  }

  /// Builds a standardized title for each section.
  Widget _buildSectionTitle(BuildContext context, String title) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: theme.textTheme.titleSmall?.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  /// Builds the display for a single [PersianContext] object.
  Widget _buildPersianContext(BuildContext context, PersianContext ctx) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          ctx.meaning ?? '',
          style: theme.textTheme.titleLarge
              ?.copyWith(fontWeight: FontWeight.bold, fontFamily: 'Vazirmatn'),
        ),
        const SizedBox(height: 4),
        Text(
          ctx.example ?? '',
          style: theme.textTheme.bodyLarge?.copyWith(
            fontStyle: FontStyle.italic,
            fontFamily: 'Vazirmatn',
              color: theme.colorScheme.onSurface.withAlpha((0.8 * 255).round()),
          ),
        ),
        if (ctx.usageNotes?.isNotEmpty ?? false) ...[
          const SizedBox(height: 8),
          _buildSubDetail(context, 'Usage Notes:', ctx.usageNotes!),
        ],
        if (ctx.collocations?.isNotEmpty ?? false) ...[
          const SizedBox(height: 4),
          _buildSubDetail(context, 'Collocations:', ctx.collocations!.join(', ')),
        ],
        if (ctx.prepositionUsage?.isNotEmpty ?? false) ...[
          const SizedBox(height: 4),
          _buildSubDetail(context, 'Preposition Usage:', ctx.prepositionUsage!),
        ],
      ],
    );
  }

  /// Helper widget for displaying sub-details like usage notes or collocations.
  Widget _buildSubDetail(BuildContext context, String title, String content) {
    final theme = Theme.of(context);
    return RichText(
      text: TextSpan(
        style: theme.textTheme.bodyMedium,
        children: [
          TextSpan(
            text: '$title ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(text: content),
        ],
      ),
    );
  }
}
