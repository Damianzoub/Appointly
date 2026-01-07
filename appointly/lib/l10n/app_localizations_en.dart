// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Appointly';

  @override
  String get homeTitle => 'Home';

  @override
  String get bookTitle => 'Book';

  @override
  String get profileTitle => 'Profile';

  @override
  String welcomeBack(String name) {
    return 'Welcome, $name!';
  }

  @override
  String get homeSubtitle => 'Here you can view upcoming appointments and manage your profile.';

  @override
  String get noAppointmentsToday => 'You have no appointments scheduled for today.';

  @override
  String get editProfile => 'Edit profile';

  @override
  String get language => 'Language';

  @override
  String get logout => 'Logout';

  @override
  String get notLoggedIn => 'You are not logged in';

  @override
  String get login => 'Login';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get logoutTitle => 'Logout';

  @override
  String get logoutConfirm => 'Are you sure you want to logout?';

  @override
  String get loggedOut => 'Logged out successfully';

  @override
  String get goToLogin => 'Go to login';

  @override
  String get username => 'Username';

  @override
  String get profileUpdated => 'Profile updated';
}
