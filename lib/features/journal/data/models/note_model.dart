// lib/features/journal/data/models/note_model.dart

import '../../domain/entities/note_entity.dart';

class NoteModel extends NoteEntity {
  const NoteModel({
    required super.noteId,
    required super.userId,
    required super.title,
    required super.content,
    required super.isFavorite,
    required super.createdAt,
  });

  factory NoteModel.fromMap(Map<String, dynamic> map) {
    return NoteModel(
      noteId: map['noteId'] as String,
      userId: map['userId'] as String,
      title: map['title'] as String,
      content: map['content'] as String,
      isFavorite: map['isFavorite'] as bool? ?? false,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'noteId': noteId,
      'userId': userId,
      'title': title,
      'content': content,
      'isFavorite': isFavorite,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }
}
