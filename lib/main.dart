import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'core/services/cache_service.dart';
import 'core/providers/settings_notifier.dart';
import 'utils/theme.dart';
import 'utils/app_router.dart';

Future<void> initializeApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('fa_IR', null);
  await CacheService.instance.init();
}

void main() {
  runZonedGuarded(() {
    runApp(ProviderScope(
      child: FutureBuilder<void>(
        future: initializeApp(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return MaterialApp(
              home: Scaffold(
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 48,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Error initializing app:',
                        style: TextStyle(
                          color: Colors.red[700],
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Text(
                          '${snapshot.error}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          if (snapshot.connectionState != ConnectionState.done) {
            return const MaterialApp(
              home: Scaffold(
                body: Center(child: CircularProgressIndicator()),
              ),
            );
          }

          return const MyApp();
        },
      ),
    ));
  }, (error, stack) {
    debugPrint('Error: $error');
    debugPrint('Stack trace: $stack');
  });
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsNotifierProvider);

    final pageTransitionsTheme = PageTransitionsTheme(
      builders: {
        TargetPlatform.android: const CupertinoPageTransitionsBuilder(),
        TargetPlatform.iOS: const CupertinoPageTransitionsBuilder(),
        TargetPlatform.windows: const CupertinoPageTransitionsBuilder(),
        TargetPlatform.macOS: const CupertinoPageTransitionsBuilder(),
        TargetPlatform.linux: const CupertinoPageTransitionsBuilder(),
      },
    );

    return MaterialApp(
      title: 'Vocab Builder',
      theme: AppTheme.darkTheme.copyWith(pageTransitionsTheme: pageTransitionsTheme),
      darkTheme: AppTheme.darkTheme.copyWith(pageTransitionsTheme: pageTransitionsTheme),
      themeMode: settings.themeMode,
      onGenerateRoute: AppRouter.generateRoute,
      initialRoute: AppRouter.mainRoute,
      locale: const Locale('fa', 'IR'),
      supportedLocales: const [Locale('fa', 'IR'), Locale('en', 'US')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      debugShowCheckedModeBanner: false,
    );
  }
}




