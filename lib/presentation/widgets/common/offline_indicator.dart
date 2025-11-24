import 'package:flutter/material.dart';

/// [OfflineIndicator] is a simple widget that displays a banner to inform
/// the user that they are currently offline.
///
/// It's designed to be shown conditionally at the top or bottom of a screen
/// when no internet connection is detected.
class OfflineIndicator extends StatelessWidget {
  const OfflineIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Using the theme's error color provides good visual feedback for a problem state.
    final errorColor = theme.colorScheme.error;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      color: errorColor,
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.cloud_off_outlined,
            color: Colors.white,
            size: 20,
          ),
          SizedBox(width: 12.0),
          Text(
            'You are currently offline',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}