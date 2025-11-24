import 'package:flutter/material.dart';

/// [LoadingOverlay] displays a semi-transparent overlay with a loading indicator.
///
/// It's useful for showing progress during asynchronous operations that block
/// user interaction with the screen below.
class LoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final Widget child;

  const LoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // The main content of the screen.
        child,
        // The overlay is shown only when isLoading is true.
        if (isLoading)
          // A translucent black overlay to dim the background.
          const Opacity(
            opacity: 0.5,
            child: ModalBarrier(dismissible: false, color: Colors.black),
          ),
        if (isLoading)
          // The centered loading indicator.
          const Center(
            child: CircularProgressIndicator(),
          ),
      ],
    );
  }
}

/// A utility class for showing standardized [SnackBar] feedback.
///
/// This helps maintain a consistent look and feel for feedback messages
/// across the application.
class FeedbackSnackbar {
  /// Shows a [SnackBar] with a given message.
  static void show(
    BuildContext context, {
    required String message,
    bool isError = false,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    // Hide any currently displayed snackbar before showing a new one.
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: isError ? colorScheme.errorContainer : colorScheme.primaryContainer,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      action: SnackBarAction(
        label: 'Dismiss',
        textColor: isError ? colorScheme.onErrorContainer : colorScheme.onPrimaryContainer,
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
