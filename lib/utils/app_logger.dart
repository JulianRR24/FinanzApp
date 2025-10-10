import 'package:logger/logger.dart';

/// Clase de utilidad para el manejo de logs en la aplicación.
/// Proporciona métodos estáticos para diferentes niveles de registro.
class AppLogger {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0, // Número de líneas de pila a mostrar
      errorMethodCount: 5, // Número de líneas de pila a mostrar en errores
      lineLength: 50, // Ancho de la salida
      colors: true, // Habilita colores en consola
      printEmojis: true, // Habilita emojis
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart, // Muestra el tiempo de cada mensaje
    ),
  );

  /// Registra un mensaje de depuración
  static void d(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.d(message, error: error, stackTrace: stackTrace);
  }

  /// Registra un mensaje informativo
  static void i(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.i(message, error: error, stackTrace: stackTrace);
  }

  /// Registra un mensaje de advertencia
  static void w(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.w(message, error: error, stackTrace: stackTrace);
  }

  /// Registra un mensaje de error
  static void e(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }

  /// Registra un mensaje de error crítico
  static void f(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.f(message, error: error, stackTrace: stackTrace);
  }

  /// Registra un mensaje con un nivel personalizado
  static void log(
    Level level,
    dynamic message, [
    dynamic error, 
    StackTrace? stackTrace,
  ]) {
    _logger.log(level, message, error: error, stackTrace: stackTrace);
  }
}
