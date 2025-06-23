import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_note_app/domain/model/note.dart';
import 'package:flutter_note_app/domain/repository/note_repository.dart';
import 'package:flutter_note_app/presentation/add_edit_note/add_edit_note_event.dart';
import 'package:flutter_note_app/presentation/add_edit_note/add_edit_note_ui_event.dart';
import 'package:flutter_note_app/ui/colors.dart';

class AddEditNoteViewModel with ChangeNotifier {
  final NoteRepository repository;

  int _color = roseBud.toARGB32();

  int get color => _color;

  final _eventController = StreamController<AddEditNoteUiEvent>.broadcast();

  Stream<AddEditNoteUiEvent> get eventStream => _eventController.stream;

  AddEditNoteViewModel(this.repository);

  void onEvent(AddEditNoteEvent event) {
    switch (event) {
      case ChangeColor(:final color):
        _changColor(color);
      case SaveNote(:final id, :final title, :final content):
        _saveNote(id, title, content);
    }
  }

  Future<void> _changColor(int color) async {
    _color = color;
    notifyListeners();
  }

  Future<void> _saveNote(int? id, String title, String content) async {
    if (title.isEmpty || content.isEmpty) {
      _eventController.add(
        const AddEditNoteUiEvent.showSnackBar('제목이나 내용이 비어 있습니다'),
      );
      return;
    }

    if (id == null) {
      await repository.insertNote(
        Note(
          title: title,
          content: content,
          color: _color,
          timestamp: DateTime.now().millisecondsSinceEpoch,
        ),
      );
    } else {
      await repository.updateNote(
        Note(
          id: id,
          title: title,
          content: content,
          color: _color,
          timestamp: DateTime.now().millisecondsSinceEpoch,
        ),
      );
    }

    _eventController.add(const AddEditNoteUiEvent.savedNote());
  }
}
