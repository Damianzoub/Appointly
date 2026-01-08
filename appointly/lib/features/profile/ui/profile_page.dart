import 'package:flutter/material.dart';
import 'package:appointly/language_provider.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../app.dart';
import '../../../l10n/app_localizations.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _supabase = Supabase.instance.client;
  Map<String, dynamic>? _profileData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user != null) {
        final data = await _supabase
            .from('profiles')
            .select()
            .eq('id', user.id)
            .single();
        if (mounted) {
          setState(() {
            _profileData = data;
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final langProvider = context.watch<LanguageProvider>();
    final t = AppLocalizations.of(context)!;
    final user = _supabase.auth.currentUser;

    return Scaffold(
      appBar: AppBar(title: Text(t.profileTitle), centerTitle: true),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const CircleAvatar(
                  radius: 32,
                  child: Icon(Icons.person, size: 32),
                ),
                const SizedBox(height: 12),
                Center(
                  child: Text(
                    _profileData != null
                        ? "${_profileData!['name']} ${_profileData!['surname']}"
                        : "User",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                const SizedBox(height: 24),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.language),
                    title: Text(t.language),
                    subtitle: Text(
                      langProvider.locale.languageCode == 'el'
                          ? 'Greek'
                          : 'English',
                    ),
                    onTap: () => _showLanguageSheet(context),
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.logout, color: Colors.red),
                    title: Text(
                      t.logout,
                      style: const TextStyle(color: Colors.red),
                    ),
                    onTap: () => _confirmLogout(context),
                  ),
                ),
              ],
            ),
    );
  }

  void _showLanguageSheet(BuildContext context) {
    final provider = context.read<LanguageProvider>();
    showModalBottomSheet(
      context: context,
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: const Text("English"),
            onTap: () => provider.setLocale(const Locale('en')),
          ),
          ListTile(
            title: const Text("Greek"),
            onTap: () => provider.setLocale(const Locale('el')),
          ),
        ],
      ),
    );
  }

  void _confirmLogout(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(t.logoutTitle),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(t.cancel),
          ),
          TextButton(
            onPressed: () async {
              await _supabase.auth.signOut();
              if (mounted) Navigator.pop(ctx);
            },
            child: Text(t.logout, style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
