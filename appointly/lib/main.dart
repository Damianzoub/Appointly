import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'pages/appointments_history_page.dart';
import 'app.dart';
import 'language_provider.dart';
import 'l10n/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Αρχικοποίηση Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

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
    // Χρήση Consumer για να αντιδρά η εφαρμογή στις αλλαγές γλώσσας
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          locale: languageProvider.locale,
          supportedLocales: const [
            Locale('en'),
            Locale('el'),
            Locale('de'),
            Locale('fr'),
            Locale('es'),
          ],
          // Delegates για τη μετάφραση των standard widgets (ημερολόγια, μενού κλπ)
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          // Ορισμός ονομαστικών διαδρομών
          routes: {
            '/appointments_history': (context) =>
                const AppointmentsHistoryPage(),
          },
          home: const AuthWrapper(),
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
            scaffoldBackgroundColor: Colors.white,
            // Ρύθμιση της εμφάνισης των πεδίων εισαγωγής κειμένου
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
            ),
          ),
        );
      },
    );
  }
}
