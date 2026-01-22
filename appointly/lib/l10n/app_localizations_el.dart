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
  String get editProfile => 'Επεξεργασία Προφίλ';

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
  String get username => 'Όνομα Χρήστη';

  @override
  String get profileUpdated => 'Το προφίλ ενημερώθηκε';

  @override
  String get accountinfo => 'Πληροφορίες Λογαριασμού';

  @override
  String get dateofbirth => 'Ημερομηνία Γέννησης';

  @override
  String get email => 'Ηλεκτρονικό Ταχυδρομείο';

  @override
  String get notSet => 'Δεν έχει οριστεί';

  @override
  String get firstname => 'Όνομα';

  @override
  String get lastname => 'Επώνυμο';

  @override
  String get appointmentHistory => 'Ιστορικό Ραντεβού';

  @override
  String get seeAll => 'Δείτε Όλα';

  @override
  String get bookPlaceholder => 'Επιλογές Κράτησης';

  @override
  String get step1Title => 'Βήμα 1';

  @override
  String get step1Subtitle => 'Επιλογή Κατηγορίας';

  @override
  String get step2Title => 'Βήμα 2';

  @override
  String get step2Subtitle => 'Επιλογή Παρόχου';

  @override
  String get step3Title => 'Βήμα 3';

  @override
  String get step3Subtitle => 'Επιλογή Ημερομηνίας & Ώρας';

  @override
  String get appointmentsEmptyTitle => 'Δεν υπάρχουν ραντεβού';

  @override
  String get appointmentsEmptySubtitle => 'Φαίνεται πως δεν έχετε προγραμματίσει κάποια επίσκεψη. Ξεκινήστε κάνοντας μια νέα κράτηση!';

  @override
  String get appointmentStatusActive => 'Ενεργό';

  @override
  String get change => 'Αλλαγή';

  @override
  String get cancelAppointment => 'Ακύρωση';

  @override
  String get cancelAppointmentTitle => 'Ακύρωση Ραντεβού';

  @override
  String get cancelAppointmentConfirm => 'Είστε σίγουροι ότι θέλετε να ακυρώσετε αυτό το ραντεβού;';

  @override
  String get no => 'Όχι';

  @override
  String get yesCancel => 'Ναι, Ακύρωση';

  @override
  String get stepSelectService => 'Επιλέξτε Υπηρεσία';

  @override
  String get stepSelectProvider => 'Επιλέξτε Πάροχο';

  @override
  String get stepDateNotes => 'Ημερομηνία & Σημειώσεις';

  @override
  String get availableServices => 'Διαθέσιμες Υπηρεσίες';

  @override
  String get selectProfessional => 'Επιλέξτε Επαγγελματία';

  @override
  String get noProvidersForService => 'Δεν βρέθηκαν πάροχοι για αυτή την υπηρεσία.';

  @override
  String get selectDateTime => 'Επιλέξτε Ημερομηνία & Ώρα';

  @override
  String get notes => 'Σημειώσεις';

  @override
  String get notesHint => 'Προσθέστε τυχόν λεπτομέρειες...';

  @override
  String get confirmBooking => 'Επιβεβαίωση Κράτησης';

  @override
  String get bookingSuccess => 'Η κράτηση ολοκληρώθηκε με επιτυχία!';

  @override
  String bookingError(String error) {
    return 'Σφάλμα κατά την κράτηση: $error';
  }

  @override
  String get todayAppointments => 'Ραντεβού για σήμερα';

  @override
  String get upcomingAppointments => 'Επερχόμενα Ραντεβού';

  @override
  String get seeAllHistory => 'Δείτε όλο το ιστορικό';

  @override
  String get upcomingTab => 'Επερχόμενα';

  @override
  String get completedTab => 'Ολοκληρωμένα';

  @override
  String get noAppointments => 'Δεν υπάρχουν ραντεβού';

  @override
  String get selectCategoryTitle => 'Επιλέξτε Κατηγορία';

  @override
  String get categoriesHint => 'Κατηγορίες';

  @override
  String get selectServiceTitle => 'Επιλέξτε Υπηρεσία';

  @override
  String get servicesHint => 'Υπηρεσίες';

  @override
  String get selectProviderTitle => 'Επιλέξτε Πάροχο';

  @override
  String get providerHint => 'Επαγγελματίας / Κατάστημα';

  @override
  String get dateNotesTitle => 'Ημερομηνία & Σημειώσεις';

  @override
  String selectedDateTime(String datetime) {
    return 'Επιλεγμένο: $datetime';
  }

  @override
  String get notesOptionalHint => 'Σημειώσεις (προαιρετικά)';

  @override
  String get serviceDetailsTitle => 'Λεπτομέρειες Υπηρεσίας';

  @override
  String get noDescription => 'Δεν υπάρχει περιγραφή διαθέσιμη.';

  @override
  String get durationLabel => 'Διάρκεια';

  @override
  String get minutesShort => 'λεπ';

  @override
  String get bookingPastTimeError => 'Δεν μπορείτε να κλείσετε ραντεβού σε ώρα που έχει περάσει!';

  @override
  String providerHoursError(int start, int end) {
    return 'Ωράριο παρόχου: $start:00 - $end:00';
  }

  @override
  String get timeAlreadyBooked => 'Αυτή η ώρα είναι ήδη κλεισμένη! Επιλέξτε άλλη.';

  @override
  String availabilityCheckError(String error) {
    return 'Σφάλμα ελέγχου διαθεσιμότητας: $error';
  }

  @override
  String get historyFilterCategoryHint => 'Κατηγορία';

  @override
  String get historyFilterAllCategories => 'Όλες';

  @override
  String get historyFilterPeriodAll => 'Όλα';

  @override
  String get historyFilterPeriodDay => 'Ημέρα';

  @override
  String get historyFilterPeriodWeek => 'Εβδομάδα';

  @override
  String get historyFilterPeriodMonth => 'Μήνας';

  @override
  String historyError(String error) {
    return 'Σφάλμα: $error';
  }

  @override
  String get historyNoResults => 'Δεν βρέθηκαν ραντεβού.';

  @override
  String get historySummaryAppointments => 'Ραντεβού';

  @override
  String get historySummaryTotal => 'Σύνολο';

  @override
  String get historySummaryHours => 'Ώρες';

  @override
  String get historyFallbackService => 'Υπηρεσία';

  @override
  String get historyFallbackProvider => 'Πάροχος';
}
