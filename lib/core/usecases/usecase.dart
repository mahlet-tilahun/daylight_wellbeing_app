// lib/core/usecases/usecase.dart
// Base interface for all use cases.
// Every use case takes Params and returns Either<Failure, Type>.
// We use a simple Result type instead of dartz for simplicity.

/// Simple result type: either a failure or a success value
class Result<T> {
  final T? data;
  final String? error;

  const Result.success(this.data) : error = null;
  const Result.failure(this.error) : data = null;

  bool get isSuccess => error == null;
  bool get isFailure => error != null;
}

/// Base class for use cases with parameters
abstract class UseCase<T, Params> {
  Future<Result<T>> call(Params params);
}

/// Base class for use cases with no parameters
abstract class UseCaseNoParams<T> {
  Future<Result<T>> call();
}

/// Used when a use case needs no parameters
class NoParams {}
