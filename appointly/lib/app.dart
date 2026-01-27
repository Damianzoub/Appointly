import 'package:appointly/pages/book_page.dart';
import 'package:appointly/pages/home_page.dart';
import 'package:appointly/pages/welcome_page.dart';
import 'package:appointly/pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:appointly/l10n/app_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// instance για τον έλεγχο της αυθεντικοποίησης
final auth = AuthController();

class AuthController extends ChangeNotifier {
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  // Επιστρέφει true αν υπάρχει συνδεδεμένος χρήστης
  bool get isLoggedIn => _auth.currentUser != null;

  String get displayName => _auth.currentUser?.displayName ?? "User";

  String get email => _auth.currentUser?.email ?? "";

  // Σύνδεση με email και κωδικό
  Future<void> login({required String email, required String password}) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
    notifyListeners();
  }

  // Εγγραφή νέου χρήστη και δημιουργία προφίλ στο Firestore
  Future<void> signup({
    required String name,
    required String surname,
    required String email,
    required DateTime dob,
    required String username,
    required String password,
  }) async {
    // 1. Δημιουργία λογαριασμού στο Firebase Auth
    UserCredential credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    // 2. Ενημέρωση του ονόματος στο προφίλ αυθεντικοποίησης
    await credential.user?.updateDisplayName("$name $surname");

    // 3. Δημιουργία εγγράφου στη συλλογή 'users' για επιπλέον πληροφορίες
    await _db.collection('users').doc(credential.user!.uid).set({
      'first_name': name,
      'last_name': surname,
      'username': username,
      'dob': dob.toIso8601String(),
      'email': email,
      'created_at': FieldValue.serverTimestamp(),
    });

    notifyListeners();
  }

  // Έξοδος χρήστη
  void logout() async {
    await _auth.signOut();
    notifyListeners();
  }
}

// Widget που ελέγχει ποια σελίδα θα προβληθεί βάσει του Auth status
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: auth,
      builder: (context, _) {
        if (auth.isLoggedIn) {
          return const HomeShell();
        }
        return const WelcomePage();
      },
    );
  }
}

// Το κέλυφος της εφαρμογής με το κάτω μενού πλοήγησης
class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;
  // Λίστα των κύριων σελίδων
  final _pages = const [HomePage(), BookPage(), ProfilePage()];

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      body: _pages[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            label: t.homeTitle,
          ),
          NavigationDestination(
            icon: const Icon(Icons.event_available_outlined),
            label: t.bookTitle,
          ),
          NavigationDestination(
            icon: const Icon(Icons.person_outline),
            label: t.profileTitle,
          ),
        ],
      ),
    );
  }
}

// Ενιαίο Scaffold για σελίδες όπως η Σύνδεση και η Εγγραφή
class AppScaffold extends StatelessWidget {
  final String title;
  final Widget child;

  const AppScaffold({super.key, required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title), centerTitle: true),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Padding(padding: const EdgeInsets.all(24.0), child: child),
          ),
        ),
      ),
    );
  }
}
