import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../app.dart'; // Βεβαιώσου ότι το path οδηγεί στο lib/app.dart
import '../../../language_provider.dart'; // Βεβαιώσου ότι το path οδηγεί στο lib/language_provider.dart
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

  Future<void> _showEditUsernameDialog(BuildContext context) async{
    final t = AppLocalizations.of(context)!;
    final user = _supabase.auth.currentUser;
    if(user ==null) return;

    final ctrl = TextEditingController(
      text: (_profileData?["username"] ?? "").toString(),
    );

    await showDialog(context: context, builder: (ctx)=>
    AlertDialog(
      title: Text(t.username),
      content: TextField(
        controller: ctrl,
        decoration: InputDecoration(
          labelText: t.username,
          border: const OutlineInputBorder()
        ),
      ),
      actions: [
        TextButton(onPressed: ()=> Navigator.pop(ctx), child: Text(t.cancel)),
        TextButton(onPressed: () async{
          final newUsername = ctrl.text.trim();
          if (newUsername.isEmpty) return;

          try{
            final exists = await _supabase
            .from("profiles")
            .select('id')
            .eq("username",newUsername)
            .neq("id",user.id)
            .maybeSingle();

            if (exists !=null){
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Username already exists"))
              );
              return;
            }

            await _supabase
            .from("profiles")
            .update({"username":newUsername})
            .eq('id',user.id);
            
            if(!mounted) return;
            Navigator.pop(ctx);

            await _fetchProfile();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(t.profileUpdated))
            );
          }catch(e){
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("update failed: $e"))
            );
          }

        }, child: Text(t.save))
      ],
    ));
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
      } else {
        if (mounted) setState(() => _isLoading = false);
      }
    } catch (e) {
      debugPrint("Error fetching profile: $e");
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Χρησιμοποιούμε try-catch ή σταθερά κείμενα για να μην κρασάρει αν λείπουν κλειδιά από το .arb
    final t = AppLocalizations.of(context)!;
    final user = _supabase.auth.currentUser;

    final String firstName = _profileData?['first_name'] ?? "";
    final String lastName = _profileData?['last_name'] ?? "";
    final String username  = _profileData?['username']??"";
    String fullName = "$firstName $lastName".trim();

    if (fullName.isEmpty) {
      fullName = auth.displayName;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(t.profileTitle),
        centerTitle: true, // Αυτό το κλειδί υπάρχει
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.indigo,
                    child: Icon(Icons.person, size: 50, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Text(
                    fullName,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    user?.email ?? "",
                    style: const TextStyle(color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 32),
                const Divider(),
                Card(
                      child: ListTile(
                        leading: const Icon(Icons.edit, color: Colors.indigo),
                        title: Text(t.username),
                        subtitle: Text(username.isEmpty ? "-" : username),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => _showEditUsernameDialog(context),
                      ),
                    ),
                const SizedBox(height: 12),
                // ΔΙΟΡΘΩΜΕΝΟ ListTile: Χρήση σταθερού κειμένου για να μην κρασάρει
                Card(
                  child:ListTile(
                  leading: const Icon(Icons.language, color: Colors.indigo),
                  title:  Text(t.language),
                  subtitle: Text(_getCurrentLanguageName(context)),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showLanguageSheet(context),
                  ),
                ),

                const SizedBox(height: 20),

                Card(
                  elevation: 0,
                  color: Colors.red.withOpacity(0.05),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.logout, color: Colors.red),
                    title: Text(
                      t.logout, // Σταθερό κείμενο για ασφάλεια
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () => _confirmLogout(context),
                  ),
                ),
              ],
            ),
    );
  }

  String _getCurrentLanguageName(BuildContext context) {
    final code = Localizations.localeOf(context).languageCode;
    switch (code) {
      case 'el':
        return "Ελληνικά";
      case 'en':
        return "English";
      case 'de':
        return "Deutsch";
      case 'es':
        return "Español";
      case 'fr':
        return "Français";
      default:
        return "English";
    }
  }

  void _showLanguageSheet(BuildContext context) {
    final provider = context.read<LanguageProvider>();

    final List<Map<String, String>> languages = [
      {'name': 'Ελληνικά', 'code': 'el', 'flag': '🇬🇷'},
      {'name': 'English', 'code': 'en', 'flag': '🇺🇸'},
      {'name': 'Deutsch', 'code': 'de', 'flag': '🇩🇪'},
      {'name': 'Español', 'code': 'es', 'flag': '🇪🇸'},
      {'name': 'Français', 'code': 'fr', 'flag': '🇫🇷'},
    ];

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: languages.map((lang) {
              final isSelected =
                  Localizations.localeOf(context).languageCode == lang['code'];
              return ListTile(
                leading: Text(
                  lang['flag']!,
                  style: const TextStyle(fontSize: 24),
                ),
                title: Text(
                  lang['name']!,
                  style: TextStyle(
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                    color: isSelected ? Colors.indigo : Colors.black,
                  ),
                ),
                trailing: isSelected
                    ? const Icon(Icons.check, color: Colors.indigo)
                    : null,
                onTap: () {
                  provider.setLocale(Locale(lang['code']!));
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Αποσύνδεση"),
        content: const Text("Είστε σίγουροι ότι θέλετε να αποσυνδεθείτε;"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Ακύρωση"),
          ),
          TextButton(
            onPressed: () async {
              await _supabase.auth.signOut();
              if (mounted) {
                Navigator.of(ctx).pop();
                Navigator.of(
                  context,
                ).pushNamedAndRemoveUntil('/', (route) => false);
              }
            },
            child: const Text("Έξοδος", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
