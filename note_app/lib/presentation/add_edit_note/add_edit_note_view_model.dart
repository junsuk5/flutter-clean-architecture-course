import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_note_app/domain/model/note.dart';
import 'package:flutter_note_app/domain/repository/note_repository.dart';
import 'package:flutter_note_app/presentation/add_edit_note/add_edit_note_event.dart';
import 'package:flutter_note_app/presentation/add_edit_note/add_edit_note_ui_event.dart';
import 'package:flutter_note_app/ui/colors.dart';

import 'add_edit_note_state.dart';

class AddEditNoteViewModel with ChangeNotifier {
  final NoteRepository repository;

  AddEditNoteState _state = AddEditNoteState(color: roseBud.value);

  final _eventController = StreamController<AddEditNoteUiEvent>.broadcast();

  Stream<AddEditNoteUiEvent> get eventStream => _eventController.stream;

  AddEditNoteViewModel(this.repository);

  AddEditNoteState get state => _state;

  void setNote(Note note) {
    _state = state.copyWith(
      note: note,
      color: note.color,
    );
    notifyListeners();
  }

  void onEvent(AddEditNoteEvent event) {
    event.when(
      changeColor: _changColor,
      saveNote: _saveNote,
    );
  }

  Future<void> _changColor(int color) async {
    _state = state.copyWith(color: color);
    notifyListeners();
  }

  Future<void> _saveNote(int? id, String title, String content) async {
    if (title.isEmpty || content.isEmpty) {
      _eventController
          .add(const AddEditNoteUiEvent.showSnackBar('제목이나 내용이 비어 있습니다'));
      return;
    }

    if (id == null) {
      await repository.insertNote(
        Note(
            title: title,
            content: content,
            color: _state.color,
            timestamp: DateTime.now().millisecondsSinceEpoch),
      );
    } else {
      await repository.updateNote(
        Note(
            id: id,
            title: title,
            content: content,
            color: _state.color,
            timestamp: DateTime.now().millisecondsSinceEpoch),
      );
    }

    _eventController.add(const AddEditNoteUiEvent.saveNote());
  }
}
