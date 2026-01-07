import 'package:flutter/material.dart';
import 'package:appointly/language_provider.dart';
import 'package:provider/provider.dart';
import '../../../app.dart';
import '../../../app/login_page.dart';
import '../../../l10n/app_localizations.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final langProvider = context.watch<LanguageProvider>();
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(t.profileTitle)),
      body: AnimatedBuilder(
        animation: auth,
        builder: (context, _) {
          if (!auth.isLoggedIn) {
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const CircleAvatar(
                  radius: 32,
                  child: Icon(Icons.lock_outline, size: 32),
                ),
                const SizedBox(height: 12),
                Center(
                  child: Text(
                    t.notLoggedIn,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                const SizedBox(height: 24),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.login),
                    title: Text(t.goToLogin),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginPage()),
                      );
                    },
                  ),
                ),
              ],
            );
          }

          // logged in => same layout
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const CircleAvatar(
                radius: 32,
                child: Icon(Icons.person, size: 32),
              ),
              const SizedBox(height: 12),
              Center(
                child: Text(
                  auth.displayName,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              const SizedBox(height: 24),

              Card(
                child: ListTile(
                  leading: const Icon(Icons.edit),
                  title: Text(t.editProfile),
                  onTap: () => _showEditProfileDialog(context),
                ),
              ),

              Card(
                child: ListTile(
                  leading: const Icon(Icons.language),
                  title: Text(t.language),
                  subtitle: Text(_langLabel(langProvider.locale.languageCode)),
                  onTap: () => _showLanguageSheet(context),
                ),
              ),

              Card(
                child: ListTile(
                  leading: const Icon(Icons.logout),
                  title: Text(t.logout),
                  onTap: () => _confirmLogout(context),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showEditProfileDialog(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final ctrl = TextEditingController(text: auth.username);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(t.editProfile),
        content: TextField(
          controller: ctrl,
          decoration: InputDecoration(
            labelText: t.username,
            border: const OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(t.cancel),
          ),
          TextButton(
            onPressed: () {
              final newUsername = ctrl.text.trim();
              if (newUsername.isEmpty) return;

              auth.updateUsername(username: newUsername);

              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(t.profileUpdated)),
              );
            },
            child: Text(t.save),
          ),
        ],
      ),
    );
  }

  // language change (keep language names as proper nouns)
  void _showLanguageSheet(BuildContext context) {
    final provider = context.read<LanguageProvider>();

    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: const Text("English"),
            onTap: () async {
              await provider.setLocale(const Locale('en'));
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text("Greek"),
            onTap: () async {
              await provider.setLocale(const Locale('el'));
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text("Spanish"),
            onTap: () async {
              await provider.setLocale(const Locale("es"));
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text("German"),
            onTap: () async {
              await provider.setLocale(const Locale('de'));
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text("French"),
            onTap: () async {
              await provider.setLocale(const Locale("fr"));
              Navigator.pop(context);
            },
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  static String _langLabel(String code) {
    switch (code) {
      case "el":
        return 'Greek';
      case "en":
        return 'English';
      case "es":
        return 'Spanish';
      case "de":
        return 'German';
      case "fr":
        return 'French';
      default:
        return code;
    }
  }

  // logout
  void _confirmLogout(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(t.logoutTitle),
        content: Text(t.logoutConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(t.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              auth.logout();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(t.loggedOut)),
              );
            },
            child: Text(
              t.logout,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
