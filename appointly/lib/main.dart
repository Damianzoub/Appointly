import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // [Βήμα 1: Ξεκλειδώνουμε το import]

import 'app.dart';
import 'language_provider.dart';
import 'l10n/app_localizations.dart';

// [Βήμα 2: Μετατροπή της main σε async]
Future<void> main() async {
  // [Βήμα 3: Εξασφάλιση ότι τα bindings είναι έτοιμα]
  WidgetsFlutterBinding.ensureInitialized();

  // [Βήμα 4: Αρχικοποίηση της Supabase]
  await Supabase.initialize(
    url:
        'https://hovaggbxxhsviudnejjc.supabase.co', // Αντικατάστησε με το δικό σου URL
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhvdmFnZ2J4eGhzdml1ZG5lampjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Njc3MjU1ODEsImV4cCI6MjA4MzMwMTU4MX0.zZpw8cK3lhsI3__FXZZs8TPQy60H4Zk83x2UaZaLosA',
    // Αντικατάστησε με το δικό σου Key
  );

  runApp(
    ChangeNotifierProvider(
      create: (_) => LanguageProvider(),
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final localeProvider = context.watch<LanguageProvider>();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Appointly',

      // Localization
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      locale: localeProvider.locale,

      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          surface: Colors.white,
          surfaceTint: Colors.white,
        ),

        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey[50],
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade200),
          ),
        ),

        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            minimumSize: const Size.fromHeight(52),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),

        appBarTheme: const AppBarTheme(
          centerTitle: false,
          elevation: 0,
          scrolledUnderElevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),

        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: Colors.white,
          indicatorColor: Colors.indigo.withOpacity(0.1),
          height: 70,
        ),
      ),
      home: const AppRoot(),
    );
  }
}
