import 'package:appointly/app.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
      // Χρησιμοποιούμε τη μέθοδο resetPasswordForEmail που αντιστοιχεί
      // στο template που έχεις στη Supabase (με το link).
      await Supabase.instance.client.auth.resetPasswordForEmail(
        email,
        // Το redirectTo πρέπει να είναι δηλωμένο στο Supabase Dashboard -> Auth Settings
        redirectTo: 'io.supabase.flutter://reset-callback/',
      );

      setState(() => _emailSent = true);
      _showMsg("Ο σύνδεσμος επαναφοράς στάλθηκε στο email σας!");
    } on AuthException catch (e) {
      _showMsg(e.message);
    } catch (e) {
      _showMsg("Παρουσιάστηκε ένα απρόσμενο σφάλμα.");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showMsg(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: "Επαναφορά Κωδικού",
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.lock_open_rounded,
                size: 80,
                color: Colors.indigo,
              ),
              const SizedBox(height: 24),
              if (!_emailSent) ...[
                const Text(
                  "Εισάγετε το email σας και θα σας στείλουμε έναν σύνδεσμο για να ορίσετε νέο κωδικό πρόσβασης.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 32),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: "Email",
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
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
