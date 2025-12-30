// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Application de rendez-vous';

  @override
  String get home => 'Accueil';

  @override
  String get book => 'Réserver';

  @override
  String get welcome => 'Bienvenue';

  @override
  String get chooseLanguage => 'Choisir la langue';

  @override
  String get confirm => 'Confirmer';

  @override
  String get cancel => 'Annuler';
}
