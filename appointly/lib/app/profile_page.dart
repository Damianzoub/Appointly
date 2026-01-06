import 'package:appointly/app.dart';
import 'package:appointly/app/login_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Χρήσιμο για το φορμάρισμα της ημερομηνίας

class ProfilePage extends StatelessWidget {
  static const route = "/profile";
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: "Προφίλ",
      child: AnimatedBuilder(
        animation: auth,
        builder: (context, _) {
          // 1. Λειτουργία για μη συνδεδεμένους χρήστες
          if (!auth.isLoggedIn) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.lock_outline, size: 80, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text(
                    "Δεν είστε συνδεδεμένος",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: () {
                      // Πλοήγηση στη σελίδα Login
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                      );
                    },
                    child: const Text("Σύνδεση"),
                  ),
                ],
              ),
            );
          }

          // 2. Προετοιμασία δεδομένων προφίλ
          final dobText = auth.dob != null
              ? DateFormat('dd/MM/yyyy').format(auth.dob!)
              : "Δεν ορίστηκε";

          return SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),
                // Avatar με το αρχικό γράμμα του χρήστη αν δεν υπάρχει φωτό
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.indigo,
                  child: Text(
                    auth.displayName[0].toUpperCase(),
                    style: const TextStyle(fontSize: 40, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  auth.displayName,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 32),

                // Κάρτα Email
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.email, color: Colors.indigo),
                    title: const Text("Email"),
                    subtitle: Text(
                      auth.email.isEmpty ? "Δεν ορίστηκε" : auth.email,
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                // Κάρτα Ημερομηνίας Γέννησης
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.cake, color: Colors.indigo),
                    title: const Text("Ημερομηνία Γέννησης"),
                    subtitle: Text(dobText),
                  ),
                ),
                const SizedBox(height: 32),

                // Λειτουργικό κουμπί Logout
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () {
                      // Εμφάνιση διαλόγου επιβεβαίωσης (προαιρετικό αλλά επαγγελματικό)
                      _showLogoutDialog(context);
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.red.shade600,
                      foregroundColor: Colors.white,
                    ),
                    icon: const Icon(Icons.logout),
                    label: const Text("Αποσύνδεση"),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Συνάρτηση για διάλογο αποσύνδεσης
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Αποσύνδεση"),
        content: const Text("Είστε σίγουροι ότι θέλετε να αποσυνδεθείτε;"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Ακύρωση"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              auth.logout();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Αποσυνδεθήκατε με επιτυχία"),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text(
              "Ναι, Αποσύνδεση",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
