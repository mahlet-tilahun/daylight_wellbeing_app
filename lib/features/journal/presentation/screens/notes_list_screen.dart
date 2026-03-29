// lib/features/journal/presentation/screens/notes_list_screen.dart
// Shows all notes with search, favorites tab, and delete.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../auth/presentation/widgets/auth_form.dart';
import '../bloc/notes_bloc.dart';
import '../../domain/entities/note_entity.dart';
import 'add_note_screen.dart';

class NotesListScreen extends StatefulWidget {
  const NotesListScreen({super.key});

  @override
  State<NotesListScreen> createState() => _NotesListScreenState();
}

class _NotesListScreenState extends State<NotesListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadNotes();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _loadNotes() {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      context.read<NotesBloc>().add(LoadNotesRequested(authState.user.uid));
    }
  }

  void _deleteNote(String noteId) {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      context.read<NotesBloc>().add(
            DeleteNoteRequested(noteId: noteId, userId: authState.user.uid),
          );
      showSuccessSnackbar(context, 'Note deleted');
    }
  }

  void _toggleFavorite(NoteEntity note) {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      context.read<NotesBloc>().add(ToggleFavoriteRequested(
            noteId: note.noteId,
            userId: authState.user.uid,
            isFavorite: !note.isFavorite,
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppTheme.accentGreen,
          labelColor: AppTheme.accentGreen,
          unselectedLabelColor: AppTheme.textGrey,
          tabs: const [
            Tab(text: 'All Notes'),
            Tab(text: 'Favorites'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openAddNote(),
        backgroundColor: AppTheme.accentGreen,
        child: const Icon(Icons.add, color: AppTheme.navyDark),
      ),
      body: SafeArea(
        bottom: true,
        child: BlocConsumer<NotesBloc, NotesState>(
          listener: (context, state) {
            if (state is NotesError) {
              showErrorSnackbar(context, state.message);
            }
          },
          builder: (context, state) {
            if (state is NotesLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is NotesLoaded) {
              // Filter by search query
              final filtered = state.notes
                  .where((n) =>
                      n.title
                          .toLowerCase()
                          .contains(_searchQuery.toLowerCase()) ||
                      n.content
                          .toLowerCase()
                          .contains(_searchQuery.toLowerCase()))
                  .toList();

              final favorites =
                  filtered.where((n) => n.isFavorite).toList();

              return Column(
                children: [
                  // Search bar
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (val) =>
                          setState(() => _searchQuery = val),
                      style: TextStyle(color: AppTheme.textPrimary(context)),
                      decoration: InputDecoration(
                        hintText: 'search notes',
                        prefixIcon: const Icon(Icons.search,
                            color: AppTheme.textGrey),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear,
                                    color: AppTheme.textGrey),
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() => _searchQuery = '');
                                },
                              )
                            : null,
                      ),
                    ),
                  ),
                  // Tabs content
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildNotesList(filtered),
                        _buildNotesList(favorites),
                      ],
                    ),
                  ),
                ],
              );
            }

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('No notes yet',
                      style: TextStyle(color: Colors.grey, fontSize: 16)),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: _openAddNote,
                    child: const Text('Add your first note'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildNotesList(List<NoteEntity> notes) {
    if (notes.isEmpty) {
      return const Center(
        child: Text('No notes here yet',
            style: TextStyle(color: Colors.grey)),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes[index];
        return _NoteCard(
          note: note,
          onTap: () => _openEditNote(note),
          onDelete: () => _deleteNote(note.noteId),
          onToggleFavorite: () => _toggleFavorite(note),
        );
      },
    );
  }

  void _openAddNote() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddNoteScreen()),
    );
  }

  void _openEditNote(NoteEntity note) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AddNoteScreen(noteToEdit: note)),
    );
  }
}

/// Individual note card widget
class _NoteCard extends StatelessWidget {
  final NoteEntity note;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final VoidCallback onToggleFavorite;

  const _NoteCard({
    required this.note,
    required this.onTap,
    required this.onDelete,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title row with favorite star and delete
              Row(
                children: [
                  Expanded(
                    child: Text(
                      note.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: onToggleFavorite,
                    child: Icon(
                      note.isFavorite ? Icons.star : Icons.star_border,
                      color: note.isFavorite
                          ? AppTheme.accentYellow
                          : AppTheme.textGrey,
                      size: 20,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              // Content preview
              Text(
                note.content,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style:
                    const TextStyle(color: AppTheme.textGrey, fontSize: 13),
              ),
              const SizedBox(height: 8),
              // Date and delete
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    DateFormat('EEE, h:mm a').format(note.createdAt),
                    style: const TextStyle(
                        color: AppTheme.textGrey, fontSize: 11),
                  ),
                  GestureDetector(
                    onTap: onDelete,
                    child: const Icon(Icons.delete_outline,
                        color: Colors.redAccent, size: 18),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
