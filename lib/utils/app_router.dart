import 'package:flutter/material.dart';
import 'package:vocab_builder_app/core/models/word_srs.dart';
import '../presentation/screens/add_word_screen.dart';
import '../presentation/screens/review_screen.dart';
import '../presentation/screens/word_detail_screen.dart';
import '../presentation/screens/main_screen.dart';
import '../presentation/screens/settings_screen.dart';
import '../presentation/screens/statistics_dashboard_screen.dart';
import '../presentation/screens/dashboard_screen.dart';

class AppRouter {
  static const String mainRoute = '/';
  static const String addWordRoute = '/add_word';
  static const String reviewRoute = '/review';
  static const String wordDetailRoute = '/word_detail';
  static const String settingsRoute = '/settings';
  static const String statisticsRoute = '/statistics';
  static const String dashboardRoute = '/dashboard';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case mainRoute:
        return MaterialPageRoute(builder: (_) => const MainScreen());
      case addWordRoute:
        return MaterialPageRoute(
          builder: (_) => const AddWordScreen(),
          fullscreenDialog: true,
        );
      case reviewRoute:
        final args = settings.arguments as List<dynamic>?; // Expecting a list of words
        return MaterialPageRoute(builder: (_) => ReviewScreen(wordsToReview: args?.cast<WordSRS>() ?? []));
      case wordDetailRoute:
        final args = settings.arguments as String; // Assuming word is passed as a string
        return MaterialPageRoute(builder: (_) => WordDetailScreen(word: args));
      case settingsRoute:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());
      case statisticsRoute:
        return MaterialPageRoute(builder: (_) => const StatisticsDashboardScreen());
      case dashboardRoute:
        return MaterialPageRoute(builder: (_) => const DashboardScreen());
      default:
        return MaterialPageRoute(builder: (_) => const Text('Error: Unknown route'));
    }
  }
}