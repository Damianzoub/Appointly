import 'package:appointly/app.dart';
import 'package:flutter/material.dart';
// Πρόσθεσε το import για τα localizations
import 'package:appointly/l10n/app_localizations.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Ορισμός του t για την πρόσβαση στις μεταφράσεις
    final t = AppLocalizations.of(context)!;

    return AppScaffold(
      title: t.homeTitle, // Χρήση μετάφρασης για τον τίτλο
      child: AnimatedBuilder(
        animation: auth,
        builder: (context, _) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.verified_user_rounded,
                size: 80,
                color: Colors.indigo,
              ),
              const SizedBox(height: 24),
              Text(
                // Χρήση της παραμετρικής μετάφρασης welcomeBack
                t.welcomeBack(auth.displayName),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                t.homeSubtitle, // Χρήση μετάφρασης για το υπότιτλο
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 40),
              Card(
                elevation: 0,
                color: Colors.indigo.withOpacity(0.05),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline, color: Colors.indigo),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          t.noAppointmentsToday, // Χρήση μετάφρασης για το μήνυμα
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
