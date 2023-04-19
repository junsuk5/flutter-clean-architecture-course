import 'package:flutter_note_app/di/provider_setup.dart';
import 'package:flutter_note_app/domain/model/note.dart';
import 'package:flutter_note_app/domain/use_case/use_cases.dart';
import 'package:flutter_note_app/domain/util/note_order.dart';
import 'package:flutter_note_app/domain/util/order_type.dart';
import 'package:flutter_note_app/presentation/notes/notes_event.dart';
import 'package:flutter_note_app/presentation/notes/notes_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';

final notesViewModel = StateNotifierProvider<NotesViewModel, NotesState>(
    (ref) => getIt<NotesViewModel>());

@injectable
class NotesViewModel extends StateNotifier<NotesState> {
  final UseCases useCases;

  Note? _recentlyDeletedNote;

  NotesViewModel(
    this.useCases,
  ) : super(NotesState(
          notes: [],
          noteOrder: const NoteOrder.date(OrderType.descending()),
          isOrderSectionVisible: false,
        )) {
    _loadNotes();
  }

  void onEvent(NotesEvent event) {
    event.when(
      loadNotes: _loadNotes,
      deleteNote: _deleteNote,
      restoreNote: _restoreNote,
      changeOrder: (NoteOrder noteOrder) {
        state = state.copyWith(
          noteOrder: noteOrder,
        );
        _loadNotes();
      },
      toggleOrderSection: () {
        state = state.copyWith(
          isOrderSectionVisible: !state.isOrderSectionVisible,
        );
      },
    );
  }

  Future<void> _loadNotes() async {
    List<Note> notes = await useCases.getNotes(state.noteOrder);
    state = state.copyWith(
      notes: notes,
    );
  }

  Future<void> _deleteNote(Note note) async {
    await useCases.deleteNote(note);
    _recentlyDeletedNote = note;

    await _loadNotes();
  }

  Future<void> _restoreNote() async {
    if (_recentlyDeletedNote != null) {
      await useCases.addNote(_recentlyDeletedNote!);
      _recentlyDeletedNote = null;

      _loadNotes();
    }
  }
}
