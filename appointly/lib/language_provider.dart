import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider extends ChangeNotifier {
  static const _storageKey = 'language_code';
  Locale _locale = const Locale('en'); // Προεπιλεγμένη γλώσσα τα Αγγλικά
  Locale get locale => _locale;

  LanguageProvider() {
    _loadSavedLanguage(); // Φόρτωση της αποθηκευμένης γλώσσας κατά την εκκίνηση
  }

  // Ανάκτηση της γλώσσας από τη μνήμη της συσκευής
  Future<void> _loadSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_storageKey);

    if (code != null) {
      _locale = Locale(code);
      notifyListeners();
    }
  }

  // Αλλαγή και αποθήκευση της νέας γλώσσας
  Future<void> setLocale(Locale locale) async {
    if (_locale == locale) return;
    _locale = locale;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, locale.languageCode);
  }
}
