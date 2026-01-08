import 'package:appointly/app.dart';
import 'package:flutter/material.dart';
// Βεβαιώσου ότι το path για το localization είναι σωστό
import 'package:appointly/l10n/app_localizations.dart';

class _CardLine extends StatelessWidget {
  final String title;
  final String subtitle;

  const _CardLine({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.indigo,
          ),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right, color: Colors.indigo),
        onTap: () {
          // Εδώ θα μπει η λογική για το κάθε βήμα
        },
      ),
    );
  }
}

class BookPage extends StatelessWidget {
  const BookPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Λήψη των μεταφράσεων
    final t = AppLocalizations.of(context)!;

    return AppScaffold(
      title: t.bookTitle, // "Κράτηση" από το .arb
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            t.bookPlaceholder,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // Χρήση των νέων κλειδιών για τις κάρτες
          _CardLine(title: t.step1Title, subtitle: t.step1Subtitle),
          _CardLine(title: t.step2Title, subtitle: t.step2Subtitle),
          _CardLine(title: t.step3Title, subtitle: t.step3Subtitle),
        ],
      ),
    );
  }
}
