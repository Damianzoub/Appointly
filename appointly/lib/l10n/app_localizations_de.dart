// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Appointly';

  @override
  String get homeTitle => 'Startseite';

  @override
  String get bookTitle => 'Buchen';

  @override
  String get profileTitle => 'Profil';

  @override
  String welcomeBack(String name) {
    return 'Willkommen zurück, $name!';
  }

  @override
  String get homeSubtitle => 'Hier können Sie Ihre bevorstehenden Termine einsehen und Ihr Profil verwalten.';

  @override
  String get noAppointmentsToday => 'Sie haben heute keine geplanten Termine.';

  @override
  String get editProfile => 'Profil bearbeiten';

  @override
  String get language => 'Sprache';

  @override
  String get logout => 'Abmelden';

  @override
  String get notLoggedIn => 'Nicht angemeldet';

  @override
  String get login => 'Anmelden';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get save => 'Speichern';

  @override
  String get logoutTitle => 'Abmelden';

  @override
  String get logoutConfirm => 'Sind Sie sicher, dass Sie sich abmelden möchten?';

  @override
  String get loggedOut => 'Sie wurden erfolgreich abgemeldet';

  @override
  String get goToLogin => 'Zum Login';

  @override
  String get username => 'Benutzername';

  @override
  String get profileUpdated => 'Profil aktualisiert';
}
