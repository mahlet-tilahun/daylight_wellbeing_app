// lib/features/auth/domain/entities/user_entity.dart
// Pure Dart class — no Firebase imports here.
// This represents a User in our app's domain (business logic) layer.

import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String uid;
  final String name;
  final String email;
  final DateTime createdAt;

  const UserEntity({
    required this.uid,
    required this.name,
    required this.email,
    required this.createdAt,
  });

  @override
  List<Object> get props => [uid, name, email, createdAt];
}
