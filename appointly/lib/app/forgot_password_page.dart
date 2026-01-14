import 'package:appointly/app.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Αλλαγή: Firebase αντί για Supabase

class ForgotPasswordPage extends StatefulWidget {
  static const route = "/forgot";
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();
  bool _isLoading = false;
  bool _emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleResetPassword() async {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      _showMsg("Παρακαλώ εισάγετε το email σας");
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Χρήση Firebase Auth για αποστολή email επαναφοράς
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      setState(() => _emailSent = true);
      _showMsg("Ο σύνδεσμος επαναφοράς στάλθηκε στο email σας!");
    } on FirebaseAuthException catch (e) {
      // Διαχείριση λαθών Firebase (π.χ. λάθος format email)
      _showMsg(e.message ?? "Παρουσιάστηκε σφάλμα");
    } catch (e) {
      _showMsg("Κάτι πήγε στραβά. Δοκιμάστε ξανά.");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showMsg(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), behavior: SnackBarBehavior.floating),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Επαναφορά Κωδικού")),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: ListView(
            padding: const EdgeInsets.all(24),
            shrinkWrap: true,
            children: [
              if (!_emailSent) ...[
                const Text(
                  "Ξεχάσατε τον κωδικό σας;",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                const Text(
                  "Εισάγετε το email σας και θα σας στείλουμε έναν σύνδεσμο για να ορίσετε νέο κωδικό πρόσβασης.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 32),
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: "Email",
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: FilledButton(
                    onPressed: _isLoading ? null : _handleResetPassword,
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text("Αποστολή Συνδέσμου"),
                  ),
                ),
              ] else ...[
                const Icon(
                  Icons.check_circle_outline,
                  color: Colors.green,
                  size: 60,
                ),
                const SizedBox(height: 16),
                const Text(
                  "Ελέγξτε τα εισερχόμενά σας!\nΑκολουθήστε τον σύνδεσμο στο email για να αλλάξετε τον κωδικό σας.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 32),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Επιστροφή στη σύνδεση"),
                ),
              ],
              if (!_emailSent)
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Ακύρωση"),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
