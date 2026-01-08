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
  String get bookTitle => 'Reservar';

  @override
  String get profileTitle => 'Perfil';

  @override
  String welcomeBack(String name) {
    return '¡Bienvenido, $name!';
  }

  @override
  String get homeSubtitle => 'Aquí puedes ver las próximas citas y gestionar tu perfil.';

  @override
  String get noAppointmentsToday => 'No hay citas programadas para hoy.';

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
  String get loggedOut => 'Sesión cerrada correctamente';

  @override
  String get goToLogin => 'Ir a iniciar sesión';

  @override
  String get username => 'Nombre de usuario';

  @override
  String get profileUpdated => 'Perfil actualizado';

  @override
  String get bookPlaceholder => 'Opciones de reserva';

  @override
  String get step1Title => 'Paso 1';

  @override
  String get step1Subtitle => 'Elegir categoría';

  @override
  String get step2Title => 'Paso 2';

  @override
  String get step2Subtitle => 'Elegir proveedor';

  @override
  String get step3Title => 'Paso 3';

  @override
  String get step3Subtitle => 'Seleccionar fecha y hora';
}
