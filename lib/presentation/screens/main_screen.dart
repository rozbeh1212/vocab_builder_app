import 'package:flutter/material.dart';
import '../widgets/common/main_navigation.dart';
import 'home_screen.dart';
import 'dashboard_screen.dart';
import 'statistics_dashboard_screen.dart';
import 'settings_screen.dart';

/// [MainScreen] is the root screen that hosts the main sections of the app,
/// accessible via a bottom navigation bar.
///
/// It uses an [IndexedStack] to preserve the state of each screen as the user
/// navigates between them.
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  // A list of the widgets to display for each navigation item.
  // Using const here is efficient as the screen instances themselves don't change.
  final List<Widget> _screens = const [
    HomeScreen(),
    DashboardScreen(),
    StatisticsDashboardScreen(),
    SettingsScreen(),
  ];

  /// Handles tap events on the bottom navigation bar.
  void _onNavigationTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // IndexedStack is used to maintain the state of each screen when switching tabs.
      // This is more efficient than PageView for this type of navigation.
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: MainNavigation(
        currentIndex: _currentIndex,
        onTap: _onNavigationTap,
      ),
    );
  }
}