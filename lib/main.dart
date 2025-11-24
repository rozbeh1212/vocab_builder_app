import 'dart:async';
import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'core/services/cache_service.dart';
import 'core/services/notification_service.dart'; // Import NotificationService
import 'utils/app_router.dart';
import 'utils/theme.dart';

/// Initializes essential application services before running the app.
Future<void> initializeApp() async {
  // Ensure that Flutter bindings are initialized.
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize date formatting for the Persian locale.
  await initializeDateFormatting('fa_IR', null);
  // Initialize the local database service (Hive).
  await CacheService.instance.init();
  developer.log('[main.dart] CacheService initialized successfully.');
  // Initialize timezone data for notifications
  tz.initializeTimeZones();
  // Initialize notification service
  await NotificationService().init();
}

void main() {
  developer.log('[main.dart] App initialization started.');
  // Use runZonedGuarded for top-level error catching.
  runZonedGuarded(() {
    runApp(
      // ProviderScope is required at the root for Riverpod state management.
      ProviderScope(
        child: FutureBuilder<void>(
          future: initializeApp(),
          builder: (context, snapshot) {
            // Show an error screen if initialization fails.
            if (snapshot.hasError) {
              return _ErrorScreen(error: snapshot.error);
            }
            // Show a loading indicator while services are initializing.
            if (snapshot.connectionState != ConnectionState.done) {
              return const _LoadingScreen();
            }
            // Once initialization is complete, show the main app.
            return const VocabBuilderApp();
          },
        ),
      ),
    );
  }, (error, stack) {
    // Log any uncaught errors.
    developer.log('Unhandled error', error: error, stackTrace: stack);
  });
}

/// The root widget of the application.
class VocabBuilderApp extends StatelessWidget {
  const VocabBuilderApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Define a consistent page transition animation for all platforms.
    const pageTransitionsTheme = PageTransitionsTheme(
      builders: {
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.windows: CupertinoPageTransitionsBuilder(),
        TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.linux: CupertinoPageTransitionsBuilder(),
      },
    );

    return MaterialApp(
      title: 'Vocab Builder',
      theme: AppTheme.darkTheme.copyWith(pageTransitionsTheme: pageTransitionsTheme),
      darkTheme: AppTheme.darkTheme.copyWith(pageTransitionsTheme: pageTransitionsTheme),
      themeMode: ThemeMode.dark, // Enforce dark mode throughout the app
      onGenerateRoute: AppRouter.generateRoute,
      initialRoute: AppRouter.mainRoute,
      locale: const Locale('fa', 'IR'),
      supportedLocales: const [
        Locale('fa', 'IR'),
        Locale('en', 'US'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      debugShowCheckedModeBanner: false,
    );
  }
}

/// A simple widget to display while the app is initializing.
class _LoadingScreen extends StatelessWidget {
  const _LoadingScreen();

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

/// A widget to display critical errors that occur during app initialization.
class _ErrorScreen extends StatelessWidget {
  final Object? error;
  const _ErrorScreen({required this.error});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 48),
                const SizedBox(height: 16),
                Text(
                  'Error Initializing App',
                  style: TextStyle(
                    color: Colors.red[700],
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text('$error', textAlign: TextAlign.center),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
