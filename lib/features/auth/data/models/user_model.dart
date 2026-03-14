// Data model that maps between Firestore documents and UserEntity.
// fromFirestore: converts Firestore data → UserModel
// toMap: converts UserModel → Map (to save to Firestore)

import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.uid,
    required super.name,
    required super.email,
    required super.createdAt,
  });

  /// Create a UserModel from a Firestore document map
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
    );
  }

  /// Convert this UserModel to a map for saving to Firestore
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }
}
