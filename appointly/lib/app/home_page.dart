import 'package:appointly/app.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: "Αρχική",
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
                'Καλώς ήρθες, ${auth.displayName}!',
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              const Text(
                "Εδώ μπορείτε να δείτε τα προσεχή ραντεβού σας και να διαχειριστείτε το προφίλ σας.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 40),
              Card(
                elevation: 0,
                color: Colors.indigo.withOpacity(0.05),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.indigo),
                      SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          "Δεν έχετε προγραμματισμένα ραντεβού για σήμερα.",
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
