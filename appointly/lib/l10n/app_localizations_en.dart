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
  String get bookTitle => 'Booking';

  @override
  String get profileTitle => 'Profile';

  @override
  String welcomeBack(String name) {
    return 'Welcome back, $name!';
  }

  @override
  String get homeSubtitle => 'Here you can view your upcoming appointments and manage your profile.';

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
  String get logoutConfirm => 'Are you sure you want to log out?';

  @override
  String get loggedOut => 'You have successfully logged out';

  @override
  String get goToLogin => 'Go to login';

  @override
  String get username => 'Username';

  @override
  String get profileUpdated => 'Profile updated';

  @override
  String get accountinfo => 'Account information';

  @override
  String get dateofbirth => 'Date of birth';

  @override
  String get email => 'Email';

  @override
  String get notSet => 'Not set';

  @override
  String get firstname => 'First name';

  @override
  String get lastname => 'Last name';

  @override
  String get appointmentHistory => 'Appointment history';

  @override
  String get seeAll => 'See all';

  @override
  String get bookPlaceholder => 'Booking options';

  @override
  String get step1Title => 'Step 1';

  @override
  String get step1Subtitle => 'Select category';

  @override
  String get step2Title => 'Step 2';

  @override
  String get step2Subtitle => 'Select provider';

  @override
  String get step3Title => 'Step 3';

  @override
  String get step3Subtitle => 'Select date & time';

  @override
  String get appointmentsEmptyTitle => 'No appointments';

  @override
  String get appointmentsEmptySubtitle => 'It looks like you haven\'t scheduled any visits yet. Start by making a new booking!';

  @override
  String get appointmentStatusActive => 'Active';

  @override
  String get change => 'Change';

  @override
  String get cancelAppointment => 'Cancel';

  @override
  String get cancelAppointmentTitle => 'Cancel appointment';

  @override
  String get cancelAppointmentConfirm => 'Are you sure you want to cancel this appointment?';

  @override
  String get no => 'No';

  @override
  String get yesCancel => 'Yes, cancel';

  @override
  String get stepSelectService => 'Select service';

  @override
  String get stepSelectProvider => 'Select provider';

  @override
  String get stepDateNotes => 'Date & notes';

  @override
  String get availableServices => 'Available services';

  @override
  String get selectProfessional => 'Select professional';

  @override
  String get noProvidersForService => 'No providers found for this service.';

  @override
  String get selectDateTime => 'Select date & time';

  @override
  String get notes => 'Notes';

  @override
  String get notesHint => 'Add any details...';

  @override
  String get confirmBooking => 'Confirm booking';

  @override
  String get bookingSuccess => 'Booking completed successfully!';

  @override
  String bookingError(String error) {
    return 'Booking error: $error';
  }

  @override
  String get todayAppointments => 'Today\'s Appointments';

  @override
  String get upcomingAppointments => 'Upcoming Appointments';

  @override
  String get seeAllHistory => 'See all history';

  @override
  String get upcomingTab => 'Upcoming';

  @override
  String get completedTab => 'Completed';

  @override
  String get noAppointments => 'No appointments available';

  @override
  String get selectCategoryTitle => 'Select category';

  @override
  String get categoriesHint => 'Categories';

  @override
  String get selectServiceTitle => 'Select service';

  @override
  String get servicesHint => 'Services';

  @override
  String get selectProviderTitle => 'Select provider';

  @override
  String get providerHint => 'Professional / Store';

  @override
  String get dateNotesTitle => 'Date & notes';

  @override
  String selectedDateTime(String datetime) {
    return 'Selected: $datetime';
  }

  @override
  String get notesOptionalHint => 'Notes (optional)';

  @override
  String get serviceDetailsTitle => 'Service details';

  @override
  String get noDescription => 'No description available.';

  @override
  String get durationLabel => 'Duration';

  @override
  String get minutesShort => 'min';

  @override
  String get bookingPastTimeError => 'You can\'t book an appointment in a past time!';

  @override
  String providerHoursError(int start, int end) {
    return 'Provider hours: $start:00 - $end:00';
  }

  @override
  String get timeAlreadyBooked => 'This time slot is already booked! Choose another one.';

  @override
  String availabilityCheckError(String error) {
    return 'Availability check error: $error';
  }

  @override
  String get historyFilterCategoryHint => 'Category';

  @override
  String get historyFilterAllCategories => 'All';

  @override
  String get historyFilterPeriodAll => 'All';

  @override
  String get historyFilterPeriodDay => 'Day';

  @override
  String get historyFilterPeriodWeek => 'Week';

  @override
  String get historyFilterPeriodMonth => 'Month';

  @override
  String historyError(String error) {
    return 'Error: $error';
  }

  @override
  String get historyNoResults => 'No appointments found.';

  @override
  String get historySummaryAppointments => 'Appointments';

  @override
  String get historySummaryTotal => 'Total';

  @override
  String get historySummaryHours => 'Hours';

  @override
  String get historyFallbackService => 'Service';

  @override
  String get historyFallbackProvider => 'Provider';

  @override
  String get pastAppointment => 'Completed / Past';
}
