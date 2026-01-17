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
  String get selectDateTime => 'Seleccionar fecha y hora';

  @override
  String get notes => 'Notas';

  @override
  String get notesHint => 'Añade cualquier detalle...';

  @override
  String get confirmBooking => 'Confirmar reserva';

  @override
  String get bookingSuccess => '¡La reserva se completó correctamente!';

  @override
  String bookingError(String error) {
    return 'Error al reservar: $error';
  }

  @override
  String get todayAppointments => 'Citas de hoy';

  @override
  String get upcomingAppointments => 'Próximas citas';

  @override
  String get seeAllHistory => 'Ver todo el historial';
}
