import 'package:appointly/app/book_page.dart';
import 'package:appointly/app/home_page.dart';
import 'package:appointly/app/welcome_page.dart';
import 'package:appointly/features/profile/ui/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:appointly/l10n/app_localizations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthController extends ChangeNotifier {
  final _supabase = Supabase.instance.client;

  bool get isLoggedIn => _supabase.auth.currentSession != null;

  String get displayName {
    final user = _supabase.auth.currentUser;
    final metadata = user?.userMetadata;
    if (metadata == null) return "User";

    final n = (metadata['first_name'] ?? "").toString().trim();
    final s = (metadata['last_name'] ?? "").toString().trim();
    final full = ("$n $s").trim();
    return full.isEmpty ? (metadata['username'] ?? "User") : full;
  }

  String get email => _supabase.auth.currentUser?.email ?? "";

  Future<void> login({required String email, required String password}) async {
    await _supabase.auth.signInWithPassword(email: email, password: password);
    notifyListeners();
  }

  Future<void> signup({
    required String name,
    required String surname,
    required String email,
    required DateTime dob,
    required String username,
    required String password,
  }) async {
    try {
      // 1. Signup στο auth
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {
          'first_name': name,
          'last_name': surname,
          'username': username,
          'dob': dob.toIso8601String(),
        },
      );

      // 2. Αν το signup πέτυχε, δημιούργησε το profile
      if (response.user != null) {
        try {
          await _supabase.from('profiles').insert({
            'id': response.user!.id,
            'username': username,
            'first_name': name,
            'last_name': surname,
            'dob': dob.toIso8601String().split('T')[0], // Μόνο η ημερομηνία
          });
        } catch (profileError) {
          // Αν αποτύχει το profile insert, διέγραψε τον user
          print('Profile creation failed: $profileError');
          // Μπορείς να διαγράψεις τον user εδώ αν θέλεις
        }
      }

      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  void logout() async {
    await _supabase.auth.signOut();
    notifyListeners();
  }
}

final AuthController auth = AuthController();

class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: auth,
      builder: (context, _) {
        if (!auth.isLoggedIn) {
          return const WelcomePage();
        }
        return const HomeShell();
      },
    );
  }
}

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;
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
