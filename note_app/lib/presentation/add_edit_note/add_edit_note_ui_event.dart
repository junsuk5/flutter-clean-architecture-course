import 'package:flutter_note_app/domain/model/note.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'add_edit_note_ui_event.freezed.dart';

@freezed
abstract class AddEditNoteUiEvent with _$AddEditNoteUiEvent {
  const factory AddEditNoteUiEvent.saveNote() = SaveNote;
  const factory AddEditNoteUiEvent.showSnackBar(String message) = ShowSnackBar;
  const factory AddEditNoteUiEvent.loadNote(Note note) = LoadNote;
}

