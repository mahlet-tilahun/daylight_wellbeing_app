// lib/features/journal/data/datasources/notes_remote_datasource.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/utils/constants.dart';
import '../models/note_model.dart';

abstract class NotesRemoteDataSource {
  Future<NoteModel> addNote({
    required String userId,
    required String title,
    required String content,
  });
  Future<List<NoteModel>> getNotes({required String userId});
  Future<NoteModel> updateNote({
    required String noteId,
    required String title,
    required String content,
  });
  Future<void> deleteNote({required String noteId});
  Future<void> toggleFavorite({
    required String noteId,
    required bool isFavorite,
  });
}

class NotesRemoteDataSourceImpl implements NotesRemoteDataSource {
  final FirebaseFirestore _firestore;
  final Uuid _uuid;

  NotesRemoteDataSourceImpl({required FirebaseFirestore firestore, Uuid? uuid})
    : _firestore = firestore,
      _uuid = uuid ?? const Uuid();

  CollectionReference get _notes =>
      _firestore.collection(AppConstants.notesCollection);

  @override
  Future<NoteModel> addNote({
    required String userId,
    required String title,
    required String content,
  }) async {
    try {
      final note = NoteModel(
        noteId: _uuid.v4(),
        userId: userId,
        title: title,
        content: content,
        isFavorite: false,
        createdAt: DateTime.now(),
      );
      await _notes.doc(note.noteId).set(note.toMap());
      return note;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<NoteModel>> getNotes({required String userId}) async {
    try {
      final snapshot = await _notes.where('userId', isEqualTo: userId).get();

      return snapshot.docs
          .map((doc) => NoteModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<NoteModel> updateNote({
    required String noteId,
    required String title,
    required String content,
  }) async {
    try {
      await _notes.doc(noteId).update({'title': title, 'content': content});
      final doc = await _notes.doc(noteId).get();
      return NoteModel.fromMap(doc.data() as Map<String, dynamic>);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> deleteNote({required String noteId}) async {
    try {
      await _notes.doc(noteId).delete();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> toggleFavorite({
    required String noteId,
    required bool isFavorite,
  }) async {
    try {
      await _notes.doc(noteId).update({'isFavorite': isFavorite});
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
