import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import '../../../core/models/persian_context.dart';
import '../../../core/models/word_data.dart';

/// [FlashcardWidget] is a flippable card used in review sessions.
///
/// The front of the card displays the word, and the back displays its
/// detailed information, including definition, examples, and Persian contexts.
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

  /// Builds the front side of the flashcard, showing only the word.
  Widget _buildFront(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(16),
      child: Center(
        child: Text(
          wordData.word,
          style: theme.textTheme.displaySmall
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  /// Builds the back side of the flashcard, showing detailed information.
  Widget _buildBack(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(wordData.word, style: theme.textTheme.headlineMedium),
            Text(
              wordData.pronunciation ?? '',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurface.withAlpha((0.7 * 255).round()),
              ),
            ),
            const Divider(height: 32),
            if (wordData.definitions?.isNotEmpty ?? false)
              _buildSection(
                context,
                'Definition',
                wordData.definitions!.map((d) => d.meaning).join('\n'),
              ),
            if (wordData.synonyms?.isNotEmpty ?? false)
              _buildSection(context, 'Synonyms', wordData.synonyms?.join(', ') ?? ''),
            _buildSection(
              context,
              'Example',
              wordData.example ?? '',
              isItalic: true,
            ),
            const Divider(height: 32),
            ...?wordData.persianContexts?.map(
              (ctx) => _buildPersianContext(context, ctx),
            ),
          ],
        ),
      ),
    );
  }

  /// Helper widget for creating a titled section.
  Widget _buildSection(BuildContext context, String title, String content,
      {bool isItalic = false}) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleSmall
                ?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.primary),
          ),
          const SizedBox(height: 4),
          Text(
            content,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the display for a single [PersianContext] object.
  Widget _buildPersianContext(BuildContext context, PersianContext ctx) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            ctx.meaning ?? '',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              fontFamily: 'Vazirmatn', // Assuming a Persian font is configured
            ),
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
            _buildSubDetail(context, 'Prepositions:', ctx.prepositionUsage!),
          ],
        ],
      ),
    );
  }

  /// Helper for rendering smaller details within a Persian context.
  Widget _buildSubDetail(BuildContext context, String title, String content) {
    final theme = Theme.of(context);
    return RichText(
      text: TextSpan(
        style: theme.textTheme.bodyMedium,
        children: [
          TextSpan(
            text: title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(text: ' $content'),
        ],
      ),
    );
  }
}
