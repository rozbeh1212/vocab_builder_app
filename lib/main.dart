import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'core/services/cache_service.dart';
import 'presentation/providers/settings_provider.dart';
import 'presentation/providers/word_provider.dart';
import 'utils/theme.dart';
import 'utils/app_router.dart'; // Import AppRouter

Future<void> initializeApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('fa_IR', null);
  await CacheService.instance.init();
}

void main() {
  runApp(FutureBuilder(
    future: initializeApp(),
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        return MaterialApp(
          home: Scaffold(
            body: Center(
              child: Text('Error initializing app: ${snapshot.error}'),
            ),
          ),
        );
      }
      if (snapshot.connectionState != ConnectionState.done) {
        return const MaterialApp(
          home: Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        );
      }
      return const MyApp();
    },
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WordProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
      ],
      child: Consumer<SettingsProvider>(
        builder: (context, settingsProvider, child) {
          // Add smooth page transitions
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
            theme: AppTheme.darkTheme.copyWith(
              pageTransitionsTheme: pageTransitionsTheme,
            ),
            darkTheme: AppTheme.darkTheme.copyWith(
              pageTransitionsTheme: pageTransitionsTheme,
            ),
            themeMode: ThemeMode.dark,
            onGenerateRoute: AppRouter.generateRoute,
            initialRoute: AppRouter.mainRoute,
            // Use Persian (Farsi) as the app locale and provide localization
            // delegates so built-in widgets adapt to RTL and Persian formats.
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
        },
      ),
    );
  }
}



