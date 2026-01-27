import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../app.dart';
import '../language_provider.dart';
import '../l10n/app_localizations.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Instances Firebase.
  final _firebaseAuth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  // Τοπική αποθήκευση των δεδομένων προφίλ.
  Map<String, dynamic>? _profileData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProfile(); // Φόρτωση δεδομένων κατά την εκκίνηση της σελίδας.
  }

  /// Ανάκτηση του εγγράφου του χρήστη από τη συλλογή 'users' του Firestore.
  Future<void> _fetchProfile() async {
    final user = _firebaseAuth.currentUser;
    if (user == null) return;

    try {
      final doc = await _db.collection('users').doc(user.uid).get();
      if (mounted) {
        setState(() {
          _profileData = doc.data();
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  /// Συνδυάζει όνομα και επώνυμο για εμφάνιση στην κεφαλίδα.
  String get _fullName {
    final fName = _profileData?['first_name'] ?? _profileData?['name'] ?? '';
    final lName = _profileData?['last_name'] ?? _profileData?['surname'] ?? '';

    if (fName.isEmpty && lName.isEmpty) {
      return _firebaseAuth.currentUser?.displayName ?? "Χρήστης";
    }
    return "$fName $lName".trim();
  }

  /// Μετατρέπει το πεδίο ημερομηνίας γέννησης σε αναγνώσιμη μορφή.
  String _formatDob(dynamic dob, AppLocalizations t) {
    if (dob == null) return t.notSet;
    try {
      if (dob is Timestamp)
        return DateFormat('dd/MM/yyyy').format(dob.toDate());
      if (dob is String)
        return DateFormat('dd/MM/yyyy').format(DateTime.parse(dob));
    } catch (e) {
      return dob.toString();
    }
    return t.notSet;
  }

  /// Διάλογος που επιτρέπει στον χρήστη να επεξεργαστεί τα στοιχεία του.
  Future<void> _editProfileDialog() async {
    final t = AppLocalizations.of(context)!;
    final user = _firebaseAuth.currentUser;
    if (user == null) return;

    // Controllers για τα πεδία κειμένου.
    final nameCtrl = TextEditingController(
      text: _profileData?['first_name'] ?? _profileData?['name'] ?? "",
    );
    final lastNameCtrl = TextEditingController(
      text: _profileData?['last_name'] ?? _profileData?['surname'] ?? "",
    );
    final usernameCtrl = TextEditingController(
      text: _profileData?['username'] ?? "",
    );

    DateTime? selectedDob;
    var rawDob = _profileData?['dob'];
    if (rawDob is Timestamp)
      selectedDob = rawDob.toDate();
    else if (rawDob is String)
      selectedDob = DateTime.tryParse(rawDob);

    await showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            t.editProfile,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameCtrl,
                  decoration: InputDecoration(
                    labelText: t.firstname,
                    prefixIcon: const Icon(Icons.person_outline),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: lastNameCtrl,
                  decoration: InputDecoration(
                    labelText: t.lastname,
                    prefixIcon: const Icon(Icons.person_outline),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: usernameCtrl,
                  decoration: InputDecoration(
                    labelText: t.username,
                    prefixIcon: const Icon(Icons.alternate_email),
                  ),
                ),
                const SizedBox(height: 12),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(
                    Icons.cake_outlined,
                    color: Colors.indigo,
                  ),
                  title: Text(
                    selectedDob == null
                        ? t.dateofbirth
                        : DateFormat('dd/MM/yyyy').format(selectedDob!),
                  ),
                  onTap: () async {
                    // Επιλογή ημερομηνίας γέννησης.
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: selectedDob ?? DateTime(2000),
                      firstDate: DateTime(1920),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null)
                      setDialogState(() => selectedDob = picked);
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text("Ακύρωση"),
            ),
            FilledButton(
              onPressed: () async {
                // Ενημέρωση Firestore και Firebase Auth προφίλ.
                await _db.collection('users').doc(user.uid).set({
                  'first_name': nameCtrl.text.trim(),
                  'last_name': lastNameCtrl.text.trim(),
                  'username': usernameCtrl.text.trim(),
                  'dob': selectedDob != null
                      ? Timestamp.fromDate(selectedDob!)
                      : rawDob,
                }, SetOptions(merge: true));

                await user.updateDisplayName(
                  "${nameCtrl.text.trim()} ${lastNameCtrl.text.trim()}",
                );
                if (mounted) Navigator.pop(ctx);
                _fetchProfile(); // Ανανέωση της σελίδας με τα νέα δεδομένα.
              },
              child: const Text("Αποθήκευση"),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final langProvider = Provider.of<LanguageProvider>(context);

    // Διαθέσιμες γλώσσες για την εφαρμογή.
    final List<Map<String, String>> languages = [
      {'name': 'Ελληνικά', 'code': 'el', 'flag': '🇬🇷'},
      {'name': 'English', 'code': 'en', 'flag': '🇺🇸'},
      {'name': 'Deutsch', 'code': 'de', 'flag': '🇩🇪'},
      {'name': 'Français', 'code': 'fr', 'flag': '🇫🇷'},
      {'name': 'Español', 'code': 'es', 'flag': '🇪🇸'},
    ];

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          t.profileTitle,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        actions: [
          IconButton(
            onPressed: _editProfileDialog,
            icon: const Icon(Icons.edit_note_rounded, size: 28),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              children: [
                // Φωτογραφία προφίλ (Avatar).
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.indigo.withOpacity(0.2),
                        width: 4,
                      ),
                    ),
                    child: const CircleAvatar(
                      radius: 55,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.person_rounded,
                        size: 70,
                        color: Colors.indigo,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Text(
                    _fullName,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    "@${_profileData?['username'] ?? 'username'}",
                    style: TextStyle(color: Colors.grey[600], fontSize: 16),
                  ),
                ),
                const SizedBox(height: 32),
                _buildSectionHeader(t.accountinfo),
                const SizedBox(height: 12),
                _buildModernCard(
                  child: Column(
                    children: [
                      _buildProfileItem(
                        Icons.cake_outlined,
                        t.dateofbirth,
                        _formatDob(_profileData?['dob'], t),
                      ),
                      const Divider(height: 1),
                      _buildProfileItem(
                        Icons.email_outlined,
                        t.email,
                        _firebaseAuth.currentUser?.email ?? "-",
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                _buildSectionHeader(t.language),
                const SizedBox(height: 12),
                // Dropdown για αλλαγή γλώσσας μέσω του LanguageProvider.
                _buildModernCard(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value:
                            languages.any(
                              (l) =>
                                  l['code'] == langProvider.locale.languageCode,
                            )
                            ? langProvider.locale.languageCode
                            : 'el',
                        isExpanded: true,
                        icon: const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: Colors.indigo,
                        ),
                        items: languages
                            .map(
                              (lang) => DropdownMenuItem<String>(
                                value: lang['code'],
                                child: Row(
                                  children: [
                                    Text(
                                      lang['flag']!,
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      lang['name']!,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (newCode) => newCode != null
                            ? langProvider.setLocale(Locale(newCode))
                            : null,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                _buildSectionHeader(t.appointmentHistory),
                const SizedBox(height: 12),
                // Σύνδεσμος για το ιστορικό ραντεβού.
                _buildModernCard(
                  child: ListTile(
                    leading: Icon(
                      Icons.history_rounded,
                      color: Colors.indigo[400],
                    ),
                    title: Text(
                      t.appointmentHistory,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      t.seeAll,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () =>
                        Navigator.pushNamed(context, '/appointments_history'),
                  ),
                ),
                const SizedBox(height: 32),
                // Κουμπί αποσύνδεσης.
                FilledButton.icon(
                  onPressed: () => _confirmLogout(context),
                  icon: const Icon(Icons.logout_rounded),
                  label: Text(t.logout),
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.red[50],
                    foregroundColor: Colors.red,
                    elevation: 0,
                    minimumSize: const Size(double.infinity, 54),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  /// Τίτλος ενότητας προφίλ.
  Widget _buildSectionHeader(String title) => Padding(
    padding: const EdgeInsets.only(left: 4),
    child: Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.indigo,
      ),
    ),
  );

  /// Στυλιζαρισμένο πλαίσιο (Card).
  Widget _buildModernCard({required Widget child}) => Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.04),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: child,
  );

  /// Μεμονωμένο στοιχείο πληροφορίας (π.χ. Email).
  Widget _buildProfileItem(IconData icon, String label, String value) =>
      ListTile(
        leading: Icon(icon, color: Colors.indigo[400], size: 22),
        title: Text(
          label,
          style: const TextStyle(fontSize: 13, color: Colors.grey),
        ),
        subtitle: Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      );

  /// Διάλογος επιβεβαίωσης αποσύνδεσης.
  void _confirmLogout(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(t.logoutTitle),
        content: Text(t.logoutConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(t.cancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              await _firebaseAuth.signOut(); // Έξοδος από το Firebase Auth.
              auth.logout(); // Καθαρισμός τοπικής κατάστασης.
              if (mounted) {
                Navigator.of(ctx).pop();
                Navigator.of(
                  context,
                ).pushNamedAndRemoveUntil('/', (route) => false);
              }
            },
            child: Text(t.logout),
          ),
        ],
      ),
    );
  }
}
