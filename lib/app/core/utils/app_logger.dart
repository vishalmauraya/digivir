import 'dart:developer' as developer;


abstract class AppLogger {
  AppLogger._();

  static void info(String message, {String tag = 'HABOT'}) {
    developer.log(message, name: tag, level: 800);
  }

  static void warning(String message, {String tag = 'HABOT'}) {
    developer.log(message, name: tag, level: 900);
  }

  static void error(
    String message, {
    String tag = 'HABOT',
    Object? error,
    StackTrace? stackTrace,
  }) {
    developer.log(
      message,
      name: tag,
      level: 1000,
      error: error,
      stackTrace: stackTrace,
    );
  }


  static void securityQuarantine(String reason) {
    developer.log(
      'FAIL-CLOSED QUARANTINE: $reason',
      name: 'HABOT_SECURITY',
      level: 1200,
    );
  }
}
