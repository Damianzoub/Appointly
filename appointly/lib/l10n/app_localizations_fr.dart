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
  String get bookTitle => 'Réservation';

  @override
  String get profileTitle => 'Profil';

  @override
  String welcomeBack(String name) {
    return 'Bon retour, $name !';
  }

  @override
  String get homeSubtitle => 'Ici, vous pouvez voir vos rendez-vous à venir et gérer votre profil.';

  @override
  String get noAppointmentsToday => 'Vous n\'avez aucun rendez-vous prévu aujourd\'hui.';

  @override
  String get editProfile => 'Modifier le profil';

  @override
  String get language => 'Langue';

  @override
  String get logout => 'Déconnexion';

  @override
  String get notLoggedIn => 'Vous n\'êtes pas connecté';

  @override
  String get login => 'Connexion';

  @override
  String get cancel => 'Annuler';

  @override
  String get save => 'Enregistrer';

  @override
  String get logoutTitle => 'Déconnexion';

  @override
  String get logoutConfirm => 'Êtes-vous sûr de vouloir vous déconnecter ?';

  @override
  String get loggedOut => 'Déconnexion réussie';

  @override
  String get goToLogin => 'Aller à la connexion';

  @override
  String get username => 'Nom d\'utilisateur';

  @override
  String get profileUpdated => 'Profil mis à jour';

  @override
  String get accountinfo => 'Informations du compte';

  @override
  String get dateofbirth => 'Date de naissance';

  @override
  String get email => 'Email';

  @override
  String get notSet => 'Non défini';

  @override
  String get firstname => 'Prénom';

  @override
  String get lastname => 'Nom';

  @override
  String get appointmentHistory => 'Historique des rendez-vous';

  @override
  String get seeAll => 'Voir tout';

  @override
  String get bookPlaceholder => 'Options de réservation';

  @override
  String get step1Title => 'Étape 1';

  @override
  String get step1Subtitle => 'Sélection de la catégorie';

  @override
  String get step2Title => 'Étape 2';

  @override
  String get step2Subtitle => 'Sélection du prestataire';

  @override
  String get step3Title => 'Étape 3';

  @override
  String get step3Subtitle => 'Sélection de la date et de l\'heure';

  @override
  String get appointmentsEmptyTitle => 'Aucun rendez-vous';

  @override
  String get appointmentsEmptySubtitle => 'Il semble que vous n’ayez encore programmé aucune visite. Commencez par faire une nouvelle réservation !';

  @override
  String get appointmentStatusActive => 'Actif';

  @override
  String get change => 'Modifier';

  @override
  String get cancelAppointment => 'Annuler';

  @override
  String get cancelAppointmentTitle => 'Annuler le rendez-vous';

  @override
  String get cancelAppointmentConfirm => 'Êtes-vous sûr de vouloir annuler ce rendez-vous ?';

  @override
  String get no => 'Non';

  @override
  String get yesCancel => 'Oui, annuler';

  @override
  String get stepSelectService => 'Sélectionner un service';

  @override
  String get stepSelectProvider => 'Sélectionner un professionnel';

  @override
  String get stepDateNotes => 'Date et notes';

  @override
  String get availableServices => 'Services disponibles';

  @override
  String get selectProfessional => 'Sélectionnez un professionnel';

  @override
  String get noProvidersForService => 'Aucun professionnel trouvé pour ce service.';

  @override
  String get selectDateTime => 'Choisir la date et l\'heure';

  @override
  String get notes => 'Notes';

  @override
  String get notesHint => 'Ajoutez des détails...';

  @override
  String get confirmBooking => 'Confirmer la réservation';

  @override
  String get bookingSuccess => 'Réservation effectuée avec succès !';

  @override
  String bookingError(String error) {
    return 'Erreur de réservation : $error';
  }

  @override
  String get todayAppointments => 'Rendez-vous d\'aujourd\'hui';

  @override
  String get upcomingAppointments => 'Prochains rendez-vous';

  @override
  String get seeAllHistory => 'Voir tout l\'historique';

  @override
  String get upcomingTab => 'À venir';

  @override
  String get completedTab => 'Terminés';

  @override
  String get noAppointments => 'Aucun rendez-vous disponible';

  @override
  String get selectCategoryTitle => 'Choisir une catégorie';

  @override
  String get categoriesHint => 'Catégories';

  @override
  String get selectServiceTitle => 'Choisir un service';

  @override
  String get servicesHint => 'Services';

  @override
  String get selectProviderTitle => 'Choisir un prestataire';

  @override
  String get providerHint => 'Professionnel / Boutique';

  @override
  String get dateNotesTitle => 'Date et notes';

  @override
  String selectedDateTime(String datetime) {
    return 'Sélectionné : $datetime';
  }

  @override
  String get notesOptionalHint => 'Notes (facultatif)';

  @override
  String get serviceDetailsTitle => 'Détails du service';

  @override
  String get noDescription => 'Aucune description disponible.';

  @override
  String get durationLabel => 'Durée';

  @override
  String get minutesShort => 'min';

  @override
  String get bookingPastTimeError => 'Vous ne pouvez pas réserver à une heure déjà passée !';

  @override
  String providerHoursError(int start, int end) {
    return 'Horaires du prestataire : $start:00 - $end:00';
  }

  @override
  String get timeAlreadyBooked => 'Ce créneau est déjà réservé ! Choisissez-en un autre.';

  @override
  String availabilityCheckError(String error) {
    return 'Erreur de vérification de disponibilité : $error';
  }

  @override
  String get historyFilterCategoryHint => 'Catégorie';

  @override
  String get historyFilterAllCategories => 'Toutes';

  @override
  String get historyFilterPeriodAll => 'Tout';

  @override
  String get historyFilterPeriodDay => 'Jour';

  @override
  String get historyFilterPeriodWeek => 'Semaine';

  @override
  String get historyFilterPeriodMonth => 'Mois';

  @override
  String historyError(String error) {
    return 'Erreur : $error';
  }

  @override
  String get historyNoResults => 'Aucun rendez-vous trouvé.';

  @override
  String get historySummaryAppointments => 'Rendez-vous';

  @override
  String get historySummaryTotal => 'Total';

  @override
  String get historySummaryHours => 'Heures';

  @override
  String get historyFallbackService => 'Service';

  @override
  String get historyFallbackProvider => 'Prestataire';
}
