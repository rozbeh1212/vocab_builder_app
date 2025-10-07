import 'package:flutter/material.dart';

/// [AppLoader] is a simple, reusable widget for displaying a centered
/// circular progress indicator.
///
/// It is designed to be consistent with the application's theme by using
/// the primary color for the indicator.
class AppLoader extends StatelessWidget {
  const AppLoader({super.key});

  @override
  Widget build(BuildContext context) {
    // Using a themed CircularProgressIndicator ensures visual consistency.
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}