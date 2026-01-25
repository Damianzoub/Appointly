// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Appointly';

  @override
  String get homeTitle => 'Inicio';

  @override
  String get bookTitle => 'Reserva';

  @override
  String get profileTitle => 'Perfil';

  @override
  String welcomeBack(String name) {
    return '¡Bienvenido de nuevo, $name!';
  }

  @override
  String get homeSubtitle => 'Aquí puedes ver tus próximas citas y gestionar tu perfil.';

  @override
  String get noAppointmentsToday => 'No tienes citas programadas para hoy.';

  @override
  String get editProfile => 'Editar perfil';

  @override
  String get language => 'Idioma';

  @override
  String get logout => 'Cerrar sesión';

  @override
  String get notLoggedIn => 'No has iniciado sesión';

  @override
  String get login => 'Iniciar sesión';

  @override
  String get cancel => 'Cancelar';

  @override
  String get save => 'Guardar';

  @override
  String get logoutTitle => 'Cerrar sesión';

  @override
  String get logoutConfirm => '¿Estás seguro de que deseas cerrar sesión?';

  @override
  String get loggedOut => 'Has cerrado sesión correctamente';

  @override
  String get goToLogin => 'Ir a inicio de sesión';

  @override
  String get username => 'Nombre de usuario';

  @override
  String get profileUpdated => 'Perfil actualizado';

  @override
  String get accountinfo => 'Información de la cuenta';

  @override
  String get dateofbirth => 'Fecha de nacimiento';

  @override
  String get email => 'Correo electrónico';

  @override
  String get notSet => 'No establecido';

  @override
  String get firstname => 'Nombre';

  @override
  String get lastname => 'Apellido';

  @override
  String get appointmentHistory => 'Historial de citas';

  @override
  String get seeAll => 'Ver todo';

  @override
  String get bookPlaceholder => 'Opciones de reserva';

  @override
  String get step1Title => 'Paso 1';

  @override
  String get step1Subtitle => 'Seleccionar categoría';

  @override
  String get step2Title => 'Paso 2';

  @override
  String get step2Subtitle => 'Seleccionar proveedor';

  @override
  String get step3Title => 'Paso 3';

  @override
  String get step3Subtitle => 'Seleccionar fecha y hora';

  @override
  String get appointmentsEmptyTitle => 'No hay citas';

  @override
  String get appointmentsEmptySubtitle => 'Parece que aún no has programado ninguna visita. ¡Empieza haciendo una nueva reserva!';

  @override
  String get appointmentStatusActive => 'Activa';

  @override
  String get change => 'Cambiar';

  @override
  String get cancelAppointment => 'Cancelar';

  @override
  String get cancelAppointmentTitle => 'Cancelar cita';

  @override
  String get cancelAppointmentConfirm => '¿Estás seguro de que quieres cancelar esta cita?';

  @override
  String get no => 'No';

  @override
  String get yesCancel => 'Sí, cancelar';

  @override
  String get stepSelectService => 'Seleccionar servicio';

  @override
  String get stepSelectProvider => 'Seleccionar profesional';

  @override
  String get stepDateNotes => 'Fecha y notas';

  @override
  String get availableServices => 'Servicios disponibles';

  @override
  String get selectProfessional => 'Selecciona un profesional';

  @override
  String get noProvidersForService => 'No se encontraron profesionales para este servicio.';

  @override
  String get selectDateTime => 'Selecciona fecha y hora';

  @override
  String get notes => 'Notas';

  @override
  String get notesHint => 'Añade cualquier detalle...';

  @override
  String get confirmBooking => 'Confirmar reserva';

  @override
  String get bookingSuccess => '¡Reserva completada con éxito!';

  @override
  String bookingError(String error) {
    return 'Error de reserva: $error';
  }

  @override
  String get todayAppointments => 'Citas de hoy';

  @override
  String get upcomingAppointments => 'Próximas citas';

  @override
  String get seeAllHistory => 'Ver todo el historial';

  @override
  String get upcomingTab => 'Próximas';

  @override
  String get completedTab => 'Completadas';

  @override
  String get noAppointments => 'No hay citas disponibles';

  @override
  String get selectCategoryTitle => 'Selecciona categoría';

  @override
  String get categoriesHint => 'Categorías';

  @override
  String get selectServiceTitle => 'Selecciona servicio';

  @override
  String get servicesHint => 'Servicios';

  @override
  String get selectProviderTitle => 'Selecciona proveedor';

  @override
  String get providerHint => 'Profesional / Tienda';

  @override
  String get dateNotesTitle => 'Fecha y notas';

  @override
  String selectedDateTime(String datetime) {
    return 'Seleccionado: $datetime';
  }

  @override
  String get notesOptionalHint => 'Notas (opcional)';

  @override
  String get serviceDetailsTitle => 'Detalles del servicio';

  @override
  String get noDescription => 'No hay descripción disponible.';

  @override
  String get durationLabel => 'Duración';

  @override
  String get minutesShort => 'min';

  @override
  String get bookingPastTimeError => '¡No puedes reservar una cita en una hora pasada!';

  @override
  String providerHoursError(int start, int end) {
    return 'Horario del proveedor: $start:00 - $end:00';
  }

  @override
  String get timeAlreadyBooked => '¡Esta hora ya está reservada! Elige otra.';

  @override
  String availabilityCheckError(String error) {
    return 'Error al comprobar disponibilidad: $error';
  }

  @override
  String get historyFilterCategoryHint => 'Categoría';

  @override
  String get historyFilterAllCategories => 'Todas';

  @override
  String get historyFilterPeriodAll => 'Todo';

  @override
  String get historyFilterPeriodDay => 'Día';

  @override
  String get historyFilterPeriodWeek => 'Semana';

  @override
  String get historyFilterPeriodMonth => 'Mes';

  @override
  String historyError(String error) {
    return 'Error: $error';
  }

  @override
  String get historyNoResults => 'No se encontraron citas.';

  @override
  String get historySummaryAppointments => 'Citas';

  @override
  String get historySummaryTotal => 'Total';

  @override
  String get historySummaryHours => 'Horas';

  @override
  String get historyFallbackService => 'Servicio';

  @override
  String get historyFallbackProvider => 'Proveedor';

  @override
  String get pastAppointment => 'Completado / Pasado';
}
