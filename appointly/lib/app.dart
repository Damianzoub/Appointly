import 'package:appointly/app/book_page.dart';
import 'package:appointly/app/home_page.dart';
import 'package:appointly/app/welcome_page.dart';
import 'package:appointly/features/profile/ui/profile_page.dart';
import 'package:flutter/material.dart';

class AuthController extends ChangeNotifier {
  bool _isLoggedIn = false;
  String? _name;
  String? _surname;
  String? _email;
  DateTime? _dob;
  String? _username;

  bool get isLoggedIn => _isLoggedIn;

  String get displayName {
    final n = (_name ?? "").trim();
    final s = (_surname ?? "").trim();
    final full = ("$n $s").trim();
    return full.isEmpty ? (_username ?? "User") : full;
  }

  String get email => (_email ?? "").trim();
  DateTime? get dob => _dob;

  void login({required String username, required String password}) {
    // Εδώ θα έμπαινε ο έλεγχος με το Firebase
    _isLoggedIn = true;
    _username = username;
    notifyListeners();
  }

  void signup({
    required String name,
    required String surname,
    required String email,
    required DateTime dob,
    required String username,
    required String password,
  }) {
    _isLoggedIn = true;
    _name = name;
    _surname = surname;
    _email = email;
    _dob = dob;
    _username = username;
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    _name = null;
    _surname = null;
    _email = null;
    _dob = null;
    _username = null;
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
        // Αν δεν είναι συνδεδεμένος, δείξε την WelcomePage
        if (!auth.isLoggedIn) {
          return const WelcomePage();
        }
        // Αν είναι συνδεδεμένος, δείξε το κυρίως περιβάλλον (Tabs)
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
    return Scaffold(
      body: _pages[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            label: "Αρχική",
          ),
          NavigationDestination(
            icon: Icon(Icons.event_available_outlined),
            label: "Ραντεβού",
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            label: "Προφίλ",
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
