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

  AddEditNoteState _state = AddEditNoteState(
    title: '',
    content: '',
    color: roseBud.value,
    timestamp: DateTime.now().millisecondsSinceEpoch,
  );

  final _eventController = StreamController<AddEditNoteUiEvent>.broadcast();

  Stream<AddEditNoteUiEvent> get eventStream => _eventController.stream;

  AddEditNoteViewModel(this.repository, {Note? note}) {
    if (note != null) {
      _state = state.copyWith(
        title: note.title,
        content: note.content,
        color: note.color,
        timestamp: note.timestamp,
      );
    }

    notifyListeners();
  }

  AddEditNoteState get state => _state;

  void onEvent(AddEditNoteEvent event) {
    event.when(
      changeColor: _changColor,
      saveNote: _saveNote,
    );
  }

  void setTitle(String title) {
    _state = state.copyWith(title: title);
  }

  void setContent(String content) {
    _state = state.copyWith(content: content);
  }

  Future<void> _changColor(int color) async {
    _state = state.copyWith(color: color);
    notifyListeners();
  }

  Future<void> _saveNote() async {
    if (state.title.isEmpty || state.content.isEmpty) {
      _eventController
          .add(const AddEditNoteUiEvent.showSnackBar('제목이나 내용이 비어 있습니다'));
      return;
    }

    if (state.id == null) {
      await repository.insertNote(
        Note(
            title: state.title,
            content: state.content,
            color: _state.color,
            timestamp: DateTime.now().millisecondsSinceEpoch),
      );
    } else {
      await repository.updateNote(
        Note(
            id: state.id,
            title: state.title,
            content: state.content,
            color: _state.color,
            timestamp: DateTime.now().millisecondsSinceEpoch),
      );
    }

    _eventController.add(const AddEditNoteUiEvent.saveNote());
  }
}
