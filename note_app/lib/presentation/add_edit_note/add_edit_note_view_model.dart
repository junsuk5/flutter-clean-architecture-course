import 'dart:async';

import 'package:flutter_note_app/domain/model/note.dart';
import 'package:flutter_note_app/domain/repository/note_repository.dart';
import 'package:flutter_note_app/presentation/add_edit_note/add_edit_note_event.dart';
import 'package:flutter_note_app/presentation/add_edit_note/add_edit_note_ui_event.dart';
import 'package:flutter_note_app/ui/colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';

@injectable
class AddEditNoteViewModel extends StateNotifier<int> {
  final NoteRepository repository;

  final _eventController = StreamController<AddEditNoteUiEvent>.broadcast();

  Stream<AddEditNoteUiEvent> get eventStream => _eventController.stream;

  AddEditNoteViewModel(this.repository) : super(roseBud.value);

  void onEvent(AddEditNoteEvent event) {
    event.when(
      changeColor: _changColor,
      saveNote: _saveNote,
    );
  }

  void loadNoteById(int id) async {
    final note = await repository.getNoteById(id);
    if (note != null) {
      state = note.color;
      _eventController.add(AddEditNoteUiEvent.loadNote(note));
    }
  }

  Future<void> _changColor(int color) async {
    state = color;
  }

  Future<void> _saveNote(int? id, String title, String content) async {
    if (title.isEmpty || content.isEmpty) {
      _eventController.add(const AddEditNoteUiEvent.showSnackBar('제목이나 내용이 비어 있습니다'));
      return;
    }

    if (id == null) {
      await repository.insertNote(
        Note(
            title: title,
            content: content,
            color: state,
            timestamp: DateTime.now().millisecondsSinceEpoch),
      );
    } else {
      await repository.updateNote(
        Note(
            id: id,
            title: title,
            content: content,
            color: state,
            timestamp: DateTime.now().millisecondsSinceEpoch),
      );
    }

    _eventController.add(const AddEditNoteUiEvent.saveNote());
  }
}
