import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_el.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('el'),
    Locale('en'),
    Locale('es'),
    Locale('fr')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Appointly'**
  String get appTitle;

  /// No description provided for @homeTitle.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeTitle;

  /// No description provided for @bookTitle.
  ///
  /// In en, this message translates to:
  /// **'Booking'**
  String get bookTitle;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back, {name}!'**
  String welcomeBack(String name);

  /// No description provided for @homeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Here you can view your upcoming appointments and manage your profile.'**
  String get homeSubtitle;

  /// No description provided for @noAppointmentsToday.
  ///
  /// In en, this message translates to:
  /// **'You have no appointments scheduled for today.'**
  String get noAppointmentsToday;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit profile'**
  String get editProfile;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @notLoggedIn.
  ///
  /// In en, this message translates to:
  /// **'You are not logged in'**
  String get notLoggedIn;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @logoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logoutTitle;

  /// No description provided for @logoutConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out?'**
  String get logoutConfirm;

  /// No description provided for @loggedOut.
  ///
  /// In en, this message translates to:
  /// **'You have successfully logged out'**
  String get loggedOut;

  /// No description provided for @goToLogin.
  ///
  /// In en, this message translates to:
  /// **'Go to login'**
  String get goToLogin;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @profileUpdated.
  ///
  /// In en, this message translates to:
  /// **'Profile updated'**
  String get profileUpdated;

  /// No description provided for @accountinfo.
  ///
  /// In en, this message translates to:
  /// **'Account information'**
  String get accountinfo;

  /// No description provided for @dateofbirth.
  ///
  /// In en, this message translates to:
  /// **'Date of birth'**
  String get dateofbirth;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @notSet.
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get notSet;

  /// No description provided for @firstname.
  ///
  /// In en, this message translates to:
  /// **'First name'**
  String get firstname;

  /// No description provided for @lastname.
  ///
  /// In en, this message translates to:
  /// **'Last name'**
  String get lastname;

  /// No description provided for @appointmentHistory.
  ///
  /// In en, this message translates to:
  /// **'Appointment history'**
  String get appointmentHistory;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get seeAll;

  /// No description provided for @bookPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Booking options'**
  String get bookPlaceholder;

  /// No description provided for @step1Title.
  ///
  /// In en, this message translates to:
  /// **'Step 1'**
  String get step1Title;

  /// No description provided for @step1Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Select category'**
  String get step1Subtitle;

  /// No description provided for @step2Title.
  ///
  /// In en, this message translates to:
  /// **'Step 2'**
  String get step2Title;

  /// No description provided for @step2Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Select provider'**
  String get step2Subtitle;

  /// No description provided for @step3Title.
  ///
  /// In en, this message translates to:
  /// **'Step 3'**
  String get step3Title;

  /// No description provided for @step3Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Select date & time'**
  String get step3Subtitle;

  /// No description provided for @appointmentsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No appointments'**
  String get appointmentsEmptyTitle;

  /// No description provided for @appointmentsEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'It looks like you haven\'t scheduled any visits yet. Start by making a new booking!'**
  String get appointmentsEmptySubtitle;

  /// No description provided for @appointmentStatusActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get appointmentStatusActive;

  /// No description provided for @change.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get change;

  /// No description provided for @cancelAppointment.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelAppointment;

  /// No description provided for @cancelAppointmentTitle.
  ///
  /// In en, this message translates to:
  /// **'Cancel appointment'**
  String get cancelAppointmentTitle;

  /// No description provided for @cancelAppointmentConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to cancel this appointment?'**
  String get cancelAppointmentConfirm;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @yesCancel.
  ///
  /// In en, this message translates to:
  /// **'Yes, cancel'**
  String get yesCancel;

  /// No description provided for @stepSelectService.
  ///
  /// In en, this message translates to:
  /// **'Select service'**
  String get stepSelectService;

  /// No description provided for @stepSelectProvider.
  ///
  /// In en, this message translates to:
  /// **'Select provider'**
  String get stepSelectProvider;

  /// No description provided for @stepDateNotes.
  ///
  /// In en, this message translates to:
  /// **'Date & notes'**
  String get stepDateNotes;

  /// No description provided for @availableServices.
  ///
  /// In en, this message translates to:
  /// **'Available services'**
  String get availableServices;

  /// No description provided for @selectProfessional.
  ///
  /// In en, this message translates to:
  /// **'Select professional'**
  String get selectProfessional;

  /// No description provided for @noProvidersForService.
  ///
  /// In en, this message translates to:
  /// **'No providers found for this service.'**
  String get noProvidersForService;

  /// No description provided for @selectDateTime.
  ///
  /// In en, this message translates to:
  /// **'Select date & time'**
  String get selectDateTime;

  /// No description provided for @notes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// No description provided for @notesHint.
  ///
  /// In en, this message translates to:
  /// **'Add any details...'**
  String get notesHint;

  /// No description provided for @confirmBooking.
  ///
  /// In en, this message translates to:
  /// **'Confirm booking'**
  String get confirmBooking;

  /// No description provided for @bookingSuccess.
  ///
  /// In en, this message translates to:
  /// **'Booking completed successfully!'**
  String get bookingSuccess;

  /// No description provided for @bookingError.
  ///
  /// In en, this message translates to:
  /// **'Booking error: {error}'**
  String bookingError(String error);

  /// No description provided for @todayAppointments.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Appointments'**
  String get todayAppointments;

  /// No description provided for @upcomingAppointments.
  ///
  /// In en, this message translates to:
  /// **'Upcoming Appointments'**
  String get upcomingAppointments;

  /// No description provided for @seeAllHistory.
  ///
  /// In en, this message translates to:
  /// **'See all history'**
  String get seeAllHistory;

  /// No description provided for @upcomingTab.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get upcomingTab;

  /// No description provided for @completedTab.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completedTab;

  /// No description provided for @noAppointments.
  ///
  /// In en, this message translates to:
  /// **'No appointments available'**
  String get noAppointments;

  /// No description provided for @selectCategoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Select category'**
  String get selectCategoryTitle;

  /// No description provided for @categoriesHint.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categoriesHint;

  /// No description provided for @selectServiceTitle.
  ///
  /// In en, this message translates to:
  /// **'Select service'**
  String get selectServiceTitle;

  /// No description provided for @servicesHint.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get servicesHint;

  /// No description provided for @selectProviderTitle.
  ///
  /// In en, this message translates to:
  /// **'Select provider'**
  String get selectProviderTitle;

  /// No description provided for @providerHint.
  ///
  /// In en, this message translates to:
  /// **'Professional / Store'**
  String get providerHint;

  /// No description provided for @dateNotesTitle.
  ///
  /// In en, this message translates to:
  /// **'Date & notes'**
  String get dateNotesTitle;

  /// No description provided for @selectedDateTime.
  ///
  /// In en, this message translates to:
  /// **'Selected: {datetime}'**
  String selectedDateTime(String datetime);

  /// No description provided for @notesOptionalHint.
  ///
  /// In en, this message translates to:
  /// **'Notes (optional)'**
  String get notesOptionalHint;

  /// No description provided for @serviceDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Service details'**
  String get serviceDetailsTitle;

  /// No description provided for @noDescription.
  ///
  /// In en, this message translates to:
  /// **'No description available.'**
  String get noDescription;

  /// No description provided for @durationLabel.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get durationLabel;

  /// No description provided for @minutesShort.
  ///
  /// In en, this message translates to:
  /// **'min'**
  String get minutesShort;

  /// No description provided for @bookingPastTimeError.
  ///
  /// In en, this message translates to:
  /// **'You can\'t book an appointment in a past time!'**
  String get bookingPastTimeError;

  /// No description provided for @providerHoursError.
  ///
  /// In en, this message translates to:
  /// **'Provider hours: {start}:00 - {end}:00'**
  String providerHoursError(int start, int end);

  /// No description provided for @timeAlreadyBooked.
  ///
  /// In en, this message translates to:
  /// **'This time slot is already booked! Choose another one.'**
  String get timeAlreadyBooked;

  /// No description provided for @availabilityCheckError.
  ///
  /// In en, this message translates to:
  /// **'Availability check error: {error}'**
  String availabilityCheckError(String error);

  /// No description provided for @historyFilterCategoryHint.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get historyFilterCategoryHint;

  /// No description provided for @historyFilterAllCategories.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get historyFilterAllCategories;

  /// No description provided for @historyFilterPeriodAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get historyFilterPeriodAll;

  /// No description provided for @historyFilterPeriodDay.
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get historyFilterPeriodDay;

  /// No description provided for @historyFilterPeriodWeek.
  ///
  /// In en, this message translates to:
  /// **'Week'**
  String get historyFilterPeriodWeek;

  /// No description provided for @historyFilterPeriodMonth.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get historyFilterPeriodMonth;

  /// No description provided for @historyError.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String historyError(String error);

  /// No description provided for @historyNoResults.
  ///
  /// In en, this message translates to:
  /// **'No appointments found.'**
  String get historyNoResults;

  /// No description provided for @historySummaryAppointments.
  ///
  /// In en, this message translates to:
  /// **'Appointments'**
  String get historySummaryAppointments;

  /// No description provided for @historySummaryTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get historySummaryTotal;

  /// No description provided for @historySummaryHours.
  ///
  /// In en, this message translates to:
  /// **'Hours'**
  String get historySummaryHours;

  /// No description provided for @historyFallbackService.
  ///
  /// In en, this message translates to:
  /// **'Service'**
  String get historyFallbackService;

  /// No description provided for @historyFallbackProvider.
  ///
  /// In en, this message translates to:
  /// **'Provider'**
  String get historyFallbackProvider;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['de', 'el', 'en', 'es', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de': return AppLocalizationsDe();
    case 'el': return AppLocalizationsEl();
    case 'en': return AppLocalizationsEn();
    case 'es': return AppLocalizationsEs();
    case 'fr': return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
