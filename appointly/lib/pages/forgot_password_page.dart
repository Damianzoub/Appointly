import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPasswordPage extends StatefulWidget {
  static const route = "/forgot";
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // Προσθήκη FormKey για validation
  bool _isLoading = false;
  bool _emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  // Μέθοδος εμφάνισης μηνυμάτων (SnackBar)
  void _showMsg(String msg, {bool isError = true}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _handleResetPassword() async {
    // 1. Έλεγχος εγκυρότητας φόρμας
    if (!_formKey.currentState!.validate()) return;

    final email = _emailController.text.trim();
    setState(() => _isLoading = true);

    try {
      // 2. Αποστολή email μέσω Firebase
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      if (mounted) {
        setState(() => _emailSent = true);
        _showMsg("Ο σύνδεσμος επαναφοράς στάλθηκε!", isError: false);
      }
    } on FirebaseAuthException catch (e) {
      // 3. Εξειδικευμένη διαχείριση σφαλμάτων Firebase
      String errorMessage = "Παρουσιάστηκε σφάλμα";
      if (e.code == 'user-not-found') {
        errorMessage = "Δεν βρέθηκε χρήστης με αυτό το email.";
      } else if (e.code == 'invalid-email') {
        errorMessage = "Η διεύθυνση email δεν είναι έγκυρη.";
      } else if (e.code == 'too-many-requests') {
        errorMessage = "Πολλά αιτήματα. Δοκιμάστε ξανά αργότερα.";
      }
      _showMsg(errorMessage);
    } catch (e) {
      _showMsg("Κάτι πήγε στραβά. Δοκιμάστε ξανά.");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Επαναφορά Κωδικού"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey, // Σύνδεση με το FormKey
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!_emailSent) ...[
                const Icon(Icons.lock_reset, size: 80, color: Colors.indigo),
                const SizedBox(height: 24),
                const Text(
                  "Εισάγετε το email σας για να σας στείλουμε έναν σύνδεσμο επαναφοράς του κωδικού σας.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 32),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: "Email",
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  // Validation για κενό πεδίο και σωστό format
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return "Το email είναι απαραίτητο";
                    if (!RegExp(
                      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                    ).hasMatch(value)) {
                      return "Εισάγετε ένα έγκυρο email";
                    }
                    return null;
                  },
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
                // UI Επιτυχίας
                const Icon(
                  Icons.check_circle_outline,
                  color: Colors.green,
                  size: 80,
                ),
                const SizedBox(height: 24),
                const Text(
                  "Ελέγξτε τα εισερχόμενά σας!\nΑκολουθήστε τον σύνδεσμο στο email για να αλλάξετε τον κωδικό σας.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Επιστροφή στη σύνδεση"),
                  ),
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
