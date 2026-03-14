// lib/features/notes/presentation/pages/add_note_screen.dart
// Used for both creating a new note and editing an existing one.
// If noteToEdit is null → we're creating. Otherwise → we're editing.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/validators.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../auth/presentation/widgets/auth_widgets.dart';
import '../bloc/notes_bloc.dart';
import '../../domain/entities/note_entity.dart';

class AddNoteScreen extends StatefulWidget {
  /// Pass a note here if editing an existing note
  final NoteEntity? noteToEdit;

  const AddNoteScreen({super.key, this.noteToEdit});

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;

  // True if we are editing an existing note
  bool get _isEditing => widget.noteToEdit != null;

  @override
  void initState() {
    super.initState();
    // Pre-fill fields if editing
    _titleController =
        TextEditingController(text: widget.noteToEdit?.title ?? '');
    _contentController =
        TextEditingController(text: widget.noteToEdit?.content ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _onSave() {
    if (!_formKey.currentState!.validate()) return;

    final authState = context.read<AuthBloc>().state;
    if (authState is! AuthAuthenticated) return;

    if (_isEditing) {
      context.read<NotesBloc>().add(UpdateNoteRequested(
            noteId: widget.noteToEdit!.noteId,
            userId: authState.user.uid,
            title: _titleController.text.trim(),
            content: _contentController.text.trim(),
          ));
    } else {
      context.read<NotesBloc>().add(AddNoteRequested(
            userId: authState.user.uid,
            title: _titleController.text.trim(),
            content: _contentController.text.trim(),
          ));
    }

    showSuccessSnackbar(
        context, _isEditing ? 'Note updated!' : 'Note saved!');
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Note' : 'New Note'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Title field
              TextFormField(
                controller: _titleController,
                validator: Validators.validateNoteTitle,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
                decoration: const InputDecoration(
                  hintText: 'Note Title',
                  border: InputBorder.none,
                  hintStyle: TextStyle(
                      color: AppTheme.textGrey,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const Divider(color: AppTheme.navyCard),
              const SizedBox(height: 8),

              // Content area — expands to fill available space
              Expanded(
                child: TextFormField(
                  controller: _contentController,
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  style: TextStyle(color: AppTheme.textPrimary(context), fontSize: 15),
                  decoration: const InputDecoration(
                    hintText: 'Start Typing....',
                    border: InputBorder.none,
                    hintStyle:
                        TextStyle(color: AppTheme.textGrey, fontSize: 15),
                  ),
                ),
              ),

              // Save button at the bottom
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: SizedBox(
                  width: 120,
                  child: ElevatedButton(
                    onPressed: _onSave,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.accentGreen,
                      foregroundColor: AppTheme.navyDark,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                    child: const Text('Save',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
