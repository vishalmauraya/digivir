abstract class ApiConstants {
  ApiConstants._();

  static const String baseUrl = String.fromEnvironment(
    'HABOT_API_BASE_URL',
    defaultValue: 'https://api.habotconnect.dev/v1',
  );

  static const String lsaProfileVerificationEndpoint =
      '/lsa/profile-verification';

  static const String headerTraceId = 'trace_id';
  static const String headerLogicHash = 'logic_hash';
  static const String headerContentType = 'Content-Type';
  static const String contentTypeJson = 'application/json';

  static const Duration requestTimeout = Duration(seconds: 15);
}

abstract class SystemThresholds {
  SystemThresholds._();

  static const Duration frictionStallThreshold = Duration(seconds: 5);
}
