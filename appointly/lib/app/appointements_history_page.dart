import 'package:flutter/material.dart';
import 'package:appointly/l10n/app_localizations.dart';

class AppointmentsHistoryPage extends StatelessWidget {
  const AppointmentsHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(t.appointmentHistory)),
      body: const Center(child: Text("History Page"),)
    );
  }
}