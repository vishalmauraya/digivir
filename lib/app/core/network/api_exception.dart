sealed class ApiException implements Exception {
  final String message;
  const ApiException(this.message);

  @override
  String toString() => message;
}


class QuarantinedException extends ApiException {
  const QuarantinedException(super.message);
}


class ServerException extends ApiException {
  final int statusCode;
  const ServerException(this.statusCode, super.message);
}

class NetworkUnavailableException extends ApiException {
  const NetworkUnavailableException(super.message);
}
