// lib/core/error/failures.dart
// Represents different types of failures in the app.
// Using sealed classes ensures we handle every case.

import 'package:equatable/equatable.dart';

/// Base class for all failures
abstract class Failure extends Equatable {
  final String message;
  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

/// Failure from server/Firebase errors
class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

/// Failure when user is not authenticated
class AuthFailure extends Failure {
  const AuthFailure(super.message);
}

/// Failure for network issues
class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

/// Failure for local storage issues
class CacheFailure extends Failure {
  const CacheFailure(super.message);
}
