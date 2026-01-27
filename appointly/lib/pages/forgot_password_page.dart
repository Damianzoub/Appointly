import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Σελίδα Επαναφοράς Κωδικού Πρόσβασης
/// Επιτρέπει στον χρήστη να ζητήσει σύνδεσμο αλλαγής κωδικού στο email του.
class ForgotPasswordPage extends StatefulWidget {
  static const route = "/forgot";
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  // --- Διαχείριση Κατάστασης & Controllers ---

  // Controller για την ανάγνωση του email από το πεδίο κειμένου.
  final _emailController = TextEditingController();

  // Κλειδί για την επικύρωση της φόρμας (validation).
  final _formKey = GlobalKey<FormState>();

  // Μεταβλητές ελέγχου ροής του UI.
  bool _isLoading = false; // Δείχνει αν η αίτηση είναι σε εξέλιξη.
  bool _emailSent = false; // Δείχνει αν το email στάλθηκε με επιτυχία.

  @override
  void dispose() {
    // Καθαρισμός του controller για την αποφυγή διαρροής μνήμης (memory leaks).
    _emailController.dispose();
    super.dispose();
  }

  /// Εμφάνιση μηνυμάτων ανατροφοδότησης (SnackBar) στον χρήστη.
  /// Χρησιμοποιείται τόσο για σφάλματα όσο και για επιτυχείς ενέργειες.
  void _showMsg(String msg, {bool isError = true}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior
            .floating, // Το μήνυμα "επιπλέει" πάνω από το περιεχόμενο.
      ),
    );
  }

  /// Κύρια διαδικασία επαναφοράς κωδικού.
  /// Επικοινωνεί με το Firebase Auth για την αποστολή του email.
  Future<void> _handleResetPassword() async {
    // Έλεγχος αν το email που πληκτρολογήθηκε είναι έγκυρο βάσει των κανόνων του validator.
    if (!_formKey.currentState!.validate()) return;

    final email = _emailController.text.trim();
    setState(() => _isLoading = true); // Έναρξη κατάστασης φόρτωσης.

    try {
      // Κλήση της μεθόδου της Firebase για αποστολή email επαναφοράς.
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      if (mounted) {
        // Αν η αποστολή πετύχει, αλλάζουμε το UI για να δείξουμε το μήνυμα επιτυχίας.
        setState(() => _emailSent = true);
      }
    } on FirebaseAuthException catch (e) {
      // Διαχείριση σφαλμάτων που προέρχονται συγκεκριμένα από τη Firebase.
      String errorMessage = "An error occurred. Please try again.";

      if (e.code == 'user-not-found') {
        errorMessage =
            "No user found with this email."; // Ο χρήστης δεν υπάρχει.
      } else if (e.code == 'invalid-email') {
        errorMessage =
            "The email address is not valid."; // Το email δεν έχει σωστή μορφή.
      }

      _showMsg(errorMessage);
    } catch (e) {
      // Γενικά σφάλματα (π.χ. απώλεια σύνδεσης ίντερνετ).
      _showMsg("Connection error. Check your internet.");
    } finally {
      // Τερματισμός κατάστασης φόρτωσης, ανεξάρτητα από το αποτέλεσμα.
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Password Reset")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey, // Σύνδεση της φόρμας με το κλειδί επικύρωσης.
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // --- ΠΕΡΙΠΤΩΣΗ 1: Η φόρμα εισαγωγής email ---
              if (!_emailSent) ...[
                const Icon(
                  Icons.mail_lock_outlined,
                  size: 80,
                  color: Colors.indigo,
                ),
                const SizedBox(height: 24),
                const Text(
                  "Forgot your password?",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Enter your email and we will send you a link to reset it.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 32),
                // Πεδίο εισαγωγής κειμένου με κανόνες ελέγχου (Validator).
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: "Email",
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(), // Πλαίσιο γύρω από το πεδίο.
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty)
                      return "Please enter your email";
                    if (!v.contains("@")) return "Invalid email format";
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                // Κουμπί αποστολής με ένδειξη φόρτωσης.
                SizedBox(
                  width: double.infinity,
                  height: 50,
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
                        : const Text("Send Link"),
                  ),
                ),
              ]
              // --- ΠΕΡΙΠΤΩΣΗ 2: UI Επιτυχίας μετά την αποστολή ---
              else ...[
                const Icon(
                  Icons.check_circle_outline,
                  color: Colors.green,
                  size: 80,
                ),
                const SizedBox(height: 24),
                const Text(
                  "Check your inbox!\nFollow the link in the email to change your password.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 40),
                // Κουμπί επιστροφής στην προηγούμενη σελίδα (Login).
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Back to login"),
                  ),
                ),
              ],
              // Κουμπί ακύρωσης που εμφανίζεται μόνο όταν δεν έχει σταλεί ακόμα το email.
              if (!_emailSent)
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
