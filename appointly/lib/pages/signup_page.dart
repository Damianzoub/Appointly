import 'package:appointly/app.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignupPage extends StatefulWidget {
  static const route = "/signup";
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _surnameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _usernameCtrl = TextEditingController();
  final _confirmPasswordCtrl = TextEditingController();
  DateTime? _dob;
  bool _obscure = true;
  bool _confirmObscure = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _surnameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _usernameCtrl.dispose();
    _confirmPasswordCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDob() async {
    final now = DateTime.now();
    final initial = _dob ?? DateTime(now.year - 18, now.month, now.day);
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(1900),
      lastDate: now,
    );
    if (picked != null) {
      setState(() => _dob = picked);
    }
  }

  Future<void> _submit() async {
    // Έλεγχος εγκυρότητας φόρμας
    if (!_formKey.currentState!.validate()) return;

    if (_dob == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Παρακαλώ επιλέξτε ημερομηνία γέννησης"),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Κλήση της signup από τον AuthController (app.dart)
      await auth.signup(
        name: _nameCtrl.text.trim(),
        surname: _surnameCtrl.text.trim(),
        email: _emailCtrl.text.trim(),
        dob: _dob!,
        username: _usernameCtrl.text.trim(),
        password: _passwordCtrl.text.trim(),
      );

      if (mounted) {
        // Εμφάνιση μηνύματος επιτυχίας
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Ο λογαριασμός δημιουργήθηκε με επιτυχία!"),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );

        // ΑΜΕΣΗ ΑΝΑΚΑΤΕΥΘΥΝΣΗ:
        // Καθαρίζουμε το ιστορικό και πηγαίνουμε στην αρχική.
        // Ο AuthWrapper θα δει ότι ο χρήστης είναι πλέον συνδεδεμένος.
        Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message ?? "Σφάλμα εγγραφής"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Παρουσιάστηκε σφάλμα: ${e.toString()}"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  InputDecoration _inputStyle(String label, IconData icon) {
    return InputDecoration(labelText: label, prefixIcon: Icon(icon, size: 22));
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: "Δημιουργία Λογαριασμού",
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  "Γίνετε μέλος για να κλείνετε τα ραντεβού σας",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 32),

                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _nameCtrl,
                        decoration: _inputStyle("Όνομα", Icons.person_outline),
                        validator: (v) =>
                            (v ?? '').isEmpty ? "Υποχρεωτικό" : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _surnameCtrl,
                        decoration: _inputStyle(
                          "Επώνυμο",
                          Icons.person_outline,
                        ),
                        validator: (v) =>
                            (v ?? '').isEmpty ? "Υποχρεωτικό" : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _usernameCtrl,
                  decoration: _inputStyle("Username", Icons.alternate_email),
                  validator: (v) => (v ?? '').isEmpty ? "Υποχρεωτικό" : null,
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  decoration: _inputStyle("Email", Icons.email_outlined),
                  validator: (v) =>
                      !(v ?? '').contains('@') ? "Μη έγκυρο email" : null,
                ),
                const SizedBox(height: 16),

                InkWell(
                  onTap: _pickDob,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.calendar_today_outlined,
                          color: Colors.grey,
                          size: 22,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          _dob == null
                              ? "Ημερομηνία Γέννησης"
                              : DateFormat('dd/MM/yyyy').format(_dob!),
                          style: TextStyle(
                            fontSize: 16,
                            color: _dob == null
                                ? Colors.grey[600]
                                : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _passwordCtrl,
                  obscureText: _obscure,
                  decoration: _inputStyle("Κωδικός", Icons.lock_outline)
                      .copyWith(
                        suffixIcon: IconButton(
                          onPressed: () => setState(() => _obscure = !_obscure),
                          icon: Icon(
                            _obscure ? Icons.visibility_off : Icons.visibility,
                          ),
                        ),
                      ),
                  validator: (v) =>
                      (v ?? '').length < 6 ? "Τουλάχιστον 6 χαρακτήρες" : null,
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _confirmPasswordCtrl,
                  obscureText: _confirmObscure,
                  decoration:
                      _inputStyle(
                        "Επιβεβαίωση Κωδικού",
                        Icons.lock_reset,
                      ).copyWith(
                        suffixIcon: IconButton(
                          onPressed: () => setState(
                            () => _confirmObscure = !_confirmObscure,
                          ),
                          icon: Icon(
                            _confirmObscure
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                        ),
                      ),
                  validator: (v) => v != _passwordCtrl.text
                      ? "Οι κωδικοί δεν ταιριάζουν"
                      : null,
                ),
                const SizedBox(height: 32),

                SizedBox(
                  height: 52,
                  child: FilledButton(
                    onPressed: _isLoading ? null : _submit,
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text("Δημιουργία Λογαριασμού"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
