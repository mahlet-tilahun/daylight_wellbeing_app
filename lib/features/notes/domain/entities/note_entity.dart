// lib/features/notes/domain/entities/note_entity.dart

import 'package:equatable/equatable.dart';

class NoteEntity extends Equatable {
  final String noteId;
  final String userId;
  final String title;
  final String content;
  final bool isFavorite;
  final DateTime createdAt;

  const NoteEntity({
    required this.noteId,
    required this.userId,
    required this.title,
    required this.content,
    required this.isFavorite,
    required this.createdAt,
  });

  /// Creates a copy with some fields changed — useful for updates
  NoteEntity copyWith({
    String? title,
    String? content,
    bool? isFavorite,
  }) {
    return NoteEntity(
      noteId: noteId,
      userId: userId,
      title: title ?? this.title,
      content: content ?? this.content,
      isFavorite: isFavorite ?? this.isFavorite,
      createdAt: createdAt,
    );
  }

  @override
  List<Object> get props => [noteId, userId, title, content, isFavorite, createdAt];
}
