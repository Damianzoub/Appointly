// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Appointly';

  @override
  String get homeTitle => 'Accueil';

  @override
  String get bookTitle => 'Réserver';

  @override
  String get profileTitle => 'Profil';

  @override
  String welcomeBack(String name) {
    return 'Bienvenue, $name!';
  }

  @override
  String get homeSubtitle => 'Ici, vous pouvez voir les rendez-vous à venir et gérer votre profil.';

  @override
  String get noAppointmentsToday => 'Aucun rendez-vous prévu pour aujourd\'hui.';

  @override
  String get editProfile => 'Modifier le profil';

  @override
  String get language => 'Langue';

  @override
  String get logout => 'Se déconnecter';

  @override
  String get notLoggedIn => 'Vous n\'êtes pas connecté';

  @override
  String get login => 'Se connecter';

  @override
  String get cancel => 'Annuler';

  @override
  String get save => 'Enregistrer';

  @override
  String get logoutTitle => 'Déconnexion';

  @override
  String get logoutConfirm => 'Êtes-vous sûr de vouloir vous déconnecter ?';

  @override
  String get loggedOut => 'Déconnecté avec succès';

  @override
  String get goToLogin => 'Aller à la connexion';

  @override
  String get username => 'Nom d’utilisateur';

  @override
  String get profileUpdated => 'Profil mis à jour';
}
