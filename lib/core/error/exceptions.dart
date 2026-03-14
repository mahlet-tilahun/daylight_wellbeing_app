// lib/core/error/exceptions.dart
// Custom exceptions thrown in the data layer.
// These get caught and converted to Failures in repositories.

/// Thrown when a Firebase/server operation fails
class ServerException implements Exception {
  final String message;
  const ServerException(this.message);
}

/// Thrown when authentication fails
class AuthException implements Exception {
  final String message;
  const AuthException(this.message);
}

/// Thrown when reading/writing local storage fails
class CacheException implements Exception {
  final String message;
  const CacheException(this.message);
}
