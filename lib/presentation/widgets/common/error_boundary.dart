import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// A widget that displays a standardized, user-friendly error message.
///
/// This widget can be used in place of a widget that has failed to build
/// or to show an error state from a provider or future. It includes an
/// optional callback to allow the user to retry the failed action.
class ErrorDisplayWidget extends StatelessWidget {
  final String? message;
  final FlutterErrorDetails? details;
  final VoidCallback? onRetry;

  const ErrorDisplayWidget({
    super.key,
    this.message,
    this.details,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // In debug mode, show detailed exception information.
    final String errorMessage =
        kDebugMode ? (details?.exception.toString() ?? 'An unknown error occurred.') : (message ?? 'Something went wrong.');

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              color: theme.colorScheme.error,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              'Oops!',
              style: theme.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              errorMessage,
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}