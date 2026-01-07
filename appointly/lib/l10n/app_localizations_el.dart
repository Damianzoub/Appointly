// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Modern Greek (`el`).
class AppLocalizationsEl extends AppLocalizations {
  AppLocalizationsEl([String locale = 'el']) : super(locale);

  @override
  String get appTitle => 'Appointly';

  @override
  String get homeTitle => 'Αρχική';

  @override
  String get bookTitle => 'Κράτηση';

  @override
  String get profileTitle => 'Προφίλ';

  @override
  String welcomeBack(String name) {
    return 'Καλώς ήρθες, $name!';
  }

  @override
  String get homeSubtitle => 'Εδώ μπορείτε να δείτε τα προσεχή ραντεβού σας και να διαχειριστείτε το προφίλ σας.';

  @override
  String get noAppointmentsToday => 'Δεν έχετε προγραμματισμένα ραντεβού για σήμερα.';

  @override
  String get editProfile => 'Επεξεργασία προφίλ';

  @override
  String get language => 'Γλώσσα';

  @override
  String get logout => 'Αποσύνδεση';

  @override
  String get notLoggedIn => 'Δεν είστε συνδεδεμένος';

  @override
  String get login => 'Σύνδεση';

  @override
  String get cancel => 'Ακύρωση';

  @override
  String get save => 'Αποθήκευση';

  @override
  String get logoutTitle => 'Αποσύνδεση';

  @override
  String get logoutConfirm => 'Είστε σίγουροι ότι θέλετε να αποσυνδεθείτε;';

  @override
  String get loggedOut => 'Αποσυνδεθήκατε με επιτυχία';

  @override
  String get goToLogin => 'Μετάβαση στη σύνδεση';

  @override
  String get username => 'Όνομα χρήστη';

  @override
  String get profileUpdated => 'Το προφίλ ενημερώθηκε';
}
