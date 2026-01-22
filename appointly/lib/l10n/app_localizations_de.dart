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
  String get bookTitle => 'Buchung';

  @override
  String get profileTitle => 'Profil';

  @override
  String welcomeBack(String name) {
    return 'Willkommen zurück, $name!';
  }

  @override
  String get homeSubtitle => 'Hier können Sie Ihre kommenden Termine sehen und Ihr Profil verwalten.';

  @override
  String get noAppointmentsToday => 'Sie haben heute keine geplanten Termine.';

  @override
  String get editProfile => 'Profil bearbeiten';

  @override
  String get language => 'Sprache';

  @override
  String get logout => 'Abmelden';

  @override
  String get notLoggedIn => 'Sie sind nicht angemeldet';

  @override
  String get login => 'Anmelden';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get save => 'Speichern';

  @override
  String get logoutTitle => 'Abmelden';

  @override
  String get logoutConfirm => 'Möchten Sie sich wirklich abmelden?';

  @override
  String get loggedOut => 'Sie wurden erfolgreich abgemeldet';

  @override
  String get goToLogin => 'Zur Anmeldung';

  @override
  String get username => 'Benutzername';

  @override
  String get profileUpdated => 'Profil aktualisiert';

  @override
  String get accountinfo => 'Kontoinformationen';

  @override
  String get dateofbirth => 'Geburtsdatum';

  @override
  String get email => 'E-Mail';

  @override
  String get notSet => 'Nicht festgelegt';

  @override
  String get firstname => 'Vorname';

  @override
  String get lastname => 'Nachname';

  @override
  String get appointmentHistory => 'Terminverlauf';

  @override
  String get seeAll => 'Alle anzeigen';

  @override
  String get bookPlaceholder => 'Buchungsoptionen';

  @override
  String get step1Title => 'Schritt 1';

  @override
  String get step1Subtitle => 'Kategorie auswählen';

  @override
  String get step2Title => 'Schritt 2';

  @override
  String get step2Subtitle => 'Anbieter auswählen';

  @override
  String get step3Title => 'Schritt 3';

  @override
  String get step3Subtitle => 'Datum und Uhrzeit auswählen';

  @override
  String get appointmentsEmptyTitle => 'Keine Termine';

  @override
  String get appointmentsEmptySubtitle => 'Es sieht so aus, als hätten Sie noch keinen Termin geplant. Starten Sie mit einer neuen Buchung!';

  @override
  String get appointmentStatusActive => 'Aktiv';

  @override
  String get change => 'Ändern';

  @override
  String get cancelAppointment => 'Stornieren';

  @override
  String get cancelAppointmentTitle => 'Termin stornieren';

  @override
  String get cancelAppointmentConfirm => 'Möchten Sie diesen Termin wirklich stornieren?';

  @override
  String get no => 'Nein';

  @override
  String get yesCancel => 'Ja, stornieren';

  @override
  String get stepSelectService => 'Dienstleistung auswählen';

  @override
  String get stepSelectProvider => 'Anbieter auswählen';

  @override
  String get stepDateNotes => 'Datum und Notizen';

  @override
  String get availableServices => 'Verfügbare Dienstleistungen';

  @override
  String get selectProfessional => 'Anbieter auswählen';

  @override
  String get noProvidersForService => 'Für diese Dienstleistung wurden keine Anbieter gefunden.';

  @override
  String get selectDateTime => 'Datum und Uhrzeit auswählen';

  @override
  String get notes => 'Notizen';

  @override
  String get notesHint => 'Fügen Sie Details hinzu...';

  @override
  String get confirmBooking => 'Buchung bestätigen';

  @override
  String get bookingSuccess => 'Buchung erfolgreich abgeschlossen!';

  @override
  String bookingError(String error) {
    return 'Buchungsfehler: $error';
  }

  @override
  String get todayAppointments => 'Termine für heute';

  @override
  String get upcomingAppointments => 'Kommende Termine';

  @override
  String get seeAllHistory => 'Gesamten Verlauf anzeigen';

  @override
  String get upcomingTab => 'Kommend';

  @override
  String get completedTab => 'Abgeschlossen';

  @override
  String get noAppointments => 'Keine Termine verfügbar';

  @override
  String get selectCategoryTitle => 'Kategorie auswählen';

  @override
  String get categoriesHint => 'Kategorien';

  @override
  String get selectServiceTitle => 'Service auswählen';

  @override
  String get servicesHint => 'Services';

  @override
  String get selectProviderTitle => 'Anbieter auswählen';

  @override
  String get providerHint => 'Profi / Geschäft';

  @override
  String get dateNotesTitle => 'Datum und Notizen';

  @override
  String selectedDateTime(String datetime) {
    return 'Ausgewählt: $datetime';
  }

  @override
  String get notesOptionalHint => 'Notizen (optional)';

  @override
  String get serviceDetailsTitle => 'Service-Details';

  @override
  String get noDescription => 'Keine Beschreibung verfügbar.';

  @override
  String get durationLabel => 'Dauer';

  @override
  String get minutesShort => 'Min.';

  @override
  String get bookingPastTimeError => 'Du kannst keinen Termin in der Vergangenheit buchen!';

  @override
  String providerHoursError(int start, int end) {
    return 'Öffnungszeiten: $start:00 - $end:00';
  }

  @override
  String get timeAlreadyBooked => 'Diese Uhrzeit ist bereits gebucht! Bitte wähle eine andere.';

  @override
  String availabilityCheckError(String error) {
    return 'Fehler bei der Verfügbarkeitsprüfung: $error';
  }

  @override
  String get historyFilterCategoryHint => 'Kategorie';

  @override
  String get historyFilterAllCategories => 'Alle';

  @override
  String get historyFilterPeriodAll => 'Alle';

  @override
  String get historyFilterPeriodDay => 'Tag';

  @override
  String get historyFilterPeriodWeek => 'Woche';

  @override
  String get historyFilterPeriodMonth => 'Monat';

  @override
  String historyError(String error) {
    return 'Fehler: $error';
  }

  @override
  String get historyNoResults => 'Keine Termine gefunden.';

  @override
  String get historySummaryAppointments => 'Termine';

  @override
  String get historySummaryTotal => 'Summe';

  @override
  String get historySummaryHours => 'Stunden';

  @override
  String get historyFallbackService => 'Service';

  @override
  String get historyFallbackProvider => 'Anbieter';
}
