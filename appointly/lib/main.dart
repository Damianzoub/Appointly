import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'language_provider.dart';
import 'l10n/app_localizations.dart';
// IMPORTANT: this import path must match your generated file location
void main() {
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

      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      localeResolutionCallback: (locale,supportedLocales){
        if (locale==null) return const Locale('en');
        for (final supported in supportedLocales){
          if (supported.languageCode== locale.languageCode){
            return supported;
          }
        }
        return const Locale('en');
      },
      // Keep your theme here (NOT inside app.dart anymore)
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo),

      home: const AppRoot(),
    );
  }
}
