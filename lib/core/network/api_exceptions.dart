class ApiException implements Exception {
  const ApiException({required this.message, this.statusCode});
  final String message;
  final int? statusCode;

  @override
  String toString() => 'ApiException($statusCode): $message';
}

class NetworkException extends ApiException {
  const NetworkException({
    super.message = 'No internet connection. Please check your network.',
    super.statusCode,
  });
}

class TimeoutException extends ApiException {
  const TimeoutException({
    super.message =
        'Request timed out. Please check your connection and try again.',
    super.statusCode,
  });
}

class ServerException extends ApiException {
  const ServerException({
    super.message =
        'Server is temporarily unavailable. Please try again later.',
    super.statusCode,
  });
}

class UnauthorizedException extends ApiException {
  const UnauthorizedException({
    super.message = 'Session expired. Please sign in again.',
    super.statusCode = 401,
  });
}

class ValidationException extends ApiException {
  const ValidationException({
    super.message = 'Validation failed',
    super.statusCode = 422,
    this.fieldErrors = const {},
  });
  final Map<String, List<String>> fieldErrors;

  String? firstErrorFor(String field) {
    final errors = fieldErrors[field];
    return errors != null && errors.isNotEmpty ? errors.first : null;
  }

  String get firstError {
    for (final errors in fieldErrors.values) {
      if (errors.isNotEmpty) return errors.first;
    }
    return message;
  }
}

class RateLimitException extends ApiException {
  const RateLimitException({
    super.message = 'Too many requests. Please wait and try again.',
    super.statusCode = 429,
  });
}

class ConflictException extends ApiException {
  const ConflictException({super.message = 'Conflict', super.statusCode = 409});
}
