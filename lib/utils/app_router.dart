import 'package:flutter/material.dart';
import '../core/models/word_srs.dart';
import '../presentation/screens/add_word_screen.dart';
import '../presentation/screens/dashboard_screen.dart';
import '../presentation/screens/main_screen.dart';
import '../presentation/screens/review_screen.dart';
import '../presentation/screens/settings_screen.dart';
import '../presentation/screens/statistics_dashboard_screen.dart';
import '../presentation/screens/word_detail_screen.dart';
import '../presentation/screens/word_list_screen.dart'; // Import WordListScreen

/// [AppRouter] handles all navigation logic for the application.
///
/// This class uses named routes to provide a centralized and type-safe
/// way to navigate between screens. It defines route constants and a
/// generation method to handle route creation and argument passing.
class AppRouter {
  static const String mainRoute = '/';
  static const String addWordRoute = '/add_word';
  static const String reviewRoute = '/review';
  static const String wordDetailRoute = '/word_detail';
  static const String settingsRoute = '/settings';
  static const String statisticsRoute = '/statistics';
  static const String dashboardRoute = '/dashboard';
  static const String wordListRoute = '/word_list'; // Define wordListRoute

  /// Generates routes based on the provided [RouteSettings].
  ///
  /// Handles argument passing and provides a fallback error route for
  /// unknown or improperly configured routes.
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case mainRoute:
        return MaterialPageRoute(builder: (_) => const MainScreen());

      case addWordRoute:
        return MaterialPageRoute(
          builder: (_) => const AddWordScreen(),
          fullscreenDialog: true, // Present as a modal screen
        );

      case reviewRoute:
        final args = settings.arguments;
        if (args is List<WordSRS>) {
          return MaterialPageRoute(
              builder: (_) => ReviewScreen(wordsToReview: args));
        }
        return _errorRoute('Invalid arguments for review route.');

      case wordDetailRoute:
        final args = settings.arguments;
        if (args is String) {
          return MaterialPageRoute(builder: (_) => WordDetailScreen(word: args));
        }
        return _errorRoute('Word must be provided as a String.');

      case settingsRoute:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());

      case statisticsRoute:
        return MaterialPageRoute(
            builder: (_) => const StatisticsDashboardScreen());

      case dashboardRoute:
        return MaterialPageRoute(builder: (_) => const DashboardScreen());

      case wordListRoute: // Add route for WordListScreen
        return MaterialPageRoute(builder: (_) => const WordListScreen(category: 'default'));

      default:
        return _errorRoute('Unknown route: ${settings.name}');
    }
  }

  /// Returns a standardized error route widget.
  static Route<dynamic> _errorRoute(String message) {
    return MaterialPageRoute(
      builder: (_) {
        return Scaffold(
          appBar: AppBar(title: const Text('Routing Error')),
          body: Center(
            child: Text(message),
          ),
        );
      },
    );
  }
}
