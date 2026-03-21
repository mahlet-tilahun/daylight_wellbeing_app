// lib/features/mood/data/datasources/mood_remote_datasource.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/utils/constants.dart';
import '../models/mood_model.dart';

abstract class MoodRemoteDataSource {
  Future<MoodModel> addMood({
    required String userId,
    required String moodType,
    String note,
  });
  Future<List<MoodModel>> getMoods({required String userId});
  Future<void> deleteMood({required String moodId});
  Future<void> updateMoodNote({required String moodId, required String note});
}

class MoodRemoteDataSourceImpl implements MoodRemoteDataSource {
  final FirebaseFirestore _firestore;
  final Uuid _uuid;

  MoodRemoteDataSourceImpl({required FirebaseFirestore firestore, Uuid? uuid})
      : _firestore = firestore,
        _uuid = uuid ?? const Uuid();

  @override
  Future<MoodModel> addMood({
    required String userId,
    required String moodType,
    String note = '',
  }) async {
    try {
      final mood = MoodModel(
        moodId: _uuid.v4(),
        userId: userId,
        moodType: moodType,
        note: note,
        createdAt: DateTime.now(),
      );
      await _firestore
          .collection(AppConstants.moodsCollection)
          .doc(mood.moodId)
          .set(mood.toMap());
      return mood;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<MoodModel>> getMoods({required String userId}) async {
    try {
      final snapshot = await _firestore
          .collection(AppConstants.moodsCollection)
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();
      return snapshot.docs
          .map((doc) => MoodModel.fromMap(doc.data()))
          .toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> deleteMood({required String moodId}) async {
    try {
      await _firestore
          .collection(AppConstants.moodsCollection)
          .doc(moodId)
          .delete();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> updateMoodNote(
      {required String moodId, required String note}) async {
    try {
      await _firestore
          .collection(AppConstants.moodsCollection)
          .doc(moodId)
          .update({'note': note});
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
